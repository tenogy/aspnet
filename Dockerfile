FROM mcr.microsoft.com/dotnet/core/sdk:2.2-alpine3.9 AS build
WORKDIR /src
COPY ["webapp/webapp.csproj", "webapp/"]
RUN dotnet restore "webapp/webapp.csproj"
COPY . .
WORKDIR /src/webapp
RUN dotnet publish "webapp.csproj" -c Release -o /app

FROM tenogy/blank AS src
WORKDIR /app
COPY --from=build /app ./
