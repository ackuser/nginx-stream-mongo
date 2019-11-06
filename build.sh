echo "Building nginx docker image"

REGISTRY=$1
REPOSITORY=$2
IMAGE=$3
TAG=$4
PROXY=""
if [ "$#" -gt 4 ]; then
    PROXY="--build-arg https_proxy=$5"
fi

docker build --no-cache=true ${PROXY} --build-arg T_VERSION=${TAG} -t ${REGISTRY}/${REPOSITORY}/${IMAGE}:${TAG} -f ./image/Dockerfile ./image
