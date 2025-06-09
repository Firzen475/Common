Полный жизненный цикл HTTPS-запроса через уровни OSI

Итоговая последовательность
DNS-запрос (если IP не в кеше).

ARP-запрос (если MAC шлюза неизвестен).

TCP 3-way handshake (SYN → SYN-ACK → ACK).
Вы звоните другу (SYN).
Друг поднимает трубку и говорит "Алло!" (SYN-ACK).
Вы отвечаете "Привет!" (ACK) → соединение установлено.



TLS handshake (аутентификация + шифрование).
TLS 1.2 
* Client Random (случайное число от клиента, отправлено в Client Hello). 
* Server Random (случайное число от сервера, отправлено в Server Hello). 
* Pre-Master Secret (временный ключ, созданный клиентом отправляется на сервер, зашифрованный публичным ключём).
  * Расшифровать можно только приватным ключём сервера.
* Сервер вычисляет Master Secret 
  * Pre-Master Secret + Client Random + Server Random обрабатываются с помощью функции PRF (Pseudo-Random Function).
* Server Finished (сообщение зашифровано Master Secret)
* Client Finished (сообщение зашифровано Master Secret)

  
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


```
Клиент                                      Сервер
  |                                            |
  | --- Client Hello (Client Random) --------> |
  | <-- Server Hello (Server Random) --------- |
  | <-- Certificate (Публичный ключ сервера) - |
  | -- Вычисляет (Pre-Master Secret)           |
  | -- Encrypted Pre-Master Secret (RSA) ----> |
  |          (зашифровано публичным ключом)    |
  |               Вычисляет (Master Secret) -- |
  | <-- Server Finished ---------------------- |
  | -- Вычисляет (Master Secret)               | 
  | --- Client Finished ---------------------> |
  |                                            |
  | === Зашифрованный трафик (AES-256) ======> |
```
TLS 1.3


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
    alt Обычное рукопожатие
        note over Клиент: **Client Random**<br/>**(C)Key share private**<br/>**(C)Key share open**
        note over Сервер: **Server Random**<br>**(S)Key share private**<br/>**(S)Key share open**<br>Открытый ключ<br>Сертификат
        opt Client Hello
            Клиент->>Сервер: **Client Random**<br>**(C)Key share open**<br>версия TLS<br>Список наборов шифров
        end
        note over Сервер: pre-master = ECDH(**(C)Key share open**, **(S)Key share private**)<br>MASTER SECRET (СИМЕТРИЧНЫЙ) = CR + SR + pre-master
        opt Server Hello
            Сервер->>Клиент: **Server Random**<br>**(S)Key share open**<br>Открытый ключ<br>Сертификат
        end
        note over Клиент: pre-master = ECDH(**(S)Key share open**, **(C)Key share private**)<br>MASTER SECRET (СИМЕТРИЧНЫЙ) = CR + SR + pre-master
        opt Change Cipher Spec + FINISH
            Клиент->>Сервер: Хэш сообщений<br>{DATA}
        end
        opt Change Cipher Spec + FINISH
            Сервер ->> Клиент: {RESULT}
        end
    else Pre Shared Key
        note over Клиент: pre_shared_key
        participant "some longname with **//styling//**"
    end
    
    
    
    
    
    note over Клиент: **Server Random**<br>**Server Key Exchange**<br>Открытый ключ
    Клиент ->> Клиент: Подлинность сервера<br>**pre-master secret**<br>(**Server Key Exchange** + **Client Key Exchange**)
    alt В одной инструкции передаётся<br>pre-master secret
        
        Сервер->>Сервер: Проверка Хэша<br>Расшифровка
    else В другой инструкции передаётся<br>Client Key Exchange
        opt Change Cipher Spec + FINISH
            Клиент->Сервер: {**Client Key Exchange**}<br>Хэш сообщений<br>{DATA}
        end
        Сервер->>Сервер: Проверка Хэша<br>Расшифровка<br>**pre-master secret**
    end
    note over Сервер: [**pre-master secret**]
    note over Клиент,Сервер: MASTER SECRET<br>(СИМЕТРИЧНЫЙ)<br> CR + SR + pre-master
    

```

```
       Client                                           Server

Key  ^ ClientHello
Exch | + key_share*
     | + signature_algorithms*
     | + psk_key_exchange_modes*
     v + pre_shared_key*       -------->
                                                  ServerHello  ^ Key
                                                 + key_share*  | Exch
                                            + pre_shared_key*  v
                                        {EncryptedExtensions}  ^  Server
                                        {CertificateRequest*}  v  Params
                                               {Certificate*}  ^
                                         {CertificateVerify*}  | Auth
                                                   {Finished}  v
                               <--------  [Application Data*]
     ^ {Certificate*}
Auth | {CertificateVerify*}
     v {Finished}              -------->
       [Application Data]      <------->  [Application Data]
```

# TLS 1.3 Handshake Diagram

## 1. ClientHello (Клиент → Сервер)
```
Клиент → Сервер:
  - supported_versions = [TLS 1.3]
  - random_client = <32 байта>
  - cipher_suites = [AES-GCM, ChaCha20]
  - key_share = { (G * client_private_key) }
```

## 2. ServerHello (Сервер → Клиент)
```
Сервер → Клиент:
  - selected_version = TLS 1.3
  - random_server = <32 байта>
  - selected_cipher_suite
  - key_share = { (G * server_private_key) }
```

## 3. Вычисление общего секрета (ECDHE)

Общий секрет вычисляется как:
```math
shared_secret = (server_private_key * client_public_key) = (client_private_key * server_public_key)
```

## 4. Генерация ключей (HKDF)

1. **HKDF-Extract**:
   ```
   early_secret = HKDF-Extract(0, shared_secret)
   handshake_secret = HKDF-Extract(early_secret, shared_secret)
   ```
2. **HKDF-Expand**:
   ```
   master_secret = HKDF-Expand(handshake_secret, "derived")
   ````

## 5. Аутентификация (Сервер → Клиент)
```
Сервер → Клиент:
  - Сертификат (Certificate)
  - Подпись (signature = sign(private_key, handshake_transcript))
```

## 6. Завершение Handshake
```
Клиент и сервер отправляют Finished message:
  - verify_data = HMAC(finished_key, handshake_transcript)
  - Теперь данные передаются в зашифрованном виде.
```

HTTPS-запрос/ответ (зашифрованные HTTP-данные).

Закрытие TCP-сессии (FIN → ACK → FIN → ACK).
После разговора вы оба говорите "Пока!" (FIN/FIN-ACK) → сессия закрыта.