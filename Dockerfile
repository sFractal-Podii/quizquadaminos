# heavily borrowed from https://elixirforum.com/t/cannot-find-libtinfo-so-6-when-launching-elixir-app/24101/11?u=sigu
FROM hexpm/elixir:1.15.4-erlang-26.0.2-debian-bullseye-20230612 AS app_builder

ARG env=prod

ENV LANG=C.UTF-8 \
   TERM=xterm \
   MIX_ENV=$env

RUN mkdir /opt/release

WORKDIR /opt/release

RUN mix local.hex --force \
   && mix local.rebar --force \
   && apt-get update \
   && apt-get install curl libicu-dev git -y \
   && curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin


RUN syft debian:bullseye-slim -o spdx > debian.bullseye_slim-spdx-bom.spdx \
      && syft debian:bullseye-slim -o spdx-json > debian.bullseye_slim-spdx-bom.json \
      && syft debian:bullseye-slim -o cyclonedx-json > debian.bullseye_slim-cyclonedx-bom.json \
      && syft debian:bullseye-slim -o cyclonedx > debian.bullseye_slim-cyclonedx-bom.xml

COPY mix.exs .
COPY mix.lock .

RUN mix deps.get && mix deps.compile

RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - && \
   apt-get install -y nodejs

COPY assets/package*.json ./assets/
RUN npm ci --prefix ./assets

RUN MIX_ENV=dev mix deps.compile \
   && MIX_ENV=dev mix sbom.install \
   && MIX_ENV=dev mix sbom.cyclonedx \
   && MIX_ENV=dev mix sbom.convert

RUN cp *bom* ./priv/static/.well-known/sbom/ 

COPY config ./config
COPY priv ./priv
COPY qna ./qna
COPY courses ./courses
COPY lib ./lib
COPY assets ./assets

RUN mix assets.deploy \
   && mix release

FROM debian:bullseye-slim AS app

ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y openssl

RUN useradd --create-home app
WORKDIR /home/app
COPY --from=app_builder /opt/release/_build/prod .
COPY entrypoint.sh .
RUN chmod a+x ./entrypoint.sh
RUN chown -R app: *
USER app

CMD ["./entrypoint.sh"]
