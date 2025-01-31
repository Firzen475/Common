




```shell
/bin/sh -c exec pg_isready -U "user" -d "sslcert=/opt/bitnami/postgresql/certs/tls.crt sslkey=/opt/bitnami/postgresql/certs/tls.key" -h 127.0.0.1 -p 5432




psql "port=5432 host=localhost user=postgres dbname=template1 sslcert=/opt/bitnami/postgresql/certs/tls.crt sslkey=/opt/bitnami/postgresql/certs/tls.key sslrootcert=/opt/bitnami/postgresql/certs/ca.crt sslmode=verify-ca"

psql "port=5432 host=localhost user=postgres dbname=template1 "


ls -t /tmp/backup/* | head -1

psql -f $(ls -t /tmp/backup/* | head -1) -U postgres

```