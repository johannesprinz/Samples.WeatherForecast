ARG VERSION=5.0-alpine

FROM mcr.microsoft.com/dotnet/runtime-deps:${VERSION} AS base
WORKDIR /app
EXPOSE 8080
HEALTHCHECK --interval=60s --timeout=3s --retries=3 \
    CMD wget localhost:8080/health --quiet --output-document - > /dev/null 2>&1

FROM mcr.microsoft.com/dotnet/sdk:${VERSION} AS build
WORKDIR /code

# Copy and restore as distinct layers
COPY ["src/Samples.WeatherForecast.Api/Samples.WeatherForecast.Api.csproj", "src/Samples.WeatherForecast.Api/Samples.WeatherForecast.Api.csproj"]
COPY ["test/Samples.WeatherForecast.Api.UnitTest/Samples.WeatherForecast.Api.UnitTest.csproj", "test/Samples.WeatherForecast.Api.UnitTest/"]

RUN dotnet restore \
    "src/Samples.WeatherForecast.Api/Samples.WeatherForecast.Api.csproj" \
    --runtime linux-musl-x64
RUN dotnet restore \
    "test/Samples.WeatherForecast.Api.UnitTest/Samples.WeatherForecast.Api.UnitTest.csproj" \
    --runtime linux-musl-x64
COPY . .

# Build
RUN dotnet build \
    "src/Samples.WeatherForecast.Api/Samples.WeatherForecast.Api.csproj" \
    --configuration Release \
    --runtime linux-musl-x64 \
    --no-restore    

RUN dotnet build \
    "test/Samples.WeatherForecast.Api.UnitTest/Samples.WeatherForecast.Api.UnitTest.csproj" \
    --configuration Release \
    --runtime linux-musl-x64 \
    --no-restore    

# Unit test runner
FROM build AS unit-test
WORKDIR /code/test/Samples.WeatherForecast.Api.UnitTest
ENTRYPOINT dotnet test \
    --configuration Release \
    --runtime linux-musl-x64 \
    --no-restore \
    --no-build \
    --logger "trx;LogFileName=test_results_unit_test.trx" \
    --collect:"XPlat Code Coverage" \
    -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=json,cobertura,lcov,teamcity,opencover \
    --results-directory /code/test/Samples.WeatherForecast.Api.UnitTest/TestResults

FROM build AS publish
RUN dotnet publish \
    "src/Samples.WeatherForecast.Api/Samples.WeatherForecast.Api.csproj" \
    --configuration Release \
    --output /app/publish \
    --runtime linux-musl-x64 \
    --self-contained=true \
    --no-restore \
    --no-build \
    -p:PublishReadyToRun=true \
    -p:PublishTrimmed=true

# Final stage/image
FROM base AS final

RUN addgroup --system dotnetgroup && \
    adduser --system dotnet
USER dotnet

WORKDIR /app
COPY --chown=dotnet:dotnetgroup --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://*:8080
ENTRYPOINT ["./Samples.WeatherForecast.Api"]