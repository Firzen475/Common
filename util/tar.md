

```shell

if [ -z "$( ls -A '/source/' )" ]; then
  tar xf $(ls -t /tmp/backup/* | head -1) /source/ || true;
else
  name=$(date '+%Y-%m-%d_%H-%M')
  echo "$name"
  tar -zcf "/dest/$name.tar" -C /source/ .
  (find /dest/ -mindepth 1 -mmin +1440 | xargs rm) &>/dev/null || true;
fi

# z - декомпрессия t - просмотр архива
tar -ztf xxx.tar 
```