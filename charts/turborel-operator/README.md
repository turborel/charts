# turborel-operator

The Turborel operator, its three CustomResourceDefinitions, and the
permissions it needs to reconcile databases. A `Cluster` creates the
database Pods; this chart installs only the operator.

The operator and its API are in alpha. Kubernetes 1.33 or later is
required. Install from the Turborel Helm repository:

```sh
helm repo add turborel https://charts.turborel.com
helm repo update
helm install turborel-operator turborel/turborel-operator \
  --namespace turborel-system --create-namespace
```

The [operator README](https://github.com/turborel/turborel-operator)
covers owner credentials, Cluster examples, connections and backups.
The database image is set in `Cluster.spec.image`, separately from
the operator image here.

## Values

| Value | Default | Meaning |
|---|---|---|
| `image.repository` | `ghcr.io/turborel/turborel-operator` | the operator image |
| `image.tag` | `""` | empty uses the chart's `appVersion` |
| `image.digest` | `""` | an immutable digest; overrides the tag |
| `image.pullPolicy` | `IfNotPresent` | the operator Deployment's pull policy |
| `imagePullSecrets` | `[]` | registry credentials for the operator Deployment |
| `replicaCount` | `1` | operator processes; leader election permits one active controller |
| `watchNamespace` | `""` | empty watches all namespaces; otherwise only this existing namespace |
| `resources.requests` | `100m` CPU, `128Mi` memory | operator requests |
| `resources.limits` | `512Mi` memory | operator limits |
| `metrics.enabled` | `false` | serve authorized HTTPS metrics on port 8443 |
| `podAnnotations` | `{}` | annotations on the operator Pod |
| `nodeSelector`, `tolerations`, `affinity` | none | operator placement |

Database resources, placement and registry credentials belong in the
Cluster. `Cluster.spec.imagePullSecrets` must allow both the database
and operator images to be pulled in that database's namespace.

## Permissions

An empty `watchNamespace` installs a ClusterRole and ClusterRoleBinding.
A named namespace installs a Role and RoleBinding there instead. The
namespace must already exist. Leader-election permissions remain in
the chart's installation namespace. Install one operator for a given
watch scope; do not overlap independent installations.

Metrics use controller-runtime's self-signed serving certificate and
Kubernetes bearer-token authentication. A scraper needs permission to
GET the `/metrics` non-resource URL and a deliberate trust configuration
for that certificate. Enabling metrics adds TokenReview and
SubjectAccessReview permissions. The chart does not install a
ServiceMonitor or expose metrics publicly.

## CRDs and upgrades

The CRDs are generated from the operator's Go API. From an adjacent
operator checkout, `make chart` refreshes this chart's `crds/` directory.

Helm installs CRDs on the first installation. It does not update them
on upgrade, or delete them on uninstall. Before an upgrade, apply the
CRDs from the matching chart version. Set `CHART_VERSION` to the
release you want and use it for both commands:

```sh
helm repo update
CHART_VERSION=0.1.1
helm show crds turborel/turborel-operator --version "$CHART_VERSION" | \
  kubectl apply --server-side --force-conflicts -f -
helm upgrade turborel-operator turborel/turborel-operator \
  --namespace turborel-system --version "$CHART_VERSION" --reuse-values
```

Uninstalling the operator leaves its Clusters running without
reconciliation. Deleting a Cluster removes its Pods, but the operator
keeps data PVCs. Deleting the CRDs deletes the custom resources and can
trigger garbage collection of their dependents; do not use that as a
routine uninstall step.
