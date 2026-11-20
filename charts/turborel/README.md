# turborel

Turborel, the relational database, served by turboreld on Kubernetes:
one StatefulSet, its database on a volume of its own, and a Service
clients connect to on port 7422.

```
helm repo add turborel https://charts.turborel.com
helm repo update
helm install turborel turborel/turborel --namespace turborel --create-namespace
```

The default image is `ghcr.io/turborel/turborel:nightly`, containing
both the server and command-line client. Set `image.tag` to a tested
commit tag when you need a fixed build.

## Values

| Value | Default | Meaning |
|---|---|---|
| `image.repository` | `ghcr.io/turborel/turborel` | the published Turborel image |
| `image.tag` | `""` | its tag; empty uses `nightly`, the chart's `appVersion` |
| `image.pullPolicy` | `IfNotPresent` | |
| `imagePullSecrets` | `[]` | |
| `settings` | `{}` | the server's settings, each passed as `--set NAME=VALUE` and kept with the database |
| `persistence.size` | `10Gi` | the volume the database is kept on |
| `persistence.storageClassName` | `""` | its StorageClass; empty takes the cluster's default |
| `persistence.accessModes` | `[ReadWriteOnce]` | |
| `service.type` | `ClusterIP` | |
| `service.port` | `7422` | the port clients connect to; the server's own stays 7422 |
| `service.annotations` | `{}` | |
| `serviceAccount.create` | `true` | |
| `serviceAccount.name` | `""` | empty takes the release's full name |
| `serviceAccount.annotations` | `{}` | |
| `resources` | `{}` | |
| `terminationGracePeriodSeconds` | `60` | the server lets statements finish for `SERVER.SHUTDOWN_TIMEOUT_MS` first |
| `podSecurityContext` | runs as 65532, seccomp `RuntimeDefault` | |
| `securityContext` | no privilege escalation, read-only root, no capabilities | |
| `podAnnotations`, `podLabels` | `{}` | |
| `nodeSelector`, `tolerations`, `affinity` | none | |

## What it leaves to you

The chart runs one server. Replication (`REPLICATION.MEMBERS`, port
7423), TLS (`SERVER.TLS` and its PEM files), encryption keys (`--keys`)
and backups are the manual's, and are set up with a kustomize patch or
a values file over this chart rather than parameters of it.
