FROM dakusui/jq-front:v0.43
ARG VERSION=unknown
ADD out/main/scripts/ /app/
RUN chmod 755 /app/bin/*
ENV LANG=en_US.UTF-8
ENV PATH="/app:${PATH}"
ENV COMMANDUNIT_INDOCKER=true
ENV PS1A="[\d \[\e[33m\]\t\[\e[m\]] \[\e[31m\]\u\[\e[m\]@\[\e[31m\]\h\[\e[m\] \[\e[36m\]\w\[\e[m\]\n $ "
RUN echo 'PS1=$PS1A' >> /.bashrc
RUN export LC_ALL=C && \
    find /app && \
    apt-get update && \
    apt-get install -y gettext-base && \
    mkdir -p /var/lib/commandunit && \
    mkdir -p /app/lib/commandunit && \
    echo $VERSION > /app/lib/version_file
ENTRYPOINT ["/app/bin/commandunit"]