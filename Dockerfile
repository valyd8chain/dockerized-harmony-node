FROM ubuntu:20.04 AS build

RUN apt update && apt upgrade -y && apt install curl -y
RUN mkdir /harmony_node
WORKDIR /harmony_node
RUN curl -LO https://harmony.one/hmycli && mv hmycli hmy && chmod +x hmy
RUN curl -LO https://harmony.one/binary && mv binary harmony && chmod +x harmony

# FROM ubuntu:20.04
WORKDIR /harmony_node
RUN mkdir -p .hmy/blskeys
RUN mkdir db
RUN mkdir config

COPY create_bls_key.sh /harmony_node/create_bls_key
RUN chmod +x create_bls_key
# COPY --from=build /build/harmony .
# COPY --from=build /build/hmy .

# ENTRYPOINT [ "./harmony", "-C", "./config/harmony.conf"]