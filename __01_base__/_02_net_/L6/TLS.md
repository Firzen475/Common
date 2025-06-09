

[TLS 1.3](#TLS-13)

[Оглавление](../../../__00_Собес__/README.md#оглавление) _____ [Схема](../../../__00_Собес__/01_Сеть/README.md#схема)

## TLS 1.2


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
## TLS 1.3
[TLS 1.2](#TLS-12)  
[Оглавление](../../../__00_Собес__/README.md#оглавление) _____ [Схема](../../../__00_Собес__/01_Сеть/README.md#схема)

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
    alt Обычное рукопожатие 1-RTT
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
    else Pre Shared Key 0-RTT
        note over Клиент: (C)pre_shared_key<br>psk_key_exchange_modes<br>PSK identity = pre_shared_key_id <br>MASTER SECRET (СИМЕТРИЧНЫЙ) =pre_shared_key+psk_key_exchange_modes
        opt Client Hello
            Клиент->>Сервер: **PSK identity**<br>psk_key_exchange_modes<br>**{DATA}
        end
        note over Сервер: (S)pre_shared_key = ПОИСК(**PSK identity**,psk_key_exchange_modes)<br>MASTER SECRET (СИМЕТРИЧНЫЙ) =pre_shared_key+psk_key_exchange_modes
        opt Server Hello
            Сервер->>Клиент: {DATA}
        end
    end

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

[Оглавление](../../../__00_Собес__/README.md#оглавление) _____ [Схема](../../../__00_Собес__/01_Сеть/README.md#схема)

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