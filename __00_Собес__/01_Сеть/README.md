
### Схема

[Оглавление](../README.md#оглавление)

```mermaid
flowchart TB
    subgraph L7
        direction TB
        application["7.Прикладной"]
        subgraph l7_Protocol
            HTTP_REST_GRPC_GRAPHQL["HTTP_REST_GRPC_GRAPHQL*"]
            click HTTP_REST_GRPC_GRAPHQL "https://github.com/Firzen475/Common/blob/main/__01_base__/_02_net_/L7/Protocol.md" "Перейти к разделу"
        end
        subgraph l7_Service
            dhcp[DHCP]
            click dhcp "https://github.com/Firzen475/Common/blob/main/__01_base__/_02_net_/L7/Service.md#DHCP"
            dns[DNS]
            ssh[SSH]
        end
        HTTP_FTP_DNS["HTTP_FTP_DNS*"]
        
    end
    subgraph L6
        direction TB
        presentation["7.Представительский"]
        subgraph TLS
            TLS12["TLS 1.2*"]
            click TLS12 "#TLS-12" "Перейти к разделу"
            TLS13["TLS 1.3*"]
            click TLS13 "#TLS-13" "Перейти к разделу"
        end
        
    end







    L7 --> L6

```

### HTTP_FTP_DNS 
[Начало](./README.md#схема) [Оглавление](../README.md#оглавление)

```

{% include "../../linux/net/Теория/web.md?anchor=web_protocol" %}

```

!INCLUDE {% include "../../linux/net/Теория/web.md?anchor=web_protocol" %}

[SNIPPET](../../__01_base__/_02_net_/Теория/web.md?anchor=web_protocol)

```@eval
using Markdown
Markdown.parse_file(joinpath("..", "src", "../../linux/net/Теория/web.md"))
```

#include "../../linux/net/Теория/web.md"

```mermaid
flowchart TB
subgraph graph
    direction LR

  
  subgraph services
  direction TB
  subgraph l3_l6
      TCP
      UDP
      TLS
      DTLS
  end
  subgraph l7_Связь
  direction TB
  subgraph Транспорт
  HTTP["HTTP1\2\3-QUIC"]
  WebSocket::WebTransport
  
  end
  subgraph Медиа
  WebRTC
  TURN
  SFU
  
  WebRTC --> TURN
  WebRTC --> SFU
  end
  
  subgraph l7_proto
  REST_SOAP
  gRPC
  GraphQL
  MQTT
  
  end
  HTTP --TCP HTTP-апгрейд 101--> WebSocket::WebTransport
  HTTP --UDP HTTP/3--> WebSocket::WebTransport
  WebSocket::WebTransport --метаданные--> WebRTC
  end
  
  TCP --> TLS
  UDP --> DTLS
  DTLS --> WebRTC
  TLS --Редко--> WebRTC
  TLS --> MQTT
  UDP --HTTP3--> HTTP
  TLS --> HTTP --> REST_SOAP
  HTTP --HTTP2\HTTP3--> gRPC
  HTTP --> GraphQL
  WebSocket::WebTransport --> MQTT
  WebSocket::WebTransport --Подписки--> GraphQL
  
  end
subgraph iptables_graph
direction TB
    subgraph PREROUTING ["PREROUTING (mangle, nat)"]
        A[Входящий пакет]
    end

    subgraph INPUT ["INPUT (mangle, filter)"]
        B[Пакет адресован локальной системе]
    end

    subgraph FORWARD ["FORWARD (mangle, filter)"]
        C[Пакет пересылается через систему]
    end

    subgraph OUTPUT ["OUTPUT (mangle, nat, filter)"]
        D[Исходящий пакет]
    end

    subgraph POSTROUTING ["POSTROUTING (mangle, nat)"]
        E[Пакет покидает систему]
    end
    PREROUTING -->|Если пакет адресован системе| INPUT
    PREROUTING -->|Если пакет пересылается| FORWARD
    INPUT -->|Обработка локальным процессом| G[Приложение]
    G --> OUTPUT
    OUTPUT -->|Подготовка к отправке| POSTROUTING
    FORWARD -->|Продолжение пересылки| POSTROUTING

  end
end

```
### TLS 1.2

[Начало](./README.md#схема) [Оглавление](../README.md#оглавление)
```mermaid
%%{init: {
  'theme': 'dark',
  'fontSize': '16px',
  'themeCSS': "text { font-size: 16px !important; }, .actor { font-weight: 600 !important; }",
  
  'fontFamily': 'sans-serif',
  'sequence': {

  }
}}%%
sequenceDiagram
    note over Клиент: **Client Random**<br/>**Client Key Exchange**
    note over Сервер: **Server Random**<br>**Server Key Exchange**<br>Открытый ключ<br>Сертификат
    opt Client Hello
        Клиент->>Сервер: версия TLS<br>Client Random<br>Список наборов шифров
    end
    note over Сервер: **Client Random**
    opt Server Hello
        Сервер->>Клиент: **Server Random**<br>**Server Key Exchange**<br>Открытый ключ<br>Сертификат
    end
    note over Клиент: **Server Random**<br>**Server Key Exchange**<br>Открытый ключ
    Клиент ->> Клиент: Подлинность сервера<br>**pre-master secret**<br>(**Server Key Exchange** + **Client Key Exchange**)
    alt В одной инструкции передаётся<br>pre-master secret
        opt Change Cipher Spec + FINISH
            Клиент->>Сервер: Хэш сообщений<br>{**pre-master secret**}<br>{DATA}
        end
        Сервер->>Сервер: Проверка Хэша<br>Расшифровка
    else В другой инструкции передаётся<br>Client Key Exchange
        opt Change Cipher Spec + FINISH
            Клиент->Сервер: {**Client Key Exchange**}<br>Хэш сообщений<br>{DATA}
        end
        Сервер->>Сервер: Проверка Хэша<br>Расшифровка<br>**pre-master secret**
    end
    note over Сервер: [**pre-master secret**]
    note over Клиент,Сервер: MASTER SECRET<br>(СИМЕТРИЧНЫЙ)<br> CR + SR + pre-master
    opt Change Cipher Spec + FINISH
        Сервер ->> Клиент: {RESULT}
    end

```

### TLS 1.3

[Начало](./README.md#схема) [Оглавление](../README.md#оглавление)