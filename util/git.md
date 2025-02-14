


# [git](https://git-scm.com/)

```shell

# Структура ветки
git log --all --graph

# Статус
git status

# Удаление файла из кеша
git rm --cached .idea/.gitignore

# Чистка последнего коммита
git checkout main # Выбор локальной ветки
git commit --amend # Редактирует локальную ветку
git push --force # Принудительно пушит ветку

# Чистка всех коммитов
git rebase -i HEAD~10
git push --force

# Удаление последнего коммита локально
git reset HEAD^

```