PATH := ..:.:${PATH}

STEMS = $(basename $(wildcard *.tap))

# TODO: Check exit statuses
regress:
	@echo -n "Testing tapview:"
	@-(for x in $(STEMS); do tapview <$${x}.tap | diff -u $${x}.chk -; done) >/tmp/diff$$
	@trap 'rm /tmp/diff$$' EXIT; if [ -s /tmp/diff$$ ]; then echo ""; cat /tmp/diff$$; exit 1; else echo " OK"; fi; 

# Assume correctness, rebuild checkfiles.
checkfiles:
	@-for x in $(STEMS); do tapview <$${x}.tap >$${x}.chk; done || :


# end

