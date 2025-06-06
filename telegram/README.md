

https://nixhub.ru/posts/alertmanager-to-tg-topics/

```shell

https://api.telegram.org/bot{INSERT_BOT_TOKEN}/getUpdates

export TG_BOT=7909294571:AAENOMhcAKYjtV8WeoFb2tfG4iJZU3kZ1GM

curl -X POST -H 'Content-Type: application/json' \
  -d '{"reply_to_message_id": "2", "chat_id": "-1002513698810", "text": "This is a test message cUrl"}' \
  https://api.telegram.org/bot$TG_BOT/sendMessage

```