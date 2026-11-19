<p align="center">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/turborel/turborel/main/artwork/turborel-logo-white.svg">
      <img src="https://raw.githubusercontent.com/turborel/turborel/main/artwork/turborel-logo.svg" alt="turborel" width="360">
    </picture>
</p>

Helm charts for running [Turborel](https://github.com/turborel/turborel),
the relational database written in Rust, on Kubernetes.

> Turborel is in alpha, and so are its charts: a chart may change in
> any version until Turborel's first release
> ([VERSIONING.md](https://github.com/turborel/turborel/blob/main/VERSIONING.md)).

## Usage

The charts are published as a Helm repository at
[charts.turborel.io](https://charts.turborel.io/):

```
helm repo add turborel https://charts.turborel.io
helm repo update
helm install turborel turborel/turborel --namespace turborel --create-namespace
```

Each chart's README says what it installs and the values it takes.

| Chart | What it installs |
|---|---|
| [turborel](charts/turborel) | turboreld, the server, as one StatefulSet with its database on a volume of its own |

## How the charts are made

A chart parameterizes what is commonly set and no more: the image, the
server's settings, the volume, the Service, resources and scheduling.
What is not a value is left to a kustomize patch or a values file of
your own, so the charts stay small and the manual stays the reference.

Every chart is linted and rendered on each change
([lint-and-test.yml](.github/workflows/lint-and-test.yml)). On main, a
chart whose version is new is packaged and published as a GitHub
release, and listed in the repository's index on the `gh-pages` branch
([release.yml](.github/workflows/release.yml)), beside the page in
[site/](site).

## Contributing

[CONTRIBUTING.md](CONTRIBUTING.md) says how. The first pull request
from a contributor asks them to sign the
[Contributor License Agreement](CLA.md).

## License

The charts are under the BSD-2-Clause Plus Patent License in
[LICENSE](LICENSE). The name Turborel and its logos are not; see
[TRADEMARK.md](https://github.com/turborel/turborel/blob/main/TRADEMARK.md).
