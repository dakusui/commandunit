# Makefile for tapview
#
# You'll need a POSIX shell, and asciidoc if you want to render the manual pages.

INSTALL=install
prefix?=/usr/local
mandir?=share/man
target=$(DESTDIR)$(prefix)

PAGES = tapview.adoc
INSTALLABLES = tapview
MANPAGES  = $(PAGES:.adoc=.1)
HTMLFILES = $(PAGES:.adoc=.html)

SHIPPABLE = tapview Makefile control NEWS.adoc test

VERSION=$(shell sed -n <NEWS.adoc '/^[0-9]/s/:.*//p' | head -1)

# Note: to suppress the footers with timestamps being generated in HTML,
# we use "-a nofooter".
# To debug asciidoc problems, you may need to run "xmllint --nonet --noout --valid"
# on the intermediate XML that throws an error.
.SUFFIXES: .html .adoc .1

.adoc.1:
	asciidoctor -D. -a nofooter -b manpage $<
.adoc.html:
	asciidoctor -D. -a webfonts! $<

build: $(PAGES:.adoc=.1) $(PAGES:.adoc=.html)

# Validate the code and run a regression test
check:
	@shellcheck -s sh -f gcc tapview
	@(cd test; make regress)

clean:
	@rm -f $(PAGES:.adoc=.1) $(PAGES:.adoc=.html)


install:
	$(INSTALL) -d "$(target)/bin"
	$(INSTALL) -d "$(target)/$(mandir)/man1"
	$(INSTALL) -m 755 $(INSTALLABLES) "$(target)/bin"
	$(INSTALL) -m 644 $(MANPAGES) "$(target)/$(mandir)/man1"

INSTALLED_BINARIES := $(INSTALLABLES:%="$(target)/bin/%")
INSTALLED_MANPAGES := $(MANPAGES:%="$(target)/$(mandir)/man1/%")

uninstall:
	rm -f $(INSTALLED_BINARIES)
	rm -f $(INSTALLED_MANPAGES)

#
# Release shipping.
#

# Don't try using tar --transform, it tries to get too clever with symlinks 
tapview-$(VERSION).tar.xz: $(SHIPPABLE)
	(git ls-files; ls *.1) | sed s:^:tapview-$(VERSION)/: >MANIFEST
	(cd ..; ln -s tapview tapview-$(VERSION))
	(cd ..; tar -cJf tapview/tapview-$(VERSION).tar.xz `cat tapview/MANIFEST`)
	(cd ..; rm tapview-$(VERSION) tapview/MANIFEST)

version:
	@echo $(VERSION)

dist: tapview-$(VERSION).tar.xz

tapview-$(VERSION).md5: tapview-$(VERSION).tar.xz
	@md5sum tapview-$(VERSION).tar.xz >tapview-$(VERSION).md5

release: tapview-$(VERSION).tar.xz tapview-$(VERSION).md5 $(HTMLFILES)
	shipper version=$(VERSION) | sh -e -x

refresh: $(HTMLFILES)
	shipper -N -w version=$(VERSION) | sh -e -x


# end
