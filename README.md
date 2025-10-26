# Pact Broker Helm Chart

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) ![Release Charts](https://github.com/pact-foundation/pact-broker-chart/workflows/Release%20Charts/badge.svg?branch=master)

This repository will house the Pact Broker Helm Chart. It is important to note that this is a community maintained Helm Chart that has been brought under the Pact Foundation GitHub for ease of reference. The current maintainers are:

- [Chris Burns](https://github.com/ChrisJBurns)

We are always looking for maintainers, please let us know if you'd be interested. :)

## TL;DR

> **⚠️ IMPORTANT:** As of v4.0.0, you must provide your own PostgreSQL database. The bundled PostgreSQL subchart has been removed. More info can be found [here](https://github.com/pact-foundation/pact-broker-chart/issues/194).

```shell
helm repo add pact-broker https://pact-foundation.github.io/pact-broker-chart/

# Install with external database configuration
helm install pact-broker pact-broker/pact-broker \
  --set database.host=your-postgres-host \
  --set database.databaseName=pactbroker \
  --set database.auth.username=pactbroker \
  --set database.auth.password=your-password
```

## Usage

The Pact Broker Chart is available in the following formats:
- [Chart Repository](https://helm.sh/docs/topics/chart_repository/)
- [OCI Artifacts](https://helm.sh/docs/topics/registries/)

### Installing from Chart Repository

The following command can be used to add the chart repository:

```console
helm repo add pact-broker https://pact-foundation.github.io/pact-broker-chart/
```

Once the chart has been added, install one of the available charts:

```console
helm install pact-broker pact-broker/pact-broker
```

### Installing from an OCI Registry

Charts are also available in OCI format. The list of available charts can be found [here](https://github.com/pact-foundation/pact-broker-chart/).

Install one of the available charts:

```shell
helm upgrade -i <release_name> oci://ghcr.io/pact-foundation/pact-broker-chart/pact-broker --version=<version> \
  --set database.host=your-postgres-host \
  --set database.databaseName=pactbroker \
  --set database.auth.username=pactbroker \
  --set database.auth.password=your-password
```

## Contributing

The source code of all [Pact Broker](https://docs.pact.io/pact_broker/overview) [Helm](https://helm.sh) charts can be found on Github: <https://github.com/pact-foundation/pact-broker-chart/tree/master/charts/pact-broker/>

## License

[MIT License](https://github.com/pact-foundation/pact-broker-chart/blob/master/LICENSE).
