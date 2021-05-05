app="commandunit"
rc="$HOME/.${app}rc" && \
target="$HOME/.bashrc" && \
tag="#-${app^^}" && \
cat <(curl "https://raw.githubusercontent.com/dakusui/commandunit/main/src/site/adoc/resources/examples/function_definition.rc") > "${rc}" && \
sh -c 'grep "$4" "$1" >& /dev/null || printf "source $3$2$3 $4\n" >> "$1"' - "${target}" "${rc}" '"' "${tag}"
