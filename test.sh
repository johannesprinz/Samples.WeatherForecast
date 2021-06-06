
#!/bin/zsh
IMAGE_NAME_AND_TAG="samples-weatherforecast-unit-test:v6"

echo "Unit tests [build]"
docker build --target unit-test --tag $IMAGE_NAME_AND_TAG .

echo "Unit tests [run]"
docker run --rm --volume "${PWD}/TestResults:/code/test/Samples.WeatherForecast.Api.UnitTest/TestResults/" $IMAGE_NAME_AND_TAG
