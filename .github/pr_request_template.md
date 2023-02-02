## Description of the change

<!-- Describe the change being requested. -->

## Existing or Associated Issue(s)

<!-- List any related issues. -->

## Additional Information

 <!-- Provide as much information that you feel would be helpful for those reviewing the proposed changes. -->

## Checklist
- [ ] [Signed your commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)
- [ ] Chart version bumped in `Chart.yaml` according to [semver](http://semver.org/).
- [ ] Chart version bumped in [README badges](https://github.com/pact-foundation/pact-broker-chart/blob/master/charts/pact-broker/README.md?plain=1#L3).
- [ ] Variables are documented in `values.yaml` and the [pre-commit](https://pre-commit.com/) hook has been run with `pre-commit run --all-files` to generate the `README.md` documentation. To preview the content, use `helm-docs --dry-run`.
- [ ] List tests pass for Chart using the [Chart Testing](https://github.com/helm/chart-testing) tool and the `ct lint` command.
