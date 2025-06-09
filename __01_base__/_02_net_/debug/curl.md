

# Коды
| Код состояния                  | Описание                                                      |
|--------------------------------|---------------------------------------------------------------|
| **1xx: Информационные ответы** |                                                               |
| 100                            | Сервер ожидает оставшуюся часть запроса.                      |
| 101                            | Сервер согласен сменить протокол (например, на WebSocket).    |
| 102                            | Сервер обрабатывает запрос, но ответ ещё не готов.            |
| **2xx: Успешные ответы**       |
| 200                            | Успешный запрос (например, `curl -I https://example.com`).    |
| 201                            | Ресурс успешно создан (POST-запрос).                          |
| 202                            | Запрос принят, но ещё не обработан.                           |
| 204                            | Успешный запрос, но тело ответа пусто (DELETE-запрос).        |
| 206                            | Сервер отправил часть данных (используется в докачке файлов). |
| **3xx: Перенаправления**       |
| 301                            | Ресурс перемещён навсегда (редирект на новый URL).            |
| 302                            | Временный редирект.                                           |
| 304                            | Контент не изменился (кеширование).                           |
| 307                            | Временный редирект с сохранением метода запроса.              |
| 308                            | Постоянный редирект с сохранением метода запроса.             |
| **4xx: Ошибки клиента**        |
| 400                            | Неправильный синтаксис запроса (например, неверный JSON).     |
| 401                            | Требуется аутентификация (например, `curl -u user:pass URL`). |
| 403                            | Доступ запрещён (нет прав).                                   |
| 404                            | Ресурс не найден (`curl https://example.com/nonexistent`).    |
| 405                            | Метод не поддерживается (например, POST вместо GET).          |
| 408                            | Сервер ожидал запрос слишком долго.                           |
| 429                            | Превышен лимит запросов (DDoS-защита).                        |
| **5xx: Ошибки сервера**        |
| 500                            | Ошибка на стороне сервера (например, сбой в коде).            |
| 502                            | Проблема с прокси-сервером или upstream.                      |
| 503                            | Сервер временно недоступен (перегрузка/техработы).            |
| 504                            | Прокси-сервер не дождался ответа от upstream.                 |
| 507                            | Не хватает места на сервере.                                  |
| 508                            | Обнаружено бесконечное перенаправление.                       |


## Методы


|  Метод	  | Описание                                                  | 	Пример команды                                                         | 	Полезные флаги                         |
|:--------:|:----------------------------------------------------------|:------------------------------------------------------------------------|:----------------------------------------|
|   GET	   | Получение данных (используется по умолчанию)	             | curl https://api.example.com/data	                                      | -H (заголовки), -G (параметры в URL)    |
|   POST   | 	Отправка данных на сервер                                | 	curl -X POST -d '{"name":"John"}' https://api.example.com/users	       | -d (данные), -H "Content-Type: ..."     
|   PUT    | 	Обновление существующего ресурса                         | 	curl -X PUT -d '{"age":30}' https://api.example.com/users/1	           | --upload-file (для файлов)              
|  DELETE  | 	Удаление ресурса	                                        | curl -X DELETE https://api.example.com/users/1	                         | -v (подробный вывод)                    
|  PATCH   | 	Частичное обновление ресурса	                            | curl -X PATCH -d '{"status":"active"}' https://api.example.com/users/1	 | -H "Content-Type: application/json"     
|   HEAD   | 	Получение только заголовков ответа (без тела)	           | curl -I https://api.example.com/data	                                   | -I (эквивалент -X HEAD)                 
| OPTIONS  | 	Получение поддерживаемых методов или CORS-информации	    | curl -X OPTIONS https://api.example.com	                                | -H "Access-Control-Request-Method: ..." 
|  TRACE   | 	Эхо-запрос (редко используется)	                         | curl -X TRACE https://api.example.com	                                  | -v (для отладки)                        
| CONNECT  | 	Используется для туннелирования (например, через прокси) | 	curl -X CONNECT proxy.example.com:8080	                                | --proxy                                 
|  CUSTOM  | 	Произвольный метод (например, для нестандартных API)	    | curl -X PURGE https://api.example.com/cache	                            | Зависит от API                          

## Использование

```shell
# Загрузка файла
curl -o file.txt https://example.com/data.txt
curl -O https://example.com/data.txt  # сохранит с оригинальным именем
curl -u username:password ftp://example.com/file.zip -O

# Авторизация 
curl -u username:password https://api.example.com/data
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1Ni..." https://api.example.com/protected
curl -H "Authorization: Basic $(echo -n 'user:pass' | base64)" https://api.example.com

# Маршрутизация
# Прокси
curl -X CONNECT --proxy http://proxy.example.com:8080 https://example.com
# Редирект
curl -L -v http://example.com
## Сохраняет POST метод после редиректа (без ключа станет GET)
curl -L --post302 -X POST -d "data=test" http://example.com
## Получить итоговый URL
curl -w "%{url_effective}" http://example.com

## POST
curl -X POST -H "Content-Type: application/json" \
-d '{"name":"John", "age":30}' \
https://api.example.com/users

# Отправить данные формы
curl -F "username=admin" -F "password=123" https://example.com/login

# tls
curl -k https://example.com  # Аналог --insecure

curl --cert /path/to/client.crt --key /path/to/client.key https://api.example.com

```
# Debug

## Общее
```shell
# Только заголовки
curl -I https://example.com
```

## Замеры
```shell
# Проверить время запроса
curl -w "DNS: %{time_namelookup} | Connect: %{time_connect}\n" https://example.com
```

## Имитация cors (междоменного) запроса
```shell
curl -H "Origin: https://your-site.com" \
     -H "Authorization: Bearer token123" \
     -H "Cookie: session_id=abc" \
     -v https://api.example.com/auth

```
Ответ:
```
Access-Control-Allow-Origin: https://your-site.com  # Должен совпадать с Origin или *
Access-Control-Allow-Credentials: true
```



















