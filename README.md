# docker-fastqc

[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/sanogenetics/fastqc/1.19?style=plastic)](https://hub.docker.com/r/sanogenetics/fastqc)

This is a Dockerfile that builds an image based on [ubuntu:focal](https://hub.docker.com/_/ubuntu) containing [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/). This also contains the AWS CLI tool.


## usage

To use this container, use a command like:

```
docker run \
  --rm \
  -e 'AWS_ACCESS_KEY_ID=xxxxxx' \
  -e 'AWS_SECRET_ACCESS_KEY=xxxxxxxx' \
  -e 'AWS_DEFAULT_REGION=eu-west-1' \
  --entrypoint /fastqc/fastqcs3 \
  fastqc:0.11.9 \
  's3://sano-fastqc-prod/' \
  's3://sano-reads-prod/xxxxxxxx-wes.r1.fq.gz' \
  's3://sano-reads-prod/xxxxxxxx-wes.r2.fq.gz'  
```

where `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are environment variables for configuring AWS [CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html).

## developers

To build this container, use a command like:

```
docker build \
  --rm \
  --tag fastqc:0.11.9 .
```

Note: `--rm` means to remove intermediate containers after a build. You may want to omit this if developing locally to utilize docker layer caching.

Note: `--progress=plain` may be useful to see all intermediate step logs.

Push to AWS ECR with:

```
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 244834673510.dkr.ecr.eu-west-2.amazonaws.com
docker tag fastqc:0.11.9 244834673510.dkr.ecr.eu-west-2.amazonaws.com/fastqc:0.11.9
docker push 244834673510.dkr.ecr.eu-west-2.amazonaws.com/fastqc:0.11.9
docker logout
```

Push to DockerHub with:

```
docker login --username sanogenetics
docker tag fastqc:0.11.9 sanogenetics/fastqc:0.11.9
docker push sanogenetics/fastqc:0.11.9
docker logout
```

Note: will prompt for password.