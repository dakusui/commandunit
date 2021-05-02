FROM dakusui/jq-front:v0.43
ADD out/main/scripts/ /app/
RUN chmod 755 /app/bin/*
ENV LANG=en_US.UTF-8
ENV PATH="/app:${PATH}"
ENV COMMANDUNIT_INDOCKER=true
RUN export LC_ALL=C && \
    apt-get install apt-utils && \
    find /app && \
    apt-get update && \
    apt-get install gettext-base && \
    mkdir -p /var/lib/commandunit && \
    echo $VERSION > /var/lib/commandunit/version_file
ENTRYPOINT ["/app/bin/commandunit"]
