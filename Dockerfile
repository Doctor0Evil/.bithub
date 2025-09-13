FROM ubuntu:22.04
WORKDIR /workspace/Bit.Hub/.bithub/legal
COPY bithub-node .
RUN chmod +x bithub-node
ENTRYPOINT ["./bithub-node"]
