REM Change directory to script directory
cd /D "%~dp0"

SET BASETAG=quphoria/nextjs-git-app
SET VERSION=v1.0.1
SET latest=1

SET tag="%BASETAG%:%VERSION%"
SET latesttag=
if defined latest SET latesttag=--tag "%BASETAG%"

@REM docker build --build-arg VERSION=%VERSION% --tag %tag% %latesttag% .
docker buildx create --name appbuilder --use
docker buildx build --platform=linux/amd64,linux/arm64,linux/arm --push --build-arg VERSION=%VERSION% --tag %tag% %latesttag% .
docker buildx rm appbuilder