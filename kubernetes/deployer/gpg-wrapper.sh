#!/bin/sh
/usr/bin/gpg --batch --passphrase $(echo "${GPG_PASSPHRASE}" | base64 -d) --pinentry-mode loopback $@
