# heavily borrowed from https://elixirforum.com/t/cannot-find-libtinfo-so-6-when-launching-elixir-app/24101/11?u=sigu
FROM elixir:1.11.2 AS app_builder

ARG env=prod

ENV LANG=C.UTF-8 \
   TERM=xterm \
   MIX_ENV=$env

RUN mkdir /opt/release
WORKDIR /opt/release
RUN mix local.hex --force && mix local.rebar --force
RUN curl -L  https://github.com/CycloneDX/cyclonedx-cli/releases/download/v0.17.0/cyclonedx-linux-x64 --output cyclonedx-cli && chmod a+x cyclonedx-cli
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

COPY mix.exs .
COPY mix.lock .
RUN mix deps.get && mix deps.compile

# Let's make sure we have node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Compile assets
COPY assets ./assets

# Now, let's go with the actual elixir code. The order matters: if we only
# change elixir code, all the above layers will be cached ~ less image build time.
COPY config ./config
COPY lib ./lib
COPY priv ./priv
COPY qna ./qna
COPY courses ./courses
COPY Makefile ./Makefile

RUN npm ci --prefix ./assets
RUN npm install -g @cyclonedx/bom@3.1.1
RUN make sbom_fast
# make sbom for the production docker image
RUN syft debian:buster-slim -o spdx > debian.buster_slim-spdx-bom.spdx
RUN syft debian:buster-slim -o spdx-json > debian.buster_slim-spdx-bom.json
RUN syft debian:buster-slim -o cyclonedx-json > debian.buster_slim-cyclonedx-bom.json
RUN syft debian:buster-slim -o cyclonedx > debian.buster_slim-cyclonedx-bom.xml

RUN cp *bom* ./assets/static/.well-known/sbom/
RUN mix assets.deploy
RUN mix release

FROM debian:buster-slim AS app

ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y openssl

RUN useradd --create-home app
WORKDIR /home/app
COPY --from=app_builder /opt/release/_build .
COPY entrypoint.sh .
RUN chmod a+x ./entrypoint.sh
RUN chown -R app: ./prod
USER app




CMD ["./entrypoint.sh"]
