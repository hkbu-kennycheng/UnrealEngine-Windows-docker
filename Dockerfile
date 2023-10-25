# syntax=docker/dockerfile:1
FROM --platform=windows/amd64 mcr.microsoft.com/windows/servercore:ltsc2019

# Install VS 2019 Build Tools
RUN powershell "($ProgressPreference = 'SilentlyContinue') -and (Invoke-WebRequest 'https://aka.ms/vs/19/release/vs_buildtools.exe' -o vs_buildtools.exe) -and (Start-Process vs_buildtools.exe --quiet --wait --norestart --nocache  --installpath '%programfiles(x86)%\microsoft visual studio\2022\buildtools' --add Microsoft.VisualStudio.Workload.AzureBuildTools --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 --remove Microsoft.VisualStudio.Component.Windows81SDK)"

# download https://github.com/derrod/legendary and install it
RUN powershell "($ProgressPreference = 'SilentlyContinue') -and (Invoke-WebRequest 'https://github.com/derrod/legendary/releases/download/0.20.33/legendary.exe' -o C:\Windows\System32\legendary.exe)"

ARG CODE
ARG GAME="UE_5.3"

# download and install Unreal Engine with legendary to C:\UnrealEngine, you will need to pass in your auth code.
RUN legendary auth --code %CODE% && legendary list --include-ue && legendary install %GAME% --base-path C:\UnrealEngine\ --install-tag "" -y
