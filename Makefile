.PHONY: all common bootstrap servers clients deploy

all: bootstrap servers clients

common:
	rm -rf ./config
	cp -a templates config
	find config/ -type f -print0 | xargs -0 sed -i 's/%%DATACENTER%%/${DATACENTER}/g'

bootstrap: common
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-bootstrap-systemd-clc.yaml | cat - nomad-common-storage-clc.yaml | cat - nomad-bootstrap-storage-clc.yaml | sed 's|%%DATACENTER%%|${DATACENTER}|g;s|%%BOOTSTRAP_IP%%|${BOOTSTRAP_IP}|g' | ct --files-dir config --strict --out-file server-1.ign

servers: common
	find config/ -type f -print0 | xargs -0 sed -i 's/%%BOOTSTRAP_IP%%/${BOOTSTRAP_IP}/g'
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-server-systemd-clc.yaml | cat - nomad-common-storage-clc.yaml | cat - nomad-server-storage-clc.yaml | sed 's|%%NUMBER%%|2|;s|%%DATACENTER%%|${DATACENTER}|g;s|%%BOOTSTRAP_IP%%|${BOOTSTRAP_IP}|g' | ct --files-dir config --strict --out-file server-2.ign
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-server-systemd-clc.yaml | cat - nomad-common-storage-clc.yaml | cat - nomad-server-storage-clc.yaml | sed 's|%%NUMBER%%|3|;s|%%DATACENTER%%|${DATACENTER}|g;s|%%BOOTSTRAP_IP%%|${BOOTSTRAP_IP}|g' | ct --files-dir config --strict --out-file server-3.ign

clients: common
	find config/ -type f -print0 | xargs -0 sed -i 's/%%BOOTSTRAP_IP%%/${BOOTSTRAP_IP}/g'
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-client-systemd-clc.yaml | cat - nomad-common-storage-clc.yaml | cat - nomad-client-storage-clc.yaml | sed 's|%%NUMBER%%|1|;s|%%DATACENTER%%|${DATACENTER}|g;s|%%BOOTSTRAP_IP%%|${BOOTSTRAP_IP}|g' | ct --files-dir config --strict --out-file client-1.ign
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-client-systemd-clc.yaml | cat - nomad-common-storage-clc.yaml | cat - nomad-client-storage-clc.yaml | sed 's|%%NUMBER%%|2|;s|%%DATACENTER%%|${DATACENTER}|g;s|%%BOOTSTRAP_IP%%|${BOOTSTRAP_IP}|g' | ct --files-dir config --strict --out-file client-2.ign
	sed 's|%%SSH_PUBKEY%%|${SSH_PUBKEY}|' nomad-common-clc.yaml | cat - nomad-client-systemd-clc.yaml | cat - nomad-common-storage-clc.yaml | cat - nomad-client-storage-clc.yaml | sed 's|%%NUMBER%%|3|;s|%%DATACENTER%%|${DATACENTER}|g;s|%%BOOTSTRAP_IP%%|${BOOTSTRAP_IP}|g' | ct --files-dir config --strict --out-file client-3.ign

deploy:
	./azure-deploy.sh ${RESOURCE_GROUP}
