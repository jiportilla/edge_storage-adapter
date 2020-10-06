# Make targets for building the IBM example remote storage adapter edge service

# This imports the variables from horizon/hzn.json. You can ignore these lines, but do not remove them
-include horizon/.hzn.json.tmp.mk

# Default ARCH to the architecture of this machines (as horizon/golang describes it)
export ARCH ?= $(shell hzn architecture)

# Configurable parameters passed to serviceTest.sh in "test" target
DOCKER_IMAGE_BASE ?= iportilla/rsadapter
DOCKER_NAME ?=rsadapter
ARCH ?=amd64
SERVICE_VERSION ?=1.0.0
PORT_NUM ?=9201

# Build the docker image for the current architecture
build:
	docker build -t $(DOCKER_IMAGE_BASE)_$(ARCH):$(SERVICE_VERSION) -f ./Dockerfile.$(ARCH) .

run:
	docker run -d -p=$(PORT_NUM):$(PORT_NUM) --name=$(DOCKER_NAME) $(DOCKER_IMAGE_BASE)_$(ARCH):$(SERVICE_VERSION) --influxdb-url=http://52.116.2.27:8086/ --influxdb.database=prometheus --influxdb.retention-policy=autogen

  # Stop and remove a running container
stop:
	docker stop $(DOCKER_NAME); docker rm $(DOCKER_NAME)

# Clean the container
clean:
	-docker rmi $(DOCKER_IMAGE_BASE)_$(ARCH):$(SERVICE_VERSION) 2> /dev/null || :

#-e "influxdb-url=http://52.116.2.27:8086/, --influxdb.database=prometheus"
