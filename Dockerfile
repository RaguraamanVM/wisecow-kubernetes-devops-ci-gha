FROM ubuntu:24.04

ENV PATH="/usr/games:${PATH}"

RUN apt-get update && apt-get install fortune-mod cowsay netcat-openbsd -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY wisecow.sh .

RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]

