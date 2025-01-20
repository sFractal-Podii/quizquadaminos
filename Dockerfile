# heavily borrowed from https://elixirforum.com/t/cannot-find-libtinfo-so-6-when-launching-elixir-app/24101/11?u=sigu
FROM hexpm/elixir:1.15.4-erlang-26.0.2-debian-bullseye-20230612 AS app_builder

ARG env=prod

ENV LANG=C.UTF-8 \
   TERM=xterm \
   MIX_ENV=$env

RUN mkdir /opt/release
WORKDIR /opt/release
RUN mix local.hex --force && mix local.rebar --force
RUN apt-get update && apt-get install curl git -y
RUN apt-get install -y libicu-dev
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin



COPY mix.exs .
COPY mix.lock .
RUN mix deps.get && mix deps.compile
# Let's make sure we have node
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - && \
   apt-get install -y nodejs

COPY assets ./assets

# Now, let's go with the actual elixir code. The order matters: if we only
# change elixir code, all the above layers will be cached ~ less image build time.
COPY config ./config
COPY lib ./lib
COPY priv ./priv
COPY qna ./qna
COPY courses ./courses

RUN npm ci --prefix ./assets

RUN MIX_ENV=dev mix deps.compile
RUN MIX_ENV=dev mix sbom.install
RUN MIX_ENV=dev mix sbom.cyclonedx
RUN MIX_ENV=dev mix sbom.convert


# make sbom for the production docker image
RUN syft debian:bullseye-slim -o spdx > debian.bullseye_slim-spdx-bom.spdx
RUN syft debian:bullseye-slim -o spdx-json > debian.bullseye_slim-spdx-bom.json
RUN syft debian:bullseye-slim -o cyclonedx-json > debian.bullseye_slim-cyclonedx-bom.json
RUN syft debian:bullseye-slim -o cyclonedx > debian.bullseye_slim-cyclonedx-bom.xml


RUN cp *bom* ./priv/static/.well-known/sbom/
RUN ls /opt/release/priv/static/.well-known/sbom/

RUN mix assets.deploy
RUN mix release

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
