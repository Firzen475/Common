
# Install

[URL](https://min.io/docs/minio/linux/reference/minio-mc.html)
```shell
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

mc --help

mkdir -p /root/.mc/

nano /root/.mc/config.json
```
```json
{
  "version": "10",
  "aliases": {
    "minio": {
      "url": "http://localhost:9000",
      "accessKey": "gitlab-sa",
      "secretKey": "",
      "api": "S3v4",
      "path": "auto"
    }
  }
}

```

# Use
```shell
mc put
mc put /tmp/ubuntu-20.04.6-live-server-amd64.iso minio/gitlab-cache/

```

# Debug

```yaml
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Action": [
    "s3:*"
    "admin:*"
   ],
   "Resource": [
    "arn:aws:s3:::gitlab*/*"
   ]
  }
 ]
}
```

```shell
mc admin trace -v -a minio --debug
```