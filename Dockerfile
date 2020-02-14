#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["BaaclifeAPI.csproj", ""]
RUN dotnet restore "./BaaclifeAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "BaaclifeAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BaaclifeAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BaaclifeAPI.dll"]
