FROM dhi.io/sbx-templates:claude-code-docker

USER root

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends libnss3-tools starship \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/FiloSottile/mkcert /opt/mkcert \
 && cd /opt/mkcert \
 && go build -ldflags "-X main.Version=$(git describe --tags)" -o /usr/local/bin/mkcert \
 && chmod +x /usr/local/bin/mkcert \
 && chown -R 1000:1000 /go /home/agent/.cache

RUN echo 'eval "$(starship init bash)"' >> /home/agent/.bashrc

COPY --chown=1000:1000 files/home/ /home/agent/

USER agent
WORKDIR /home/agent/workspace

ENTRYPOINT ["claude"]
