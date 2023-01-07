FROM dakusui/jq-front:v0.52
ADD files/ /app/commandunit/
RUN chmod 755 /app/commandunit
RUN find /app/commandunit/plugins -name '*.sh' -exec chmod 755 {} \;
ENV LANG=en_US.UTF-8
ENV PATH="/app:${PATH}"
RUN find /app/commandunit && \
    apt-get update && \
    apt-get install git -y && \
    apt-get install curl -y && \
    apt-get install openjdk-8-jdk -y && \
    apt-get install maven -y && \
    mkdir -p /var/lib/commandunit
WORKDIR /var/lib/commandunit
ENTRYPOINT ["/app/commandunit/commandunit"]
