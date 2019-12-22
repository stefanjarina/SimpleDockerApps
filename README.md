# SimpleDockerApps

A PowerShell module for simply creating a various servers or apps in a docker containers

**This is still a work in progress, however the various functions shall be working**
**The API might still be changing**

## TODO

- [x] Add prefix to all functions
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
if ($env:PSModulePath -notmatch 'powershell\\modules') {
  $env:PSModulePath = $env:PSModulePath + ';E:\powershell\modules'
}
Import-Module SimpleDockerApps -Force
```

## Usage

### `Get-SdaAllCreated`

- Lists of all created services and their status

### `Get-SdaAllRunning`

- Lists only running services

### `New-Sda<ServiceName>` [-Password \<password\>] [-Version \<version\>]

- Downloads an image if not already in cache
- Creates new docker container
  - bound to default network `servers`
  - exposing applications default ports on localhost
  - name ends in `-server`
- Starts docker container

### `Connect-Sda<ServiceName>` [-Password \<password\>]

- Connects directly to docker servise (using `docker exec` and native cli app (if exists))

### `New-Sda<ServiceName>Web` [-Password \<password\>]

- Some services have a web interface exposed by default, this functions open the web page in default web browser based on system

### `Get-Sda<ServiceName>`

- Gets a status of a docker container

### `Start-Sda<ServiceName>`

- Starts a docker container

### `Stop-Sda<ServiceName>`

- Stops a docker container

### `Remove-Sda<ServiceName>` [-Volumes]

- Removes a docker container
- If `-Volumes` is specified, removes also volumes

## Supported Services

- [MSSQL](https://www.microsoft.com/en-us/sql-server/sql-server-2019) - [Docker HUB page](https://hub.docker.com/_/microsoft-mssql-server)
- [Postgres](https://www.postgresql.org/) - [Docker HUB page](https://hub.docker.com/_/postgres)
- [Mariadb](https://mariadb.org/) - [Docker HUB page](https://hub.docker.com/_/mariadb)
- [OracleDb](https://www.oracle.com/database/) - (Unfortunately this requires local built image due to Oracles inability to provide one)
  - Instructions for building an image are in [oracle/docker-images repo](https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance)
  - Oracle really missed a train here, it is not a simple task to get it running in docker
  - It can be built only in linux as they provide only shell scripts (/sight)
  - I might still have somewhere powershell scripts for building oracle, but no plans to provide them right now
  - Seriously, just ditch this mess of a database for something more sane, like MSSQL or PostgreSQL
- [Mongodb](https://www.mongodb.com/) - [Docker HUB page](https://hub.docker.com/_/mongo)
- [Redis](https://redis.io/) - [Docker HUB page](https://hub.docker.com/_/redis)
- [Cassandra](http://cassandra.apache.org/) - [Docker HUB page](https://hub.docker.com/_/cassandra)
- [Ravendb](https://ravendb.net/) - [Docker HUB page](https://hub.docker.com/r/ravendb/ravendb)
- [Clickhouse](https://clickhouse.yandex/) - [Docker HUB page](https://hub.docker.com/r/yandex/clickhouse-server)
- [Dremio](https://www.dremio.com/) - [Docker HUB page](https://hub.docker.com/r/dremio/dremio-oss)
- [Dynamodb](https://aws.amazon.com/dynamodb/) - [Docker HUB page](https://hub.docker.com/r/amazon/dynamodb-local/)
- [Elasticsearch](https://www.elastic.co/) - [Docker HUB page](https://hub.docker.com/_/elasticsearch)
- [Solr](https://lucene.apache.org/solr/) - [Docker HUB page](https://hub.docker.com/_/solr)
- [Neo4j](https://neo4j.com/) - [Docker HUB page](https://hub.docker.com/_/neo4j)
- [OrientDB](https://orientdb.com/) - [Docker HUB page](https://hub.docker.com/_/orientdb)
- [ArangoDB](https://www.arangodb.com/) - [Docker HUB page](https://hub.docker.com/_/arangodb)
- [RethinkDB](https://rethinkdb.com/) - [Docker HUB page](https://hub.docker.com/_/rethinkdb)
- [Presto](https://prestodb.io/) - [Docker HUB page](https://hub.docker.com/r/starburstdata/presto)
- [ScyllaDB](https://www.scylladb.com/) - [Docker HUB page](https://hub.docker.com/r/scylladb/scylla)
- [Firebird](https://firebirdsql.org/) - [Docker HUB page](https://hub.docker.com/r/jacobalberty/firebird)
- [Vertica](https://www.vertica.com/) - [Docker HUB page](https://hub.docker.com/r/jbfavre/vertica)
- [Crate](https://crate.io/) - [Docker HUB page](https://hub.docker.com/_/crate)
- [Portainer](https://www.portainer.io/) - [Docker HUB page](https://hub.docker.com/r/portainer/portainer)

### Ultimate TODO for services

- investigate elasticsearch, seems they moved repo from their own repository to docker hub, needs change and testing
