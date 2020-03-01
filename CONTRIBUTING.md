# Controbuting guidelines

First of all thank you for you support and for any contribution you make.

## Local development

- Clone or fork the repo to any folder and than add to you PowerShell profile something like

```powershell
##### CUSTOM MODULES
if ($env:PSModulePath -notmatch 'powershell\\modules') {
  $env:PSModulePath = $env:PSModulePath + ';E:\powershell\modules'
}
Import-Module SimpleDockerApps -Force
```

- Create your feature branch, find how to [here](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-and-deleting-branches-within-your-repository)

- Start coding 😊

## Pull request

- Create a pull request from your branch

  - [Creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request)
  - [Creating a pull request from a fork](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork)

- Wait for my merge or discussion
- ???
- Profit
