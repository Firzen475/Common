

curl -k -X PUT -H "Authorization: Bearer glpat-s-0PtisrHECOdjd5dccsQ286MQp1Om0H.01.0w01dfuyt" \
  -d skip_ci=true \
  "https://gitlab.fzen.pro/api/v4/projects/13/merge_requests/1/rebase"

curl -k -X POST -H "Authorization: Bearer glpat-s-0PtisrHECOdjd5dccsQ286MQp1Om0H.01.0w01dfuyt" \
  "https://gitlab.fzen.pro/api/v4/projects/13/merge_requests/1/approve"


curl -k -f -X PUT \
  -H "Authorization: Bearer glpat-f0ZHValHNnct_rdlkhvLo286MQp1Om4H.01.0w1xud9z3" \
  -d remove_source_branch=false \
  "https://gitlab.fzen.pro/api/v4/projects/2/merge_requests/5"

curl -k -f -X PUT \
  -H "Authorization: Bearer glpat-f0ZHValHNnct_rdlkhvLo286MQp1Om4H.01.0w1xud9z3" \
  -d should_remove_source_branch=false \
  -d auto_merge_strategy="merge_when_pipeline_succeeds" \
  -d squash=true \
  -d squash_commit_message="123" \
  "https://gitlab.fzen.pro/api/v4/projects/2/merge_requests/5/merge"


```shell
get_tag_list() {
  local token="${1:?Не передан токен авторизации}"
  
  # Проверка обязательных переменных CI
  : "${CI_API_V4_URL:?Не задана переменная CI_API_V4_URL}"
  : "${CI_PROJECT_ID:?Не задана переменная CI_PROJECT_ID}"
  
  # Запрос к GitLab API для получения тегов
  curl -s -k -f -X GET \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    "$CI_API_V4_URL/projects/$CI_PROJECT_ID/repository/tags"
  
}
.gitlab-api-tags: |
  create_next_tag() {
    local token="${1:?Не передан токен авторизации}"
  
    : "${CI_API_V4_URL:?Не задана переменная CI_API_V4_URL}"
    : "${CI_PROJECT_ID:?Не задана переменная CI_PROJECT_ID}"
    : "${CI_DEFAULT_BRANCH:?Не задана переменная CI_DEFAULT_BRANCH}"
  
    # Получаем теги с нужным мажором и минором, отсортированные по версии (desc)
    TAGS_JSON=$(curl -s -k -f -X GET \
        -H "Authorization: Bearer ${token}" \
        "$CI_API_V4_URL/projects/$CI_PROJECT_ID/repository/tags?order_by=version&sort=desc&search=^${AUTO_TAG_VARSION_PREFIX}${AUTO_TAG_VARSION_MAJOR}.${AUTO_TAG_VARSION_MINOR}.")
  
    # Выбираем только теги с релизом
    LAST_TAG=$(echo "$TAGS_JSON" | awk '
      /"name":/ {name=$4}
      /"release":/ {release_line=1}
      /}/ {if(release_line==1){print name; release_line=0}}
    ' | head -1)
    
    log_info "$LAST_TAG"
  
    if [ -z "$LAST_TAG" ]; then
      # Нет тегов с релизом — создаем первый PATCH=0 на дефолтной ветке
      patch=0
      ref="$CI_DEFAULT_BRANCH"
    else
      # Есть тег с релизом — вычисляем PATCH
      patch=$(echo "$LAST_TAG" | awk -F'.' '{print $3}')
      patch=$((patch + 1))
  
      # Находим commit ref последнего релиза
      ref=$(echo "$TAGS_JSON" | awk -v tag="$LAST_TAG" -F'"' '
        $0 ~ "\"name\": \""tag"\"" {getline; getline; print $4; exit}
      ')
    fi
  
    # Формируем имя нового тега
    new_tag="${AUTO_TAG_VARSION_PREFIX}${AUTO_TAG_VARSION_MAJOR}.${AUTO_TAG_VARSION_MINOR}.${patch}"
    echo "Создаем тег: $new_tag (ref: $ref)"
  
    # Создаем тег через API
    curl -s -k -f -X POST \
      -H "Authorization: Bearer ${token}" \
      -d tag_name="$new_tag" \
      -d ref="$ref" \
      "$CI_API_V4_URL/projects/$CI_PROJECT_ID/repository/tags"
  }

create_release_with_artifacts() {
    local token="${1:?Не передан токен авторизации}"
    local ARTIFACTS_DIR="$2"

    # Данные релиза
    local POST_DATA=(
        -d "name=Release $CI_COMMIT_TAG"
        -d "tag_name=$CI_COMMIT_TAG"
        -d "description=Automated release for tag $CI_COMMIT_TAG"
    )

    # Если есть артефакты, добавляем их как links
    if [ -d "$ARTIFACTS_DIR" ] && [ "$(ls -A "$ARTIFACTS_DIR" 2>/dev/null)" ]; then
        log_info "📦 Found artifact directories — preparing assets..."

        for package_dir in "$ARTIFACTS_DIR"/*; do
            [ -d "$package_dir" ] || continue
            local PACKAGE_NAME
            PACKAGE_NAME=$(basename "$package_dir")
            log_info "📂 Processing package: $PACKAGE_NAME"

            for file in "$package_dir"/*; do
                [ -f "$file" ] || continue
                local filename
                filename=$(basename "$file")

                log_info "🔗 Adding asset link for $PACKAGE_NAME → $filename"
                POST_DATA+=(-d "assets[links][][name]=$PACKAGE_NAME/$filename")
                POST_DATA+=(-d "assets[links][][url]=$CI_API_V4_URL/projects/$CI_PROJECT_ID/packages/generic/$PACKAGE_NAME/$VERSION/$filename")
            done
        done
    else
        log_info "⚠️ No artifacts found — release will be created without assets."
    fi

    # URL GitLab API
    local API_URL="$CI_API_V4_URL/projects/$CI_PROJECT_ID/releases"
    
    curl -k -f -X POST \
      -H "Authorization: Bearer ${token}" \
      "${POST_DATA[@]}" \
      "$API_URL"
      
}

```