# This only containerizes the backend component, as the frontend is already hosted on Amazon S3
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /backend

# Copy everything and build
COPY ./backend ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /backend
COPY --from=build-env /backend/out .
ENTRYPOINT ["dotnet", "PharmacyBackend.dll"]

# Expose the server port so Elastic Beanstalk won't complain
EXPOSE 80
