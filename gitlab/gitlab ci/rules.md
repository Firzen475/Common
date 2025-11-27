
## Теория

Обычный push в незащищенную ветку
CI_PIPELINE_SOURCE = `push`
CI_COMMIT_REF_PROTECTED = false
CI_COMMIT_BRANCH = <Имя ветки>

Любые действия не связанные с продакшеном:
- Тестирование
- Развёртывание в тестовое пространство.

merge request
CI_PIPELINE_SOURCE = `merge_request_event`
CI_MERGE_REQUEST_SOURCE_BRANCH_NAME = CI_COMMIT_REF_NAME
CI_MERGE_REQUEST_TARGET_BRANCH_NAME = CI_DEFAULT_BRANCH
CI_MERGE_REQUEST_TARGET_BRANCH_PROTECTED
CI_MERGE_REQUEST_SOURCE_BRANCH_PROTECTED = CI_COMMIT_REF_PROTECTED

Действия, связанные с применением изменений к target_branch:
- Углублённое тестирование
- Развертывание инфраструктуры для review
- Артефакты для review

Push в защищенную ветку
CI_PIPELINE_SOURCE = `push`
CI_COMMIT_REF_PROTECTED = true
CI_COMMIT_BRANCH = <Имя ветки>

Действия связанные с продакшеном
- Изменение инфраструктуры продакшена
- Сборка эталонных артефактов
- Создание и в альтернативные ветки package registry промежуточных артефактов

Push тега
CI_COMMIT_TAG = CI_COMMIT_REF_NAME = <Тег>
CI_PIPELINE_SOURCE = `push`
CI_COMMIT_REF_PROTECTED = false
CI_DEFAULT_BRANCH = <Имя основной ветки>

Без привязки к коммиту не имеет информации о ветви, только CI_DEFAULT_BRANCH
Соответственно, может быть настроен так, чтобы не выполнять действия без привязки к коммиту



## Основные переменные CI\CD
### CI_PIPELINE_SOURCE

| Значение                        | Описание                                                                                     |
|---------------------------------|---------------------------------------------------------------------------------------------|
| `push`                           | Пайплайн запущен из-за пуша в репозиторий (`git push`).                                      |
| `web`                            | Пайплайн запущен вручную через веб-интерфейс GitLab (`Run pipeline`).                        |
| `trigger`                        | Пайплайн запущен через [trigger token](https://docs.gitlab.com/ee/ci/triggers/).            |
| `schedule`                       | Пайплайн запущен по расписанию (`CI/CD > Schedules`).                                        |
| `api`                             | Пайплайн запущен через GitLab API.                                                          |
| `external`                        | Пайплайн вызван из внешнего источника (например, мульти-проектные триггеры).                |
| `pipeline`                        | Пайплайн запущен как дочерний от другого пайплайна (`child pipeline`).                       |
| `chat`                             | Пайплайн запущен через GitLab ChatOps (бот).                                                |
| `webide`                           | Пайплайн запущен через GitLab Web IDE.                                                     |
| `merge_request_event`             | Пайплайн создан автоматически для merge request (MR pipeline).                             |
| `external_pull_request_event`     | Пайплайн создан для внешнего PR (например, из GitHub при импорте через GitLab).             |
| `parent_pipeline`                 | Пайплайн запущен как часть родительского пайплайна (например, через `workflow:trigger`).    |

```yaml
job:
  script: echo "Run only for scheduled pipelines"
  rules:
    - if: '$CI_PIPELINE_SOURCE == "schedule"'

```
### CI_COMMIT_TAG

| **Сценарий события**          | **CI_COMMIT_TAG** | **CI_COMMIT_BRANCH**            | **Комментарии**                                   |
| ----------------------------- | ----------------- | ------------------------------- | ------------------------------------------------- |
| Push в обычную ветку          | ❌ пусто           | ✅ имя ветки                     | Тег отсутствует, пуш обычный                      |
| Push тега                     | ✅ имя тега        | ✅ имя тега                      | Переменная `CI_COMMIT_REF_NAME` совпадает с тегом |
| Merge Request (ветка)         | ❌ пусто           | ✅ исходная ветка                | MR не создаёт тег                                 |
| Pipeline вручную на ветке     | ❌ пусто           | ✅ выбранная ветка               | Ручной запуск в ветку                             |
| Pipeline вручную на теге      | ✅ имя тега        | ✅ имя тега                      | Ручной запуск на теге                             |
| Scheduled Pipeline (по ветке) | ❌ пусто           | ✅ ветка, указанная в расписании | Теги не участвуют                                 |
| Scheduled Pipeline (по тегу)  | ✅ имя тега        | ✅ имя тега                      | Если расписание на тег                            |

```yaml
job:
  script: echo "Run only for scheduled pipelines"
  rules:
    - if: '!$CI_COMMIT_TAG'
      

```

### CI_COMMIT_BRANCH

| Сценарий пайплайна                         | `CI_COMMIT_BRANCH`       | 
|--------------------------------------------|--------------------------|
| Пуш в ветку (например, `main`)             | main                     |  
| Пуш тега (например, `v1.0.0`)              | пусто                    | 
| Merge Request pipeline                     | source_branch            |  
| Merge Request pipeline на target branch    | target_branch или пусто* |
| Pipeline, запущенный вручную (UI/API)      | пусто или указан ref     |  
| Pipeline на конкретный SHA (detached HEAD) | пусто                    |           


### CI_COMMIT_REF_PROTECTED

| Сценарий                | `CI_COMMIT_REF_PROTECTED` |
| ----------------------- | ------------------------- |
| Push в защищённую ветку | `true`                    |
| Push в обычную ветку    | `false`                   |
| MR в защищённую ветку   | `true`                    |
| MR в обычную ветку      | `false`                   |

```yaml
job:
  script: echo "Run only for scheduled pipelines"
  rules:
    - if: '!$CI_COMMIT_TAG'
      
```