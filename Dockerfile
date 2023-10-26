# syntax=docker/dockerfile:1
# escape=`
FROM --platform=windows/amd64 mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["cmd", "/S", "/C"]

RUN powershell -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest 'get.scoop.sh' -o install.ps1; .\install.ps1 -RunAsAdmin"

RUN scoop install git && scoop install --global sudo curl 7zip git-lfs git-filter-repo dotnet-sdk && scoop bucket add legion-labs https://github.com/legion-labs/scoop-bucket && scoop install --global legion-labs/vs_buildtools

RUN powershell -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest 'https://github.com/derrod/legendary/releases/download/0.20.33/legendary.exe' -o C:\\Windows\\System32\\legendary.exe"

ARG CODE
ARG GAME="UE_5.3"

# download and install Unreal Engine with legendary to C:\UnrealEngine, you will need to pass in your auth code.
RUN legendary auth --code %CODE% && legendary list --include-ue && legendary install %GAME% --base-path C:\\UnrealEngine --install-tag "" -y

WORKDIR C:\\UnrealEngine\\%GAME%
