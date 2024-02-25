CLIENTS := $(shell yq .[].name clients.yaml)
CLIENT_CONFS := $(foreach client,$(CLIENTS),conf/clients/$(client).conf)
CLIENT_KEYS := $(foreach client,$(CLIENTS),keys/clients/$(client).key)
CLIENT_PUBS := $(foreach client,$(CLIENTS),keys/clients/$(client).pub)
CLIENT_PSKS := $(foreach client,$(CLIENTS),keys/clients/$(client).psk)

.PHONY: all
all: dirs clients server

.PHONY: dirs
dirs:
	mkdir -p keys/clients conf/clients

.PHONY: clients
clients: $(CLIENT_CONFS)

.PHONY: server
server: conf/server.conf

.PRECIOUS: keys/%.key keys/%.pub keys/%.psk

keys/%.key:
	touch "$@"
	chmod 0600 "$@"
	wg genkey > "$@"

keys/%.pub: keys/%.key
	wg pubkey < "$<" > "$@"

keys/%.psk:
	touch "$@"
	chmod 0600 "$@"
	wg genpsk > "$@"

conf/clients/%.conf: keys/clients/%.key keys/clients/%.psk keys/server.pub
	touch "$@"
	chmod 0600 "$@"
	./generate-client.sh \
		"$(shell yq '.[] | select(.name == "$*").address' clients.yaml)" \
		"keys/clients/$*.key" "keys/clients/$*.psk" "keys/server.pub" > "$@"

conf/server.conf: keys/server.key $(CLIENT_PUBS) $(CLIENT_PSKS)
	touch "$@"
	chmod 0600 "$@"
	./generate-server.sh "clients.yaml" "keys/server.key" > "$@"

.PHONY: fullclean
fullclean:
	rm -rf keys conf
