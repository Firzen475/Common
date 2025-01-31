# swarm

```shell



docker node ls # Список нод в swarm

docker service ls # Контейнеры на текущей машине

docker service update --force fuiqe7oi7psk

docker network ls # Список сетей

docker service logs <servce> # Логи сервиса

docker service update --force <servce> # Перезапуск сервиса

docker service ps <stack-name> --no-trunc # Список контейнеров в stack и их статус

docker stack ps --no-trunc servers # Список состояний контейнеров в stack



docker stack rm <stack-name> # Удалить stack




docker stack deploy --compose-file /tmp/compose.yaml servers

docker service update --force fuiqe7oi7psk

```