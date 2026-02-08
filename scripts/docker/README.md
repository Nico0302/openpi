# Docker Setup

## Train Container

### Build

```shell
docker build --target training -t openpi_train -f scripts/docker/Dockerfile .
```

```shell
docker save openpi_train | gzip > openpi_train.tar.gz
```

### Run

```shell
docker run -it --rm \
    --gpus all \
    -v $(pwd):/app \
    -e TRAIN_CONFIG=pi05_leros2_aa \
    -e TRAIN_ARGS="--resume" \
    openpi_train
```