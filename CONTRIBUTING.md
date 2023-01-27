# How to Contribute to Pact Broker Helm Chart

Before making a contribution to the [Pact Broker Helm Chart](https://github.com/pact-foundation/pact-broker-chart) you will need to ensure the following steps have been done:
- [Sign your commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)
- Run `helm template` on the changes you're making to ensure they are correctly rendered into Kubernetes manifests.
- List tests has been run for the Chart using the [Chart Testing](https://github.com/helm/chart-testing) tool and the `ct lint` command.
- Ensure variables are documented in `values.yaml` and the [pre-commit](https://pre-commit.com/) hook has been run with `pre-commit run --all-files` to generate the `README.md` documentation. To preview the content, use `helm-docs --dry-run`.
- If you are making changes to the Chart - remember to bump the Chart version following [SemVer](https://semver.org/). You will need to change the [Chart Version](https://github.com/pact-foundation/pact-broker-chart/blob/master/charts/pact-broker/Chart.yaml#L5) and the [Chart Badge](https://github.com/pact-foundation/pact-broker-chart/blob/master/charts/pact-broker/README.md?plain=1#L3) on the README.
