### Build Command
```shell
docker build -t bamboo-server --build-arg BAMBOO_VERSION=7.1.1 .
```

### Run Command
```shell
docker run --name bamboo --init -it --rm -p 8085:8085 bamboo-server
````