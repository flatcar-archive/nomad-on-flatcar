.PHONY: all common bootstrap servers clients deploy

all: bootstrap servers clients

common:
	rm -rf ./config
	cp -a templates config
	find config/ -type f -print0 | xargs -0 sed -i 's/%%DATACENTER%%/${DATACENTER}/g'

bootstrap: common
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-bootstrap-clc.yaml | ct --files-dir config --strict --out-file server-1.ign

servers: common
	find config/ -type f -print0 | xargs -0 sed -i 's/%%BOOTSTRAP_IP%%/${BOOTSTRAP_IP}/g'
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-server-clc.yaml | sed 's|%%NUMBER%%|2|' | ct --files-dir config --strict --out-file server-2.ign
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-server-clc.yaml | sed 's|%%NUMBER%%|3|' | ct --files-dir config --strict --out-file server-3.ign

clients: common
	find config/ -type f -print0 | xargs -0 sed -i 's/%%BOOTSTRAP_IP%%/${BOOTSTRAP_IP}/g'
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-client-clc.yaml | sed 's|%%NUMBER%%|1|' |  ct --files-dir config --strict --out-file client-1.ign
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-client-clc.yaml | sed 's|%%NUMBER%%|2|' |  ct --files-dir config --strict --out-file client-2.ign
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-client-clc.yaml | sed 's|%%NUMBER%%|3|' |  ct --files-dir config --strict --out-file client-3.ign
