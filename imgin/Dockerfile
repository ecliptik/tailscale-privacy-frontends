FROM public.ecr.aws/docker/library/python:3.9-slim AS base
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /src/imgin

RUN adduser imgin

#Clone into temporary build image
FROM base AS build
RUN apt-get update && apt-get install -y \
  git

RUN chown imgin:daemon .

USER imgin
RUN git clone --depth=1 https://git.voidnet.tech/kev/imgin.git .
RUN sed -i -e "s%8080%8083%g" ./imgin/config.py

#Runtime image
FROM base AS RUN

USER imgin
COPY --from=build /src/imgin/requirements.txt .
RUN id && pip install --user -r ./requirements.txt

COPY --from=build /src/imgin/run.py .
COPY --from=build /src/imgin/imgin/ ./imgin/

ENTRYPOINT [ "python", "run.py" ]
