#
# Install scripts
#

PREFIX=/usr/local/bin

SCRIPTS=\
 rotate_backups\
 batch_backup\
 auto_backup

.PHONY: install

install: $(SCRIPTS)
	install -m 0755 -t "$(PREFIX)" $(SCRIPTS)

