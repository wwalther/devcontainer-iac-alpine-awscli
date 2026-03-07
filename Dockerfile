ARG PYTHON_VERSION=3.11
ARG AWSCLI_VERSION=2.34.4

ARG USERNAME=vscode
# =============================================================================
FROM python:${PYTHON_VERSION}-alpine AS aws

ARG AWSCLI_VERSION

RUN apk add --no-cache \
  curl \
  make \
  cmake \
  gcc \
  g++ \
  libc-dev \
  libffi-dev \
  openssl-dev \
  && curl https://awscli.amazonaws.com/awscli-${AWSCLI_VERSION}.tar.gz | tar -xz \
  && cd awscli-${AWSCLI_VERSION} \
  && ./configure --prefix=/opt/aws-cli/ --with-download-deps --with-install-type=portable-exe\
  && make \
  && make install
# =============================================================================
FROM python:${PYTHON_VERSION}-alpine
COPY --from=aws /opt/aws-cli/ /opt/aws-cli/

ARG USERNAME

ENV PATH="/opt/aws-cli/bin:$PATH"

RUN adduser -D ${USERNAME}

USER ${USERNAME}

ENTRYPOINT ["aws"]
