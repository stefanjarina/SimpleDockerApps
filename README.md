# SimpleDockerApps

A PowerShell module for simply creating a various servers or apps in a docker containers

**This is still a work in progress, however the various functions shall be working**
**The API might still be changing**

## TODO

- [x] Add prefix to all functions
- [x] Add help strings to all functions
- [x] Extract some common functionality (e.g. confirmation messages, status checks, ...)
- [x] Add more management functions for bulk actions (stop/start all, etc.)
- [x] Generate documentation (probably leverage platyPS)
- [ ] More general polish (e.g. typos, common messages to be similar, naming to be similar, etc.)
- [x] Properly fill manifest file
- [ ] Publish to PSGallery
- [ ] Improve installation instructions (shall be solved by PS Gallery)
- [ ] Add more customization options with sane defaults (e.g. custom ports, custom network, ...)
- [ ] Write Pester tests

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

For full documentation please see [docs](./docs)

## Supported Services

- [MS SQL](https://www.microsoft.com/en-us/sql-server/sql-server-2019) - [Docker HUB page](https://hub.docker.com/_/microsoft-mssql-server)
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

- [ ] elasticsearch - fix cli connect command
