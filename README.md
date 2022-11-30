# Pact Broker Helm Chart

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) ![Release Charts](https://github.com/pact-foundation/pact-broker-chart/workflows/Release%20Charts/badge.svg?branch=master)

This repository will house the Pact Broker Helm Chart. It is important to note that this is a community maintained Helm Chart that has been brought under the Pact Foundation GitHub for ease of reference. The current maintainers are:

- [Chris Burns](https://github.com/ChrisJBurns)

We are always looking for maintainers, please let us know if you'd be interested. :)

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add pact-broker https://pact-foundation.github.io/pact-broker-chart/
helm install pact-broker pact-broker/pact-broker
```

You can then run `helm search repo pact-broker` to see the charts.

## Helm-Docs
We use [helm-docs](https://github.com/norwoodj/helm-docs) to automatically generate the documentation for the charts. To run the autogeneration of the Helm documentation download the [helm-docs `cli`](https://github.com/norwoodj/helm-docs) tool and then run the following command inside the `charts/pact-broker` folder.

```console
helm-docs --template-files _readme_templates.gotmpl
```

## Contributing

The source code of all [Pact Broker](https://docs.pact.io/pact_broker/overview) [Helm](https://helm.sh) charts can be found on Github: <https://github.com/pact-foundation/pact-broker-chart/tree/master/charts/pact-broker/>

## License

[MIT License](https://github.com/pact-foundation/pact-broker-chart/blob/master/LICENSE).
