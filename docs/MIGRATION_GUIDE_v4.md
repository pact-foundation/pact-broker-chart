# Migration Guide: Upgrading to Pact Broker Helm Chart v4.0.0

## Overview

Version 4.0.0 of the Pact Broker Helm Chart introduces a **breaking change**: the removal of the bundled PostgreSQL subchart. This change was necessary due to Bitnami's decision to discontinue its Helm charts and container images as free open-source offerings.

Users must now provide their own PostgreSQL database instance when deploying the Pact Broker.

## Why This Change?

- **Licensing Changes**: Bitnami has moved away from providing free open-source Helm charts and container images
- **No Suitable Replacements**: There are no strong, like-for-like replacements for Bitnami's PostgreSQL chart that offer the same level of maintenance and reliability
- **Production Best Practices**: Most production deployments already use managed PostgreSQL services from cloud providers, making the bundled database less necessary
- **Reduced Complexity**: Removing the subchart simplifies the Helm chart and reduces maintenance overhead

## Migration Steps

### Scenario 1: Already Using External Database

If you are already using an external database, you'll only need to update the value field names. This can be done as follows:

Change
```yaml
externalDatabase:
  enabled: true
  config:
    host: "your.new.postgres.host"
    port: "5432"
    adapter: "postgres"
    databaseName: "pactbroker"
  auth:
    username: "pactbroker"
    existingSecret: "pact-broker-db-secret"
    existingSecretPasswordKey: "database-password"
```

To
```yaml
database:
  host: "your.new.postgres.host"
  port: "5432"
  adapter: "postgres"
  databaseName: "pactbroker"
  auth:
    username: "pactbroker"
    existingSecret: "pact-broker-db-secret"
    existingSecretPasswordKey: "database-password"
```

### Scenario 2: Migrate from Chart Provisioned Database with Value Driven Database Auth Credentials

If you were using the chart provisioned database, and used the values to contain the config for the database, ensure that you take a backup of the data of the database and restore it to your new postgres database. 

> Note: Using plain values should only be done in production if you are using tools such as Bitnami Sealed secrets or SOPS. Unless you are doing this, you should not put credentials in values files and should instead use Kubernetes secrets (scenario below)

Once this has been done, apply the following changes:

Change

```yaml
postgresql:
  enabled: true
  auth:
    username: bn_broker
    password: "my-password"
    database: pactbroker
```

To

```yaml
database:
  host: "your.new.postgres.host"
  port: "5432"
  adapter: "postgres"
  databaseName: "pactbroker"
  auth:
    username: "new-username"
    password: "new-password"
```

### Scenario 2: Migrate from Chart Provisioned Database with Kubernetes Secrets Driven Auth Credentials

If you were using the chart provisioned database, and used Kubernetes secrets to contain the authentication credentials for connection to the database, ensure that you take a backup of the data of the database and restore it to your new postgres database.

Once this has been done, apply the following changes:

Change

```yaml
postgresql:
  enabled: true
  auth:
    username: pactbroker
    database: pactbroker
    existingSecret: "pact-broker-db-secret"
    secretKeys:
      userPasswordKey: database-password
    
```

To

```yaml
database:
  host: "postgres.example.com"
  port: "5432"
  adapter: "postgres"
  databaseName: "pactbroker"
  auth:
    username: "pactbroker"
    existingSecret: "pact-broker-db-secret"
    existingSecretPasswordKey: "database-password"
```
