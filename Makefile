build_debug ?= false
restart ?= all
focus ?= .\*

ifneq (,$(DAPPER_HOST_ARCH))

# Running in Dapper

include $(SHIPYARD_DIR)/Makefile.inc

TARGETS := $(shell ls -p scripts | grep -v -e / -e images -e reload-images)
CLUSTERS_ARGS += --cluster_settings $(DAPPER_SOURCE)/scripts/cluster_settings
E2E_ARGS += --focus $(focus) cluster2 cluster3 cluster1

clusters: build images

reload-images: build images
	./scripts/$@ --restart $(restart)

images: build
	./scripts/$@ $(images_flags)

$(TARGETS): vendor/modules.txt
	./scripts/$@ --build_debug $(build_debug)

vendor/modules.txt: go.mod
	go mod download
	go mod vendor

.PHONY: $(TARGETS)

else

# Not running in Dapper

include Makefile.dapper

endif

# Disable rebuilding Makefile
Makefile Makefile.dapper Makefile.inc: ;
