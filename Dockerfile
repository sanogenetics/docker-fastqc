# from https://github.com/aws/aws-cli/blob/v2/docker/Dockerfile
FROM ubuntu:focal  as awscli
# make sure nothing is promted for during install
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y \
    curl \
    unzip \
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip "awscliv2.zip" \
  && rm "awscliv2.zip" \
  # The --bin-dir is specified so that we can copy the
  # entire bin directory from the installer stage into
  # into /usr/local/bin of the final stage without
  # accidentally copying over any other executables that
  # may be present in /usr/local/bin of the installer stage.
  && ./aws/install --bin-dir /aws-cli-bin/


# use a fresh base for cleaner output
FROM eclipse-temurin:11-jre-focal
# make sure nothing is promted for during install
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update \
  && apt-get install -y \
    groff \
    wget \
    unzip \
    less 

# install aws cli
# requires less groff
COPY --from=awscli /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=awscli /aws-cli-bin/ /usr/local/bin/

# download and decompress the FastQC excutable
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip -O /tmp/fastqc.zip && \ 
    unzip /tmp/fastqc.zip -d /fastqc/ && \
    rm /tmp/fastqc.zip && \
    chmod 777 /fastqc/FastQC/fastqc

ENV PATH="/fastqc/FastQC:${PATH}"

ENTRYPOINT ["fastqc", "--help"]

# also install convenience scripts
COPY bin/* /fastqc/
RUN chmod 777 /fastqc/*
