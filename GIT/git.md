


# [git](https://git-scm.com/)

```mermaid
flowchart TB
subgraph L1
    direction LR
    subgraph File status
        direction TB
        git_Untracked["untracked - не добавлен"]
        git_Staged["Staged - Отслеживается"]
        
        git_Copied["Copied - Выполнен commit"]
    end
    subgraph Branch actions
        direction TB
        Branch_action_Merge["Merge
        Слияние"]
        Branch_action_Rebase["Rebase 
        перебазирования коммитов 
        на конец другой ветки"]
        Branch_action_Cherry-pick["Cherry-pick
        Перенос определённого commit"]
        Branch_action_Squash["Squash
        Слияние commit"]
        Branch_action_Patch["Patch
        Перенос изменений через diff-файлы.
        "]
    end
end
subgraph L2
    direction TB
subgraph Config
direction LR
git_config_list["Отслеживание
    git config --list --show-origin # Настройки
"]
git_config_add["Добавление
git config --global user.name user
git config --global user.email aaa@bbb.ccc
"]
git_config_location["Откат(Файлы настроек)
~/.gitconfig # config --global
./project/.git # repo_url; db;
"]
git_auth["auth
~/.ssh/id_ed25519.key || ~/.ssh/id_rsa
~/.ssh/id_ed25519 || .ssh/id_rsa.pub -> gitlab.com
"]

end
subgraph Repo
direction LR
git_Repo_remote["Отслеживание
git remote -v
"]
git_Repo_add["Добавление
git init
git clone URL
"]
git_Repo_update["Откат(Актуализация)
git fetch origin
git pull origin main
"]
git_Repo_delete["Удаление(Изменение URL)
git remote set-url origin [ssh-url]
"]

end
subgraph File
direction LR
git_File_status["Отслеживание
git status"]
git_File_add["Добавление
git add ."]
git_File_checkout["Откат
git checkout -- ./test.txt
git checkout 'branch_or_commit' -- 'file_path'
"]
git_File_rm["Удаление
git rm ./test.txt"]
git_File_diff["Просмотр
git diff --staged
"]
git_File_ignore[".gitignore"]
end
subgraph Commit
direction LR
git_commit_log1["Отслеживание
git log [--all] [--oneline || -p] [--grep='баг' || --graph]
"]
git_commit["Добавление
git commit -m 'Init commit' "]
git_commit_checkout["Откат
git checkout 'commit_hash'"]
git_commit_delete["Удаление
git reset [--hard || --soft ] HEAD~2
git rebase -i HEAD~10
"]
git_commit_log2["Просмотр
git log -p || git show 'commit_hash'
"]
git_push["Отправка
git push [url_assign_name] [branch]
git push origin main"]
end
subgraph Branch
direction LR
git_branch_branch["Отслеживание
git branch [-a || -r] -v
"]
git_branch_add["Добавление
git branch имя_новой_ветки
git checkout -b имя_новой_ветки"]

git_branch_checkout["Откат(Переключение)
git [checkout||switch] main"]
git_branch_delete["Удаление
git branch [-d||-D] feature/login
git push origin --delete feature/login
"]
git_branch_remote_show["Просмотр
git remote show origin
git diff main origin/main
"]

end
end

    L1 --> L2 
```

## Rebase

```shell
main: com1 -> com2 -> com3 -> com4
                      \
dev:                   dev1 -> dev2

git checkout dev
git rebase main

main: com1 -> com2 -> com3 -> com4
                                  \
dev:                               dev1' -> dev2'


git checkout main
git rebase dev

dev: com1 -> com2 -> com3 -> dev1 -> dev2
                                  \
main:                              com4'
```




```shell
git init

git clone 

# Полезно, при изменении http на ssh 
git remote set-url origin [ssh-url]


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