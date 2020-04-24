#!/bin/bash
/usr/bin/gpg --batch --passphrase $(echo "${GPG_PASSPHRASE}" | base64 --decode) --pinentry-mode loopback $@
