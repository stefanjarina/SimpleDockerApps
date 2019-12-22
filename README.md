# SimpleDockerApps

A PowerShell module for simply creating a various servers or apps in a docker containers

**This is still a work in progress, however the various functions shall be working**

## TODO

- [ ] Add prefix to all functions
- [ ] Add help strings to all functions
- [ ] Extract some common functionality (e.g. confirmation messages, status checks, ...)
- [ ] Properly fill manifest file
- [ ] Publish to PSGallery
- [ ] Improve installation instructions (shall be solved by PS Gallery)
- [ ] Add more customization options with sane defaults (e.g. custom ports, custom network, ...)
- [ ] Add more management functions for bulk actions (stop/start all, etc.)

## Installation

- Right now you can clone it into any folder and than add to you PowerShell profile file something like
  - Better installation option will be provided at a later stage

```powershell
##### CUSTOM MODULES
if ($env:PSModulePath -notmatch 'dotfiles\\powershell\\modules') {
  $env:PSModulePath = $env:PSModulePath + ';E:\powershell\modules'
}
Import-Module SimpleDockerApps -Force
```

## Usage

### `Get-SdaAllCreated`

- Lists of all created services and their status

### `Get-SdaAllRunning`

- Lists only running services

### `New-Sda<ServiseName>` [-Password \<password\>] [-Version \<version\>]

- Downloads an image if not already in cache
- Creates new docker container bound to default network `servers` and exposing default ports on localhost
- Starts docker container

### `Connect-Sda<ServiseName>` [-Password \<password\>]

- Connects directly to docker servise (using `docker exec` and native cli app (if exists))

### `New-Sda<ServiseName>Web` [-Password \<password\>]

- Some services have a web interface exposed by default, this functions open the web page in default web browser based on system

### `Get-Sda<ServiseName>`

- Gets a status of a docker container

### `Start-Sda<ServiseName>`

- Starts a docker container

### `Stop-Sda<ServiseName>`

- Stops a docker container

### `Remove-Sda<ServiseName>` [-Volumes]

- Removes a docker container
- If `-Volumes` is specified, removes also volumes
