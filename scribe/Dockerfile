FROM public.ecr.aws/docker/library/debian:bookworm-slim AS source
WORKDIR /src

RUN apt-get update && apt-get install -y git
#Clone from git
RUN git clone --depth=1 https://git.sr.ht/~edwardloveall/scribe .
RUN sed -i -e "s%require \"carbon\"%%g" src/shards.cr

FROM public.ecr.aws/docker/library/node:16-alpine as node_build
WORKDIR /tmp_build

COPY --from=source /src/package.json .
COPY --from=source /src/yarn.lock .
RUN yarn install --no-progress --frozen-lockfile

COPY --from=source /src/webpack.mix.js .
COPY --from=source /src/src ./src
RUN yarn prod

FROM crystallang/crystal:1.8-alpine as lucky_build
ENV SKIP_LUCKY_TASK_PRECOMPILATION="1"
RUN apk add yaml-static
WORKDIR /tmp_build
COPY --from=source /src/shard.* ./
RUN shards install --production
COPY --from=source /src/ .
COPY --from=node_build /tmp_build/public/mix-manifest.json public/mix-manifest.json
RUN crystal build --static src/start_server.cr
RUN crystal build --static tasks.cr -o run_task

FROM public.ecr.aws/docker/library/alpine:latest

ARG PUID=1000
ARG PGID=1000

RUN addgroup -g ${PGID} -S lucky && \
    adduser -u ${PUID} -S lucky -G lucky
WORKDIR /home/lucky/app

COPY --chown=lucky:lucky --from=node_build /tmp_build/public public
COPY --chown=lucky:lucky --from=lucky_build /tmp_build/start_server start_server
COPY --chown=lucky:lucky --from=lucky_build /tmp_build/run_task run_task
COPY --chown=lucky:lucky --from=source /src/script/docker_entrypoint ./

RUN mkdir ./config
RUN chown -R lucky /home/lucky
USER lucky

CMD ["/home/lucky/app/docker_entrypoint"]
