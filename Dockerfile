FROM dakusui/jq-front:v0.44
ARG VERSION=unknown
ADD out/main/scripts/ /app/
RUN chmod 755 /app/bin/*
ENV LANG=en_US.UTF-8
ENV PATH="/app:${PATH}"
ENV COMMANDUNIT_INDOCKER=true
RUN export LC_ALL=C && \
    find /app && \
    apt-get update && \
    apt-get install -y gettext-base && \
    mkdir -p /var/lib/commandunit && \
    mkdir -p /app/lib/commandunit && \
    echo $VERSION > /app/lib/version_file
ENTRYPOINT ["/app/bin/commandunit-main"]