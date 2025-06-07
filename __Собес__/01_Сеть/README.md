```mermaid
flowchart TB

    subgraph L1
        direction TB
        application["7.Прикладной"]
        HTTP_FTP_DNS["HTTP_FTP_DNS*"]
        click HTTP_FTP_DNS "#HTTP_FTP_DNS" "Перейти к разделу"
    end
    subgraph L2
        direction TB
        presentation["7.Представительский"]
        TLS["TLS1.2_1.3*"]
        click TLS "#TLS" "Перейти к разделу"
    end







    L1 --> L2

```

###  HTTP_FTP_DNS

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
### TLS
```mermaid
%%{init: {
  'theme': 'dark',
  'fontSize': '16',
  'themeCSS': 'text { font-size: 16px !important; }',
  'fontFamily': 'sans-serif',
  'sequence': {

  }
}}%%
sequenceDiagram
    Хранилище(клиент) ->> Клиент: **Client Random**
    opt Client Hello
        Клиент->>Сервер: версия TLS<br>Client Random<br>Список наборов шифров
    end
    Сервер ->> Хранилище(сервер): **Client Random**<br>**Server Random**<br>Открытый сертификат сервера
    opt Server Hello
        Сервер->>Клиент: **Server Key Exchange**<br>**Server Random**<br>Открытый сертификат сервера
    end
    Клиент->>Клиент: Подлинность сервера
    Клиент->>Хранилище(клиент): **Server Key Exchange**<br>**Server Random**<br>Открытый сертификат сервера
    Клиент ->> Клиент: **pre-master secret**<br>(**Server Key Exchange** + **Client Key Exchange**)
    alt В одной инструкции передаётся<br>pre-master secret
        opt Change Cipher Spec + FINISH
            Клиент->>Сервер: [**pre-master secret**]<br>(Зашифрован серверным открытым ключом)<br>Хэш сообщений
        end
        Сервер ->> Хранилище(сервер): [**pre-master secret**]<br>(Расшифрован)
    else В другой инструкции передаётся<br>Client Key Exchange
        opt Change Cipher Spec + FINISH
            Клиент->>Сервер: [**Client Key Exchange**]<br>(Зашифрован серверным открытым ключом)<br>Хэш сообщений
        end
        Сервер ->> Хранилище(сервер): **pre-master secret**<br>(**Server Key Exchange** + **Client Key Exchange**)
    end
    Клиент ->> Хранилище(клиент): MASTER SECRET (СИМЕТРИЧНЫЙ)<br> **Client Random** + **Server Random** + **pre-master secret**<br>проверка хэша
    Сервер ->> Хранилище(сервер): MASTER SECRET (СИМЕТРИЧНЫЙ)<br> **Client Random** + **Server Random** + **pre-master secret**<br>проверка хэша
    opt Change Cipher Spec + FINISH
        Сервер ->> Клиент: Зашифрованные данные
    end

```