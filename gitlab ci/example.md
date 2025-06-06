
# variables
## Пример 1

```yaml
debug:job:
  stage: test
  variables:
    TEST_VAR: "foo"
  script:
    - 'sleep 1'
  rules:
    - if: $CI_COMMIT_REF_PROTECTED == "true" # can use trigger variables for evaluation
      variables:
        TEST_VAR: "$CI_DEFAULT_BRANCH" # can expand project variables into other variables

```

# inputs
## Пример 1
* Это особые переменные, которые задаются перед заданиями. 
* Можно задавать тип и дефолтное значение.
* Можно применять к env.
* variables в test:trigger распространяются только на подзадания.
```yaml
include: # Объявление из include
  - project: 'library/ci'
    file:
      - 'root.gitlab-ci.yaml'
    inputs:
      str-input: "bar"
      bool-input: true

spec:
  inputs:
    str-input:
      default: "foo"
    bool-input:
      type: boolean
      default: false
---
test:trigger:
  stage: build
  variables:
    UPSTREAM_STR_INPUT: $[[ inputs.test-input | expand_vars ]]
    UPSTREAM_BOOL_INPUT: $[[ inputs.run-test ]]
  trigger:
    include:
      - project: 'library/ci'
        ref: 'main'
        file: 'docker_build/.gitlab-ci.yaml'
    strategy: depend
  rules:
    - if: ' "$[[ inputs.bool-input ]]" == "true" '


```


# Зависимости заданий.
## Пример 1
Дано:
* debug:job - `if: $CI_DEBUG_TRACE == "true"`
* build1:job - `if: '"$[[ inputs.build1 ]]" == "true"'`
* build2:job - `if: '"$[[ inputs.build2 ]]" == "true"'`
* docker_builder:trigger - `if: ' "$[[ inputs.docker_builder ]]" == "true" '`
* deploy:job - `needs [debug:job, build1:job, build2:job]`
* auto_merge:trigger - `needs: [deploy:job, docker_builder.trigger]`
```yaml
spec:
  inputs:
    build1:
      type: boolean
      default: false
    build2:
      type: boolean
      default: false
    docker_builder:
      type: boolean
      default: false
---
variables:
  CI_DEBUG_TRACE: "false"

stages:
  - test
  - build
  - deploy
  - final

debug:job:
  stage: test
  script:
    - 'sleep 1'
  rules:
    - if: $CI_DEBUG_TRACE == "true"
      when: always
    - when: never

build1:job:
  stage: build
  script:
    - 'sleep 30'
  rules:
    - if: '"$[[ inputs.build1 ]]" == "true"'
      when: always
    - when: never

build2:job:
  stage: build
  script:
    - 'sleep 30'
  rules:
    - if: '"$[[ inputs.build2 ]]" == "true"'
      when: always
    - when: never

docker_builder:
  stage: build
  trigger:
    include:
      - project: 'library/ci'
        ref: 'main'
        file: 'docker_build/.gitlab-ci.yaml'
    strategy: depend # Задание не завершится, пока не завершатся вложенные задания.
  rules:
    - if: ' "$[[ inputs.docker_builder ]]" == "true" '

deploy:job:
  image:
    name: "alpine"
    entrypoint: ["/bin/ash", "-c"]
    pull_policy:
      - "if-not-present"
  stage: deploy
  script:
    - 'ls -all ./'
  needs:
    - job: debug:job
      optional: true # Если задание отсутствует, зависимость игнорируется.
    - job: build1:job
      optional: true
    - job: build2:job
      optional: true

auto_merge:
  stage: deploy
  variables:
    UPSTREAM_TEST_INPUT: $[[ inputs.test-input | expand_vars ]]
    UPSTREAM_TEST: $[[ inputs.run-test ]]
  trigger:
    include:
      - project: 'library/ci'
        ref: 'main'
        file: 'auto_merge/.gitlab-ci.yaml'
    strategy: depend
  rules: # Аналогично optional, но по условию needs задаётся целиком.
    - if: ' "$[[ inputs.docker_builder ]]" == "true" '
      needs: ['docker_builder']


```