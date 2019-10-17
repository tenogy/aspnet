ARG VERSION=3.0.100-alpine3.9
FROM mcr.microsoft.com/dotnet/core/sdk:$VERSION AS build
WORKDIR /src
COPY ["webapp/webapp.csproj", "webapp/"]
RUN dotnet restore "webapp/webapp.csproj"
COPY . .
WORKDIR /src/webapp
RUN dotnet publish "webapp.csproj" -c Release -o /app

FROM tenogy/blank AS src
WORKDIR /app
COPY --from=build /app ./
