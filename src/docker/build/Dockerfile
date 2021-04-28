FROM dakusui/jq-front:v0.43
ADD files/ /app/cmd-unit/
RUN chmod 755 /app/cmd-unit
RUN find /app/cmd-unit/plugins -name '*.sh' -exec chmod 755 {} \;
ENV LANG=en_US.UTF-8
ENV PATH="/app:${PATH}"
RUN find /app/cmd-unit && \
    apt-get update && \
    apt-get install git -y && \
    apt-get install curl -y && \
    apt-get install openjdk-8-jdk -y && \
    apt-get install maven -y && \
    mkdir -p /var/lib/cmd-unit
WORKDIR /var/lib/cmd-unit
ENTRYPOINT ["/app/cmd-unit/cmd-unit"]
