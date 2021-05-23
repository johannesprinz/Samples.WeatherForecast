FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["src/Samples.WeatherForecast.Api/Samples.WeatherForecast.Api.csproj", "src/Samples.WeatherForecast.Api/"]
RUN dotnet restore "src/Samples.WeatherForecast.Api/Samples.WeatherForecast.Api.csproj"
COPY . .
WORKDIR "/src/src/Samples.WeatherForecast.Api"
RUN dotnet build "Samples.WeatherForecast.Api.csproj" -c Release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish "Samples.WeatherForecast.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Samples.WeatherForecast.Api.dll"]
