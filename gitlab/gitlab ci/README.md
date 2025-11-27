




# GitLab Push / Merge Scenarios with CI/CD

| № | Тип ветки источника | Тип ветки приёмника | MR | MR Approve | CI/CD                                            | Комментарий |
|---|---------------------|---------------------|----|------------|--------------------------------------------------|-------------|
| 1 | Обычная             | Обычная             | ❌  | ❌          | push pipeline (source)                           |             |
| 2 | Обычная             | Обычная             | ✅  | ❌          | merge_request pipeline -> push pipeline (target) |             |
| 3 | Обычная             | Защищённая          | ❌  | —          | push pipeline (target) (если разрешён)           |             |
| 4 | Обычная             | Защищённая          | ✅  | ✅          | merge_request pipeline -> push pipeline (target) |             |
| 5 | Обычная             | Защищённая          | ✅  | ❌          | merge_request pipeline -> push pipeline (target) |             |
| 5 | Защищённая          | Обычная             | ❌  | ❌          | push pipeline (target)                           |             |
| 6 | Защищённая          | Обычная             | ✅  | ❌          | merge_request pipeline -> push pipeline (target) |             |
| 7 | Защищённая          | Защищённая          | ❌  | —          | push pipeline (target) (если разрешён)           |             |
| 8 | Защищённая          | Защищённая          | ✅  | ✅          | merge_request pipeline -> push pipeline (target) |             |




```shell




```