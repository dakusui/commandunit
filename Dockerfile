FROM dakusui/jq-front:v0.43
ADD out/main/scripts/ /app/
RUN chmod 755 /app/bin/*
ENV LANG=en_US.UTF-8
ENV PATH="/app:${PATH}"
ENV COMMANDUNIT_DOCKERDIR_PREFIX="/var/lib/commandunit"
RUN find /app && \
    apt-get update && \
    apt-get install gettext-base && \
    mkdir -p /var/lib/commandunit
ENTRYPOINT ["/app/bin/commandunit"]
