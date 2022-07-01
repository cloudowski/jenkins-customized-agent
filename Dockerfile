FROM jenkins/inbound-agent:4.10-3-alpine
USER root
RUN apk --no-cache add curl jq
RUN curl -Lo kustomize.tgz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.5/kustomize_v4.5.5_linux_amd64.tar.gz \
    && tar xpzf kustomize.tgz \
    && mv kustomize /usr/local/bin/ \
    && rm -fr kustomize.tgz

RUN curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
    install skaffold /usr/local/bin/

RUN curl -Lo /bin/kubectl https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl && \
    chmod +x /bin/kubectl

RUN curl -Lo /bin/yq https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_linux_amd64 && \
    chmod +x /bin/yq

RUN curl -Lo /bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.0/argocd-linux-amd64 && \
    chmod +x /bin/argocd

COPY gen-kubeconfig.sh /bin/
RUN chmod +x /bin/gen-kubeconfig.sh

USER jenkins
RUN skaffold config set --global collect-metrics false