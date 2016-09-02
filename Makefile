VERSION="1.0.2"
NAME="apache2"
REPOSITORY="docker.clarin.eu"
IMAGE_NAME="${REPOSITORY}/${NAME}:${VERSION}"

all: build

build:
	docker build -t ${IMAGE_NAME} .

push:
	docker push ${IMAGE_NAME}


