
# Сертификаты registry

```shell

keytool -v -list -keystore "C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2024.2.3\jbr\lib\security\cacerts"

keytool -delete -alias registry.fzen.pro -keystore "C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2024.2.3\jbr\lib\security\cacerts"

keytool -import -noprompt -trustcacerts -alias registry.fzen.pro -file "C:\secrets\ca.crt" -keystore "C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2024.2.3\jbr\lib\security\cacerts" -storepass changeit

```