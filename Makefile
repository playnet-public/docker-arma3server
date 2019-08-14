VERSION ?= latest
REGISTRY ?= eu.gcr.io
STEAM_USERNAME ?= ''
STEAM_PASSWORD ?= ''

build:
	docker build --build-arg USERNAME=$(STEAM_USERNAME) --build-arg PASSWORD=$(STEAM_PASSWORD) -t $(REGISTRY)/playnet-gce/arma3server:$(VERSION) .

clean:
	docker rmi $(REGISTRY)/playnet-gce/arma3server:$(VERSION)

upload:
	docker push $(REGISTRY)/playnet-gce/arma3server:$(VERSION)

run:
	docker run \
	-p 2302:2302 \
	-p 2303:2303 \
  -p 2304:2304 \
	$(REGISTRY)/playnet-gce/arma3server:$(VERSION)

all: build upload clean

