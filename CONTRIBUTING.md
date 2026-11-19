# Contributing

## A change

A chart lives in `charts/NAME`. Every change to one bumps `version` in
its `Chart.yaml`, following [Semantic Versioning](https://semver.org/):
a fix is a patch, a new value a minor, a value removed or renamed a
major. The check fails without the bump, and the release workflow
publishes nothing for a version already released.

`appVersion` is the release of Turborel the chart runs by default, and
is bumped when that changes.

## Checking a change

The checks of CI, run by hand. [Helm](https://helm.sh/docs/intro/install/)
is needed, and [chart-testing](https://github.com/helm/chart-testing)
with its [yamllint](https://github.com/adrienverge/yamllint) and
[Yamale](https://github.com/23andMe/Yamale):

```
brew install helm chart-testing yamllint
pip install yamale
```

Lint the charts that differ from main, and render one:

```
ct lint --config .github/configs/ct.yaml --lint-conf .github/configs/lintconf.yaml
helm template turborel charts/turborel --namespace turborel
```

To install one on a cluster of your own, with
[kind](https://kind.sigs.k8s.io/) for one on your machine:

```
kind create cluster
helm install turborel charts/turborel --namespace turborel --create-namespace
```

## The page

`site/` is the Helm repository's page, served from the `gh-pages`
branch at [charts.turborel.io](https://charts.turborel.io/).
The release workflow copies it there on each push to main that changes
it; `index.yaml` beside it is chart-releaser's. The page is one file of
HTML, in the style of [turborel.com](https://turborel.com/).

## Pull requests

Base the branch on main. Say in the description what the change does
and why, and link the issue if there is one. The first pull request
from a contributor asks them to sign the
[Contributor License Agreement](CLA.md) by a comment, which the CLA
check explains.

## License

The charts are under the BSD-2-Clause Plus Patent License in
[LICENSE](LICENSE), and a contribution is made under that license.
