# Samples.WeatherForecast

Following the tutorial set out by Peter King in [API's From Dev to Production](https://dev.to/newday-technology/api-s-from-dev-to-production-428i). But I'm doing on an 🍏 Mac.

## How I got here

### Step 0 Setting up the development environment
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

### Step 2 Setting up solution and default container

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

### Step 3 Optimised the docker file

```
docker build -t samples-weatherforecast:v2 .
docker images ls
docker run -it --rm -p 8080:8080 samples-weatherforecast:v2
```

Completing [Part 3 building a pipeline](https://dev.to/newday-technology/api-s-from-dev-to-production-part-3-7dn) there where a few challenges to [setup container support](https://docs.github.com/en/packages/working-with-a-github-packages-registry/enabling-improved-container-support-with-the-container-registry) in github since it is still in preview. Also had to change it to public, but could only access the packages from the root of my profile view.

... and now to test

```zsh
docker pull ghcr.io/johannesprinz/samples-weatherforecast:6af1d39c83dc5c31688148cb68ca51d44993e30f 
docker run -it --rm -p 8080:8080 ghcr.io/johannesprinz/samples-weatherforecast:6af1d39c83dc5c31688148cb68ca51d44993e30f 
```

```zsh
curl http://localhost:8080/weatherforecast/
```

### Step 4 Container scanning

Todo: https://docs.docker.com/engine/security/trust/

[Part 4 Scanning the container](https://dev.to/newday-technology/api-s-from-dev-to-production-part-4-49g8)

### Step 5 Health checks

[Adding health checks](https://dev.to/newday-technology/api-s-from-dev-to-production-part-5-26cp)

### Step 6 Unit testing

Since I'm working on a mac I could use `powershell core` or the `pwsh` terminal in my development environment, but that would have required me figuring out how to run docker commands from inside a docker container. 

>This is possible btw.

Instead I tried my hand at shell scripting. Only catcha was running

```zsh
chmod +x ./filename.sh
```

to make the scripts executable.

I also chose to add a `sln` file to make testing locally from the dev environment terminal and using the [test explorer plugin](https://marketplace.visualstudio.com/items?itemName=formulahendry.dotnet-test-explorer) simpler.

```zsh
dotnet new sln
dotnet sln add src/Samples.WeatherForecast.Api/Samples.WeatherForecast.Api.csproj
dotnet sln add test/Samples.WeatherForecast.Api.UnitTest/Samples.WeatherForecast.Api.UnitTest.csproj 
```

### Step 7 Code coverage checks