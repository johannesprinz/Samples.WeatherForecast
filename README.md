# Samples.WeatherForecast

Following the tutorial set out by Peter King in [API's From Dev to Production](https://dev.to/newday-technology/api-s-from-dev-to-production-428i). But I'm doing on an 🍏 Mac.

## How I got here

```zsh
mkdir Samples.WeatherForecast
cd Samples.WeatherForecast
touch Readme.md
code .
```

Updated README.md

```zsh
git init
git add .
git commit -m "Ready player one!"
```

At this stage I ony had the following requirements installed:

- Git - https://git-scm.com/downloads
- Visual Studio Code - https://code.visualstudio.com/download
- Docker - https://www.docker.com/products/docker-desktop

So I used the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension to setup a dotnet core 5 development container to proceed to using the `dotnet` cli to complete the initial steps. I did not want to polute my global scope with the dotnet sdk and other dependencies.

To complete the `Initial project creation` and `GitIgnore` steps

```zsh
mkdir src
cd src/
dotnet new webapi -n Samples.WeatherForecast.Api
```

When adding the docker file I just had to move it into the root and add the `--no-restore` flag to get the docker build command to run.

Lets build, run and test it.

```zsh
docker build -t samples.weatherforecast:latest .
docker run -it --rm -p 8080:80 samples-weatherforecast:latest
curl http://localhost:8080/weatherforecast/
```

Optimised the docker file
```
docker build -t samples-weatherforecast:v2 .
docker images ls
docker run -it --rm -p 8080:8080 samples-weatherforecast:v2
```