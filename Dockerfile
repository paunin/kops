FROM alpine:latest

ARG AWSCLI_VERSION=v2
ARG KOPS_VERSION=1.14.0
ARG KUBECTL_VERSION=v1.16.2
ARG HELM_VERSION=v3.6.3

RUN  apk add --update --no-cache bash python3 jq ca-certificates groff less \
  && apk add --update --no-cache --virtual build-deps py-pip curl \
  && pip install --upgrade --no-cache-dir awscli${AWSCLI_VERSION}

RUN ln -s /usr/bin/awsv2 /usr/local/bin/aws

RUN  curl -sLo /usr/local/bin/kops https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 
RUN curl -sLo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl 
RUN curl -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xvz && mv linux-amd64/helm /usr/local/bin/helm 
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && mv /tmp/eksctl /usr/local/bin/eksctl
RUN chmod +x /usr/local/bin/kops /usr/local/bin/kubectl /usr/local/bin/helm /usr/local/bin/eksctl


RUN  apk del --purge build-deps \
  && rm -f /var/cache/apk/*
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]: