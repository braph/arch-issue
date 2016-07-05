PREFIX = /usr

PROGRAM = arch-issue

build:

install:
	install -m 0755 $(PROGRAM).pl $(PREFIX)/bin/$(PROGRAM)
