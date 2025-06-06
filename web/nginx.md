


## Пример настройки CORS 
Возможность делать запросы на другие домены

```
server {
    location / {
        add_header 'Access-Control-Allow-Origin' 'https://your-site.com';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization';
        
        if ($request_method = 'OPTIONS') {
            return 204;  # Пустой ответ для preflight
        }
    }
}

```