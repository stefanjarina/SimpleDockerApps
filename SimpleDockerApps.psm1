
## INFO

function Get-SdaAllServers {
    docker container ls -a -f 'name=-server' --format '{{.Names}} - {{.Status}}'
  }
  
  function Get-SdaAllRunning {
    docker container ls -a -f 'name=-server' -f 'status=running' --format '{{.Names}} - {{.Status}}'
  }
  
  #############################
  #############################
  ## MSSQL DOCKER
  function New-MSSQL {
    param (
      [string]$Pass = "Start123++"
    )
    if ($Pass -eq "Start123++") {
      Write-Output "Creating MSSQL Express in Docker container using the default password 'Start123++'"
      Write-Output "For custom password run again with: 'New-MSSQL -Pass <SA_PASSWORD>'"
      Write-Output "Password must be strong, otherwise docker fails to create container"
      $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
      switch -Regex ($confirmation) {
        '[Nn]' { break }
        Default {}
      }
    }
    $status = $(docker ps -f 'name=mssql-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill mssql-server ; if ($?) { Remove-MSSQL } }
      }
    }
  
    docker create --net servers -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$Pass" -e "MSSQL_PID=Express" -v mssql-data:/var/opt/mssql --name mssql-server -p 1433:1433 mcr.microsoft.com/mssql/server:latest
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start mssql-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
    
  function Connect-MSSQL {
    param (
      [string]$Pass = "Start123++"
    )
    if ($Pass -eq "Start123++") {
      Write-Output "Connecting to MSSQL Express in Docker container using the default password 'Start123++'"
      Write-Output "For custom password run again with: 'Connect-MSSQL -Pass <SA_PASSWORD>'"
      $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
      switch -Regex ($confirmation) {
        '[Nn]' { break }
        Default { sqlcmd -S localhost -U sa -P "$Pass" }
      }
    }
    else {
      sqlcmd -S localhost -U sa -P "$Pass"
    }
  }
  
  function Stop-MSSQL {
    docker stop mssql-server -t 10
  }
  
  function Start-MSSQL {
    docker start mssql-server
  }
  
  function Remove-MSSQL {
    param(
      [switch]$Volumes
    )
    docker container rm mssql-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm mssql-data
    }
  }
  
  function Get-MSSQL {
    docker container ls -a -f 'name=mssql-server' --format '{{.Status}}'
  }
  
  ## POSTGRESQL DOCKER
  function New-Postgres {
    param (
      [string]$Pass = "postgres",
      [string]$Version = "11"
    )
    Write-Output "Creating PostgreSQL in Docker container using the password '$Pass' and version '$Version'"
  
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=postgresql-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill postgresql-server ; if ($?) { Remove-Postgres } }
      }
    }
  
    docker create --net servers -e "POSTGRES_PASSWORD=$Pass" -v postgresql-data:/var/lib/postgresql/data --name postgresql-server -p 5432:5432 postgres:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start postgresql-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Postgres {
    param (
      [string]$Pass = "postgres"
    )
    Write-Output "Connecting to PostgreSQL in Docker container using the user 'postgres' and password '$Pass'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        docker exec -it postgresql-server psql "postgresql://postgres:$($Pass)@localhost:5432"
      }
    }
  }
  
  function Stop-Postgres {
    docker stop postgresql-server -t 10
  }
  
  function Start-Postgres {
    docker start postgresql-server
  }
  
  function Remove-Postgres {
    param(
      [switch]$Volumes
    )
    docker container rm postgresql-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm postgresql-data
    }
  }
  
  function Get-Postgres {
    docker container ls -a -f 'name=postgresql-server' --format '{{.Status}}'
  }
  
  ## Mariadb DOCKER
  function New-Mariadb {
    param (
      [string]$Pass = "Start123",
      [string]$Version = "10"
    )
    Write-Output "Creating MariaDB in Docker container using the password '$Pass' and version '$Version'"
  
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=mariadb-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill mariadb-server ; if ($?) { Remove-Mariadb } }
      }
    }
  
    docker create --net servers -e "MYSQL_ROOT_PASSWORD=$Pass" -v mariadb-data:/var/lib/mysql --name mariadb-server -p 3306:3306 mariadb:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start mariadb-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Mariadb {
    param (
      [string]$Pass = "Start123"
    )
    Write-Output "Connecting to MariaDB in Docker container using the user 'root' and password '$Pass'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        docker exec -it mariadb-server mysql -uroot -p"$Pass"
      }
    }
  }
  
  function Stop-Mariadb {
    docker stop mariadb-server -t 10
  }
  
  function Start-Mariadb {
    docker start mariadb-server
  }
  
  function Remove-Mariadb {
    param(
      [switch]$Volumes
    )
    docker container rm mariadb-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm mariadb-data
    }
  }
  
  function Get-Mariadb {
    docker container ls -a -f 'name=mariadb-server' --format '{{.Status}}'
  }
  
  ## OracleDb DOCKER
  function New-OracleDb {
    param (
      [string]$Pass = "Start123",
      [string]$Version = "18.4.0",
      [string]$Edition = "xe"
    )
    Write-Output "Creating OracleDb $Edition in Docker container using the password '$Pass' and version '$Version'"
  
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=oracledb-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill oracledb-server ; if ($?) { Remove-OracleDb } }
      }
    }
  
    docker create --net servers -e "ORACLE_PWD=$Pass" -v oracledb-data:/opt/oracle/oradata --name oracledb-server -p 1521:1521 -p 5500:5500 oracle/database:$Version-$Edition
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start oracledb-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-OracleDb {
    param (
      [string]$Pass = "Start123"
    )
    Write-Output "Connecting to OracleDb in Docker container using the user 'sys' and password '$Pass'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        docker exec -it oracledb-server sqlplus sys/$Pass@//localhost:1521/XE as sysdba
      }
    }
  }
  
  function Stop-OracleDb {
    docker stop oracledb-server -t 10
  }
  
  function Start-OracleDb {
    docker start oracledb-server
  }
  
  function Remove-OracleDb {
    param(
      [switch]$Volumes
    )
    docker container rm oracledb-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm oracledb-data
    }
  }
  
  function Get-OracleDb {
    docker container ls -a -f 'name=oracledb-server' --format '{{.Status}}'
  }
  
  ## MongoDB DOCKER
  function New-Mongodb {
    param (
      [string]$Version = "latest",
      [string]$Pass = ""
    )
    $textToOutput = "Creating MongoDB in Docker container using version '$Version'"
    if ("" -ne $Pass) {
      $textToOutput += " and password '$Pass'"
    }
    Write-Output $textToOutput
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=mongodb-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill mongodb-server ; if ($?) { Remove-Mongodb } }
      }
    }
    if ("" -ne $Pass) {
      docker create --net servers -v mongodb-data:/data/db --name mongodb-server -p 27017:27017 mongo:$Version
    } else {
      docker create --net servers -v mongodb-data:/data/db -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=$Pass --name mongodb-server -p 27017:27017 mongo:$Version
    }
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start mongodb-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Mongodb {
    param (
      [string]$Pass = ""
    )
    $textToOutput = "Connecting to MongoDB in Docker container"
    if ("" -ne $Pass) {
      $textToOutput += " with password '$Pass'"
    }
    Write-Output $textToOutput
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { 
        if ("" -ne $Pass) {
          docker exec -it mongodb-server mongo
        } else {
          docker exec -it mongodb-server mongo -u admin -p $Pass
        }
        }
    }
  }
  
  function Stop-Mongodb {
    docker stop mongodb-server -t 10
  }
  
  function Start-Mongodb {
    docker start mongodb-server
  }
  
  function Remove-Mongodb {
    param(
      [switch]$Volumes
    )
    docker container rm mongodb-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm mongodb-data
    }
  }
  
  function Get-Mongodb {
    docker container ls -a -f 'name=mongodb-server' --format '{{.Status}}'
  }
  
  ## Redis DOCKER
  function New-Redis {
    param (
      [string]$Version = "latest",
      [switch]$Persistent
    )
    if ($PSBoundParameters.ContainsKey("Persistent")) {
      Write-Output "Creating Persistent Redis in Docker container using version '$Version'"
    } else {
      Write-Output "Creating Redis in Docker container using version '$Version'"
    }
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $name = "redis-server"
    if ($PSBoundParameters.ContainsKey("Persistent")) {
      $name = "redispersistent-server"
      $status = $(docker ps -f 'name=redispersistent-server' --format '{{.Status}}')
    } else {
      $status = $(docker ps -f 'name=redis-server' --format '{{.Status}}')
    }
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default {
          docker kill $name
          if ($PSBoundParameters.ContainsKey("Persistent")) {
            if ($?) { Remove-Redis -Persistent }
          } else {
            if ($?) { Remove-Redis }
          }
        }
      }
    }
  
    if ($PSBoundParameters.ContainsKey("Persistent")) {
      docker create --net servers -v redispersistent-data:/data --name $name -p 6380:6379 redis:$Version redis-server --appendonly yes
    } else {
      docker create --net servers --name $name -p 6379:6379 redis:$Version
    }
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    Start-Redis -Persistent
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Redis {
    param (
      [switch]$Persistent
    )
    if ($PSBoundParameters.ContainsKey("Persistent")) {
      Write-Output "Connecting to Persistent Redis in Docker container"
    } else {
      Write-Output "Connecting to Redis in Docker container"
    }
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        if ($PSBoundParameters.ContainsKey("Persistent")) {
          docker exec -it redispersistent-server redis-cli
        } else {
          docker exec -it redis-server redis-cli
        }
      }
    }
  }
  
  function Stop-Redis {
    param (
      [switch]$Persistent
    )
    if ($PSBoundParameters.ContainsKey("Persistent")) {
      docker stop redispersistent-server -t 10
    } else {
      docker stop redis-server -t 10
    }
  }
  
  function Start-Redis {
    param (
      [switch]$Persistent
    )
    if ($PSBoundParameters.ContainsKey("Persistent")) {
      docker start redispersistent-server
    } else {
      docker start redis-server
    }
  }
  
  function Remove-Redis {
    param (
      [switch]$Persistent,
      [switch]$Volumes
    )
    if ($PSBoundParameters.ContainsKey("Persistent")) {
      docker container rm redispersistent-server
      if ($PSBoundParameters.ContainsKey("Volumes")) {
        docker volume rm redispersistent-data
      }
    } else {
      docker container rm redis-server
    }
  }
  
  function Get-Redis {
    param (
      [switch]$Persistent
    )
    if ($PSBoundParameters.ContainsKey("Persistent")) {
      docker container ls -a -f 'name=redispersistent-server' --format '{{.Status}}'
    } else {
      docker container ls -a -f 'name=redis-server' --format '{{.Status}}'    
    }
  }
  
  ## Cassandra DOCKER
  function New-Cassandra {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating Cassandra in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=cassandra-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill cassandra-server ; if ($?) { Remove-Cassandra } }
      }
    }
  
    docker create --net servers -v cassandra-data:/var/lib/cassandra --name cassandra-server -p 9042:9042 cassandra:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start cassandra-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Cassandra {
    Write-Output "Connecting to Cassandra in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it cassandra-server cqlsh }
    }
  }
  
  function Stop-Cassandra {
    docker stop cassandra-server -t 10
  }
  
  function Start-Cassandra {
    docker start cassandra-server
  }
  
  function Remove-Cassandra {
    param(
      [switch]$Volumes
    )
    docker container rm cassandra-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm cassandra-data
    }
  }
  
  function Get-Cassandra {
    docker container ls -a -f 'name=cassandra-server' --format '{{.Status}}'
  }
  
  ## Ravendb DOCKER
  function New-Ravendb {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating Ravendb in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=ravendb-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill ravendb-server ; if ($?) { Remove-Ravendb } }
      }
    }
  
    docker create --net servers -v ravendb-data:/opt/RavenDB/Server/RavenData -v ravendb-config:/opt/RavenDB/config -e "RAVEN_ARGS='--Setup.Mode=None'" -e "RAVEN_Security_UnsecuredAccessAllowed='PrivateNetwork'" -p 9090:8080 -p 38888:38888 --name ravendb-server ravendb/ravendb:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start ravendb-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Ravendb {
    Write-Output "Connecting to Ravendb in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it ravendb-server ./rvn admin-channel }
    }
  }
  
  function Connect-RavendbWeb {
    $url = "http://localhost:9090"
    Write-Output "Connecting to Ravendb web interface at: '$url'"
    Write-Output "If web browser did not open automatically please open browser and paste in address manually"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        if ($IsLinux) {
          xdg-open $url
        } elseif ($IsMacOS) {
          open $url
        } else {
          Start-Process $url
        }
      }
    }
  }
  
  function Stop-Ravendb {
    docker stop ravendb-server -t 10
  }
  
  function Start-Ravendb {
    docker start ravendb-server
  }
  
  function Remove-Ravendb {
    param(
      [switch]$Volumes
    )
    docker container rm ravendb-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm ravendb-data ravendb-config
    }
  }
  
  function Get-Ravendb {
    docker container ls -a -f 'name=ravendb-server' --format '{{.Status}}'
  }
  
  ## Clickhouse DOCKER
  function New-Clickhouse {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating Clickhouse in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=clickhouse-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill clickhouse-server ; if ($?) { Remove-Clickhouse } }
      }
    }
  
    docker create --net servers -v clickhouse-data:/var/lib/clickhouse --ulimit nofile=262144:262144 --name clickhouse-server -p 8123:8123 -p 9000:9000 yandex/clickhouse-server:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start clickhouse-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Clickhouse {
    Write-Output "Connecting to Clickhouse in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it clickhouse-server clickhouse-client }
    }
  }
  
  function Stop-Clickhouse {
    docker stop clickhouse-server -t 10
  }
  
  function Start-Clickhouse {
    docker start clickhouse-server
  }
  
  function Remove-Clickhouse {
    param(
      [switch]$Volumes
    )
    docker container rm clickhouse-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm clickhouse-data
    }
  }
  
  function Get-Clickhouse {
    docker container ls -a -f 'name=clickhouse-server' --format '{{.Status}}'
  }
  
  ## Dremio DOCKER
  function New-Dremio {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating Dremio in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=dremio-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill dremio-server ; if ($?) { Remove-Dremio } }
      }
    }
  
    docker create --net servers -v dremio-data:/opt/dremio/data -v dremio-config:/opt/dremio/conf -p 9047:9047 -p 31010:31010 -p 45678:45678 --name dremio-server dremio/dremio-oss:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start dremio-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-DremioWeb {
    $url = "http://localhost:9047"
    Write-Output "Connecting to Dremio web interface at: '$url'"
    Write-Output "If web browser did not open automatically please open browser and paste in address manually"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        if ($IsLinux) {
          xdg-open $url
        } elseif ($IsMacOS) {
          open $url
        } else {
          Start-Process $url
        }
      }
    }
  }
  
  function Stop-Dremio {
    docker stop dremio-server -t 10
  }
  
  function Start-Dremio {
    docker start dremio-server
  }
  
  function Remove-Dremio {
    param(
      [switch]$Volumes
    )
    docker container rm dremio-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm dremio-data dremio-config
    }
  }
  
  function Get-Dremio {
    docker container ls -a -f 'name=dremio-server' --format '{{.Status}}'
  }
  
  ## DynamoDB DOCKER
  function New-Dynamodb {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating Dynamodb in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=cassandra-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill cassandra-server ; if ($?) { Remove-Dynamodb } }
      }
    }
  
    docker create --net servers --name dynamodb-server -p 8000:8000 amazon/dynamodb-local:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start dynamodb-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Dynamodb {
    Write-Output "Connecting to Dynamodb in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it dynamodb-server cqlsh }
    }
  }
  
  function Stop-Dynamodb {
    docker stop dynamodb-server -t 10
  }
  
  function Start-Dynamodb {
    docker start dynamodb-server
  }
  
  function Remove-Dynamodb {
    docker container rm dynamodb-server
  }
  
  function Get-Dynamodb {
    docker container ls -a -f 'name=dynamodb-server' --format '{{.Status}}'
  }
  
  ## Elasticsearch DOCKER
  function New-Elasticsearch {
    param (
      [string]$Version = "6.6.1"
    )
    Write-Output "Creating Elasticsearch in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=elasticsearch-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill elasticsearch-server ; if ($?) { Remove-Elasticsearch } }
      }
    }
  
    docker create --net servers -v elasticsearch-data:/usr/share/elasticsearch/data -e "discovery.type=single-node" -p 9200:9200 -p 9300:9300 --name elasticsearch-server docker.elastic.co/elasticsearch/elasticsearch:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start elasticsearch-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Elasticsearch {
    Write-Output "Connecting to Elasticsearch in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it elasticsearch-server bin/elasticsearch-sql-cli }
    }
  }
  
  function Stop-Elasticsearch {
    docker stop elasticsearch-server -t 10
  }
  
  function Start-Elasticsearch {
    docker start elasticsearch-server
  }
  
  function Remove-Elasticsearch {
    param(
      [switch]$Volumes
    )
    docker container rm elasticsearch-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm elasticsearch-data
    }
  }
  
  function Get-Elasticsearch {
    docker container ls -a -f 'name=elasticsearch-server' --format '{{.Status}}'
  }
  
  ## Solr DOCKER
  function New-Solr {
    param (
      [string]$Version = "latest",
      [switch]$NoExamples
    )
    Write-Output "Creating Solr in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=solr-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill solr-server ; if ($?) { Remove-Solr } }
      }
    }
  
    docker create --net servers -v solr-data:/opt/solr/server/solr/mycores -p 8983:8983 --name solr-server solr:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start solr-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  
    ### SOLR specific
    # To use Solr so called 'core' needs to be created
    docker exec -it --user=solr solr-server bin/solr create_core -c defaultcore
    if ($?) { 
      Write-Output "core created with name 'defaultcore'"
    }
    else {
      Write-Error "Error creating core"
      break
    }
  
    if ($PSBoundParameters.ContainsKey("NoExamples")) {
      Write-Output "Skipping examples due to present -NoExamples switch..."
      break
    } else {
      docker exec -it --user=solr solr-server bin/post -c gettingstarted example/exampledocs/manufacturers.xml
      if ($?) { 
        Write-Output "examples created"
      }
      else {
        Write-Error "Error creating examples"
        break
      }
    }
  }
  
  function Connect-SolrWeb {
    $url = "http://localhost:8983/solr/"
    Write-Output "Connecting to Solr web interface at: '$url'"
    Write-Output "If web browser did not open automatically please open browser and paste in address manually"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        if ($IsLinux) {
          xdg-open $url
        } elseif ($IsMacOS) {
          open $url
        } else {
          Start-Process $url
        }
      }
    }
  }
  
  function Stop-Solr {
    docker stop solr-server -t 10
  }
  
  function Start-Solr {
    docker start solr-server
  }
  
  function Remove-Solr {
    param(
      [switch]$Volumes
    )
    docker container rm solr-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm solr-data
    }
  }
  
  function Get-Solr {
    docker container ls -a -f 'name=solr-server' --format '{{.Status}}'
  }
  
  ## Neo4j DOCKER
  function New-Neo4j {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating Neo4j in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=neo4j-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill neo4j-server ; if ($?) { Remove-Neo4j } }
      }
    }
  
    docker create --net servers -v neo4j-data:/data -p 7474:7474 -p 7687:7687 --name neo4j-server neo4j:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start neo4j-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Neo4j {
    Write-Output "Connecting to Neo4j in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it neo4j-server cypher-shell -u neo4j -p neo4j }
    }
  }
  
  function Stop-Neo4j {
    docker stop neo4j-server -t 10
  }
  
  function Start-Neo4j {
    docker start neo4j-server
  }
  
  function Remove-Neo4j {
    param(
      [switch]$Volumes
    )
    docker container rm neo4j-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm neo4j-data
    }
  }
  
  function Get-Neo4j {
    docker container ls -a -f 'name=neo4j-server' --format '{{.Status}}'
  }
  
  ######################
  ## OrientDB DOCKER
  ######################
  function New-OrientDB {
    param (
      [string]$Pass = "Start123",
      [string]$Version = "latest"
    )
    Write-Output "Creating OrientDB in Docker container using the password '$Pass' and version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=orientdb-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill orientdb-server ; if ($?) { Remove-OrientDB } }
      }
    }
  
    docker create --net servers -v orientdb-data:/orientdb/databases -p 2424:2424 -p 2480:2480 -e "ORIENTDB_ROOT_PASSWORD=$Pass" --name orientdb-server orientdb:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start orientdb-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-OrientDB {
    Write-Output "Connecting to OrientDB in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it orientdb-server bin/console.sh }
    }
  }
  
  function Stop-OrientDB {
    docker stop orientdb-server -t 10
  }
  
  function Start-OrientDB {
    docker start orientdb-server
  }
  
  function Remove-OrientDB {
    param(
      [switch]$Volumes
    )
    docker container rm orientdb-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm orientdb-data
    }
  }
  
  function Get-OrientDB {
    docker container ls -a -f 'name=orientdb-server' --format '{{.Status}}'
  }
  
  ######################
  ## ArangoDB DOCKER
  ######################
  function New-ArangoDB {
    param (
      [string]$Pass = "Start123",
      [string]$Version = "latest"
    )
    Write-Output "Creating ArangoDB in Docker container using the password '$Pass' and version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=arangodb-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill arangodb-server ; if ($?) { Remove-ArangoDB } }
      }
    }
  
    docker create --net servers -v arangodb-data:/var/lib/arangodb3 -v arangodb-apps:/var/lib/arangodb3-apps -p 8529:8529 -e "ARANGO_ROOT_PASSWORD=$Pass" --name arangodb-server arangodb:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start arangodb-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-ArangoDB {
    param (
      [string]$Pass = "Start123"
    )
    Write-Output "Connecting to OracleDb in Docker container using the password '$Pass'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it arangodb-server arangosh --server.password "$Pass" }
    }
  }
  
  function Stop-ArangoDB {
    docker stop arangodb-server -t 10
  }
  
  function Start-ArangoDB {
    docker start arangodb-server
  }
  
  function Remove-ArangoDB {
    param(
      [switch]$Volumes
    )
    docker container rm arangodb-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm arangodb-data
    }
  }
  
  function Get-ArangoDB {
    docker container ls -a -f 'name=arangodb-server' --format '{{.Status}}'
  }
  
  ######################
  ## RethinkDB DOCKER
  ######################
  function New-RethinkDB {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating RethinkDB in Docker container using the version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=rethinkdb-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill rethinkdb-server ; if ($?) { Remove-RethinkDB } }
      }
    }
  
    docker create --net servers -v rethinkdb-data:/data -p 8080:8080 --name rethinkdb-server rethinkdb:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start rethinkdb-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-RethinkDBWeb {
    $url = "http://localhost:8080"
    Write-Output "Connecting to RethinkDB web interface at: '$url'"
    Write-Output "If web browser did not open automatically please open browser and paste in address manually"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        if ($IsLinux) {
          xdg-open $url
        } elseif ($IsMacOS) {
          open $url
        } else {
          Start-Process $url
        }
      }
    }
  }
  
  function Stop-RethinkDB {
    docker stop rethinkdb-server -t 10
  }
  
  function Start-RethinkDB {
    docker start rethinkdb-server
  }
  
  function Remove-RethinkDB {
    param(
      [switch]$Volumes
    )
    docker container rm rethinkdb-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm rethinkdb-data
    }
  }
  
  function Get-RethinkDB {
    docker container ls -a -f 'name=rethinkdb-server' --format '{{.Status}}'
  }
  
  ######################
  ## Presto DOCKER
  ######################
  function New-Presto {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating Presto in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=presto-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill presto-server ; if ($?) { Remove-Presto } }
      }
    }
  
    docker create --net servers -p 8080:8080 --name presto-server starburstdata/presto:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start presto-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Presto {
    Write-Output "Connecting to Presto in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it presto-server presto-cli }
    }
  }
  
  function Connect-PrestoWeb {
    $url = "http://localhost:8080"
    Write-Output "Connecting to Presto web interface at: '$url'"
    Write-Output "If web browser did not open automatically please open browser and paste in address manually"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        if ($IsLinux) {
          xdg-open $url
        } elseif ($IsMacOS) {
          open $url
        } else {
          Start-Process $url
        }
      }
    }
  }
  
  function Stop-Presto {
    docker stop presto-server -t 10
  }
  
  function Start-Presto {
    docker start presto-server
  }
  
  function Remove-Presto {
    docker container rm presto-server
  }
  
  function Get-Presto {
    docker container ls -a -f 'name=presto-server' --format '{{.Status}}'
  }
  
  ######################
  ## ScyllaDB DOCKER
  ######################
  function New-ScyllaDB {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating ScyllaDB in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=scylladb-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill scylladb-server ; if ($?) { Remove-ScyllaDB } }
      }
    }
  
    docker create --net servers -v scylladb-data:/var/lib/scylla -p 9042:9042 --name scylladb-server scylladb/scylla:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start scylladb-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-ScyllaDB {
    Write-Output "Connecting to ScyllaDB in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it scylladb-server cqlsh }
    }
  }
  
  function Stop-ScyllaDB {
    docker stop scylladb-server -t 10
  }
  
  function Start-ScyllaDB {
    docker start scylladb-server
  }
  
  function Remove-ScyllaDB {
    param(
      [switch]$Volumes
    )
    docker container rm scylladb-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm scylladb-data
    }
  }
  
  function Get-ScyllaDB {
    docker container ls -a -f 'name=scylladb-server' --format '{{.Status}}'
  }
  
  ######################
  ## Firebird DOCKER
  ######################
  function New-Firebird {
    param (
      [string]$Pass = "Start123",
      [string]$Version = "latest"
    )
    Write-Output "Creating Firebird in Docker container using version '$Version' and user 'sysdba' with password '$Pass'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=firebird-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill firebird-server ; if ($?) { Remove-Firebird } }
      }
    }
  
    docker create --net servers -v firebird-data:/firebird -p 3050:3050 -e "ISC_PASSWORD=$Pass" --name firebird-server jacobalberty/firebird:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start firebird-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Firebird {
    param(
      [string]$Pass = "Start123"
    )
    Write-Output "Connecting to Firebird in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it firebird-server /usr/local/firebird/bin/isql -user sysdba -password $Pass }
    }
  }
  
  function Stop-Firebird {
    docker stop firebird-server -t 10
  }
  
  function Start-Firebird {
    docker start firebird-server
  }
  
  function Remove-Firebird {
    param(
      [switch]$Volumes
    )
    docker container rm firebird-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm firebird-data
    }
  }
  
  function Get-Firebird {
    docker container ls -a -f 'name=firebird-server' --format '{{.Status}}'
  }
  
  ######################
  ## Vertica DOCKER
  ######################
  function New-Vertica {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating Vertica in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=vertica-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill vertica-server ; if ($?) { Remove-Vertica } }
      }
    }
  
    docker create --net servers -v vertica-data:/home/dbadmin/docker -p 5433:5433 --name vertica-server jbfavre/vertica:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start vertica-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Vertica {
    Write-Output "Connecting to Vertica in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it vertica-server /opt/vertica/bin/admintools }
    }
  }
  
  function Stop-Vertica {
    docker stop vertica-server -t 10
  }
  
  function Start-Vertica {
    docker start vertica-server
  }
  
  function Remove-Vertica {
    param(
      [switch]$Volumes
    )
    docker container rm vertica-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm vertica-data
    }
  }
  
  function Get-Vertica {
    docker container ls -a -f 'name=vertica-server' --format '{{.Status}}'
  }
  
  ######################
  ## Crate DOCKER
  ######################
  function New-Crate {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating Crate in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=crate-server' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill crate-server ; if ($?) { Remove-Crate } }
      }
    }
  
    docker create --net servers -v crate-data:/data -p 4200:4200 -p 4300:4300 -e "CRATE_HEAP_SIZE=2g" --name crate-server crate:$Version
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start crate-server
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-Crate {
    Write-Output "Connecting to Vertica in Docker container"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default { docker exec -it crate-server crash }
    }
  }
  
  function Connect-CrateWeb {
    $url = "http://localhost:4200"
    Write-Output "Connecting to Presto web interface at: '$url'"
    Write-Output "If web browser did not open automatically please open browser and paste in address manually"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        if ($IsLinux) {
          xdg-open $url
        } elseif ($IsMacOS) {
          open $url
        } else {
          Start-Process $url
        }
      }
    }
  }
  
  function Stop-Crate {
    docker stop crate-server -t 10
  }
  
  function Start-Crate {
    docker start crate-server
  }
  
  function Remove-Crate {
    param(
      [switch]$Volumes
    )
    docker container rm crate-server
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm crate-data
    }
  }
  
  function Get-Crate {
    docker container ls -a -f 'name=crate-server' --format '{{.Status}}'
  }
  
  
  ######################
  ## Portainer DOCKER
  ######################
  function New-Portainer {
    param (
      [string]$Version = "latest"
    )
    Write-Output "Creating Portainer in Docker container using version '$Version'"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {}
    }
  
    $status = $(docker ps -f 'name=portainer' --format '{{.Status}}')
    if ($null -ne $status) {
      $removeExisting = Read-Host "Container is already running. Do you want me to destroy it? (Y/n)"
      switch -Regex ($removeExisting) {
        '[Nn]' { break }
        Default { docker kill portainer ; if ($?) { Remove-Crate } }
      }
    }
  
    docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer-data:/data portainer/portainer:$Version -H unix:///var/run/docker.sock
    if ($?) { 
      Write-Output "container created"
    }
    else {
      Write-Error "Error creating container. Exiting..."
      break
    }
    docker start portainer
    if ($?) { 
      Write-Output "container started"
    }
    else {
      Write-Error "Error starting container"
      break
    }
  }
  
  function Connect-PortainerWeb {
    $url = "http://localhost:9000"
    Write-Output "Connecting to Portainer web interface at: '$url'"
    Write-Output "If web browser did not open automatically please open browser and paste in address manually"
    $confirmation = Read-Host "Are you sure you want to proceed? (Y/n)"
    switch -Regex ($confirmation) {
      '[Nn]' { break }
      Default {
        if ($IsLinux) {
          xdg-open $url
        } elseif ($IsMacOS) {
          open $url
        } else {
          Start-Process $url
        }
      }
    }
  }
  
  function Stop-Portainer {
    docker stop portainer -t 10
  }
  
  function Start-Portainer {
    docker start portainer
  }
  
  function Remove-Portainer {
    param(
      [switch]$Volumes
    )
    docker container rm portainer
    if ($PSBoundParameters.ContainsKey("Volumes")) {
      docker volume rm portainer-data
    }
  }
  
  function Get-Portainer {
    docker container ls -a -f 'name=portainer' --format '{{.Status}}'
  }
  