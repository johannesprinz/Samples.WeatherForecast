
#!/bin/zsh
IMAGE_NAME_AND_TAG="samples-weatherforecast:v6"

echo "App [build]"
docker build -t $IMAGE_NAME_AND_TAG .