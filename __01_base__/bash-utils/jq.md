
### Создать json
```shell
jq -n \
  --arg name "$USER" \
  --argjson sub "$(jq -n --arg one 'Apple' --arg two 'Banana' '$ARGS.named')" \
  --argjson fooBoolean "true"
  '$ARGS.named' > data.json
# или
echo '{"name": "root","sub": {"one": "Apple","two": "Banana"},"fooBoolean": true }' | jq .
```

```json
{
  "name": "root",
  "sub": {
    "one": "Apple",
    "two": "Banana"
  },
  "fooBoolean": true
}

```



### Получить значение по условию с форматированием или выполнением
```json
{
  "apiVersion": "v1",
  "items": [
    {
      "metadata": {
        "name": "pvc-1",
        "namespace": "ns1"
      },
      "status": {
        "phase": "Bound"
      }
    },
    {
      "metadata": {
        "name": "pvc-2",
        "namespace": "ns1"
      },
      "status": {
        "phase": "Bound"
      }
    },
    {
      "metadata": {
        "name": "pvc-3",
        "namespace": "ns2"
      },
      "status": {
        "phase": "Bound"
      }
    }
  ]
}
```
```shell
#              Источник json         | --raw-output / -r разбить вывод построчно
#                                    | --join-output / -j объединить вывод в одну строку
#                                             [...] помещает результат в массив для дальнейшего использования
#                                             выбор массива относительно корня
#                                                      | оставляет элементы массива соответствующие выборке
#                                                                                         | получение имён из оставшихся элементов массива                                                                                                     
#                                                                                                            | объединяет массив в строку и дополняет каждый элемент
#                                                                                                                                      | дополняет строку в начале
kubectl get persistentvolume -o json | jq -r '[.items[] | select(.status.phase == "Bound") | .metadata.name] | join(",metadata.name=") | "metadata.name=\(.)"' 
# >> res1
# >> res2
kubectl get persistentvolume -o json | jq -r '.items[] | select(.status.phase == "Bound") | .metadata.name' \
# | xargs - разбивает вывод на итерацию
#         -n1 количество элементов на вывод (как колонки)
#             -I переопределение переменной для дальнейшего использования
#                  | команда, выполняемая для каждой итерации                    {} объявленная переменная
  | xargs -n1 -I {} kubectl get persistentvolumes --field-selector=metadata.name={}
```
* res1 - массив
```shell 
[
  "pvc-023039f3-82be-4235-b710-51556bdc6dc0",
  "pvc-04facc38-3ba9-4d76-a525-6adbb82aa269",
  "pvc-186edb74-e4f9-492e-b3f0-62892792e43e",
  "pvc-33943531-0328-48a1-a1e0-938124cce315",
  "pvc-5b83b78a-c4bd-40a5-bcdd-fa6a445ec1d2",
  "pvc-74b19db2-2755-4eba-98e1-9abbf99c6022",
  "pvc-7c4faff2-05fa-40cd-8668-f928839e1e37",
  "pvc-84345efe-0a65-4c1a-962d-825f5cce89de",
  "pvc-af315775-6d95-4015-9f15-7502f1036c40",
  "pvc-c7232029-146d-4134-850c-3407a3562a5c",
  "pvc-cf6fdd1c-082e-4751-8eb5-a819a87976ee",
  "pvc-d75d2188-e6a1-46dc-ac3b-67e3ce8763d0",
  "pvc-ea9d886b-5986-446c-aa27-173ce0c1d33f"
]
```
* res2 - строка
```shell 
metadata.name=pvc-023039f3-82be-4235-b710-51556bdc6dc0,...,metadata.name=pvc-ea9d886b-5986-446c-aa27-173ce0c1d33f
```

### Редактирование json
```json
{
  "root": [
    {
      "sensitive": 1,
      "key": "value",
      "value": {
        "name": "srv1"
      }
    },
    {
      "sensitive": 2,
      "key": "value",
      "value": {
        "name": "srv2"
      }
    },
    {
      "sensitive": 3,
      "sub": {
        "key": "value",
        "value": {
          "name": "srv3"
        }
      }
    }
  ]
}
```
```shell
#     | Удаление ключа для каждого элемента
#                                | Начало построителя json
#                                | walk() Рекурсивно обходит дерево
#                                |      if type: {} and "key": "value" then
#                                |         "key": "hosts" and
#                                |         "value": {"key": "foo"} => "value": [{"foo": null}]
#                                |         add слияние массива [{"foo": null}] => {"foo": null}
#                                |      else
#                                |         Оставить элемент как есть.
jq -r 'del(.root[]|."sensitive") | walk(if type == "object" and .key == "value" then .key = "hosts" | .value = ( .value | map({(.) : null} ) | add )  else . end)'
# >> res3
```
* res3 - json
```json
{
  "root": [
    {
      "key": "hosts",
      "value": {
        "srv1": null
      }
    },
    {
      "key": "hosts",
      "value": {
        "srv2": null
      }
    },
    {
      "sub": {
        "key": "hosts",
        "value": {
          "srv3": null
        }
      }
    }
  ]
}
```





















