# common-app

![Version: 0.4.1](https://img.shields.io/badge/Version-0.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: stable](https://img.shields.io/badge/AppVersion-stable-informational?style=flat-square)

A general purposes helm chart to deploy various types of applications to Kubernetes

## Features

* Supported use cases:
  * Stateless Application, including canary release deployment.
  * A Long-Running process, such as a Worker which intended to be functioning without being accessed.
  * A Cron Job or One-Time-Execution application (e.g., Job).
* Configurable CPU and Memory resource request and limit
* Several ways for exposing application through Kubernetes `Service` and/or Kubernetes `Ingress` object.
* Support with static replication size as well as Horizontal Pod Autoscaller (HPA).
* Configurable Pod Disruption Budget (PDB).
* Configurable Pod Tolerations.
* Configurable Pod Affinity.
* Configurable Pod Topology Spread Constraint.
* Configurable Pod Security Context.
* And many more.

## Additional Information

* We highly encourage to define the `commands` and `args` for the application container explicitly. This recommendation holds true even if you plan to rely on the `CMD` or `ENTRYPOINT` instruction that you've previously specified in your Dockerfile.
* For stateless application, this chart is designed to cater to the canary deployment model. Within this chart, we denote this model as the deployment *"channel"*. The supported channels are `none`, `stable`, and `canary`. Under the `stable` channel, the release will introduce two distinct kinds of Kubernetes Services. The first type is a generic service, linked to the Pod containing the `app.kubernetes.io/name` label. The second type, suffixed with channel type, corresponds to the Kubernetes Service associated with the channel's Pod through the `app.kubernetes.io/channel` label. Conversely, in the `canary` channel, only the "channel-suffixed" Kubernetes Service is introduced.
  > For instance, consider a release named `podinfo` deployed under the `stable` channel within the `foo` namespace. The release will be accessible via both `podinfo.foo.svc.cluster.local` (generic) and `podinfo-stable.foo.svc.cluster.local` (stable channel). Once the `podinfo` release also enable `canary` deployment, the access would also extend for specific channel access in this case `podinfo-canary.foo.svc.cluster.local` (canary channel). As a result, the release will have three kinds of accessible endpoint, a generic endpoint that can access both channels, a stable endpoint, and a canary endpoint.
* Once a release deployed as canary deployment, some of feature is disabled, such as Ingress, HPA, and Pod Disruption Budget.
* While for `none` deployment channel, it will create as it is without honoring the others deployment channel setup.

**Homepage:** <https://github.com/ardikabs/helm-charts>

## Installing the Chart

To install the chart with the release name `podinfo`:

```console
$ helm repo add ardikabs https://charts.ardikabs.com
$ helm install podinfo ardikabs/common-app
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| app.affinity | string | `nil` | specifies pod affinity rules |
| app.args | list | `[]` | specifies application container args |
| app.autoscaling.annotations | object | `{}` | additional annotations attached to the Horizontal Pod Autoscaler |
| app.autoscaling.enabled | bool | `false` | whether to enable autoscaling (Horizontal Pod Autoscaler) or not |
| app.autoscaling.labels | object | `{}` | additional labels attached to the Horizontal Pod Autoscaler |
| app.autoscaling.maxReplicas | int | `3` | the maximum number of replica for Horizontal Pod Autoscaler |
| app.autoscaling.minReplicas | int | `1` | the minimum number of replica for Horizontal Pod Autoscaler |
| app.autoscaling.targetCPUUtilizationPercentage | int | `70` | target CPU utilization in percent |
| app.autoscaling.targetMemoryUtilizationPercentage | int | `70` | target memory utilization in percent |
| app.command | list | `[]` | specifies application container commands |
| app.containerPorts | object | `{}` | specifies list of application container ports |
| app.deploymentAnnotations | object | `{}` | additional annotations attached to the deployment |
| app.deploymentLabels | object | `{}` | additional labels attached to the deployment |
| app.enabled | bool | `true` | specifies whether to create Deployment object |
| app.env | list | `[]` | pod customized environment variable injected to the application container |
| app.envFrom | list | `[]` | pod customized environment variable from selected reference to be injected to the application container |
| app.extraVolumeMounts | list | `[]` | specifies mount point from list of extra volumes attached to the application |
| app.extraVolumes | list | `[]` | specifies a list of extra volumes to be attached to the pod |
| app.ingress.aliases | list | `[]` | specifies aliases for the ingress that contains list of hosts and tls secret to each host. |
| app.ingress.annotations | object | `{}` | additional annotations attached to the ingress |
| app.ingress.enabled | bool | `false` | specifies whether to expose the application through the Kubernetes Ingress |
| app.ingress.host | string | `""` | specifies the host for the ingress |
| app.ingress.ingressClassName | string | `"nginx"` | specifies an ingress class name for the ingress |
| app.ingress.labels | object | `{}` | additional labels attached to the ingress |
| app.ingress.path | string | `"/"` | specifies which path for the ingress |
| app.ingress.pathType | string | `"Prefix"` | specifies path type for the ingress |
| app.ingress.tls.enabled | bool | `false` | whether enable tls for the ingress |
| app.ingress.tls.secretName | string | `""` | specifies which secret for the tls on the ingress |
| app.livenessProbe.enabled | bool | `false` | specifies whether pod liveness probe being created or not |
| app.livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. |
| app.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before liveness probes are initiated. |
| app.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. Default to 10 seconds. |
| app.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1 |
| app.livenessProbe.timeoutSeconds | int | `1` | Number of seconds after which the probe times out. Defaults to 1 second. |
| app.minReadySeconds | int | `0` | minimum number of seconds for which a newly created pod should be ready, defaults to 0. |
| app.nodeSelector | object | `{}` | describes which node must be used for the application pod |
| app.podAnnotations | object | `{}` | additional annotations attached to the pods |
| app.podDisruptionBudget.annotations | object | `{}` | additional annotations attached to the Pod Disruption Budget |
| app.podDisruptionBudget.enabled | bool | `false` | whether to enable Pod Disruption Budget or not |
| app.podDisruptionBudget.labels | object | `{}` | additional labels attached to the Pod Disruption Budget |
| app.podDisruptionBudget.maxUnavailable | string | `"25%"` | maximum percentage/number of the unavailable pods during disruption |
| app.podDisruptionBudget.minAvailable | int | `0` | minimum percentage/number of the available pods during disruption |
| app.podLabels | object | `{}` | additional labels attached to the pods |
| app.podLastRestart | int | `0` | the value that intend for restarting the pod |
| app.readinessProbe.enabled | bool | `false` | specifies whether pod readiness probe being created or not |
| app.readinessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. |
| app.readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before probes are initiated. |
| app.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. Default to 10 seconds. |
| app.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. |
| app.readinessProbe.timeoutSeconds | int | `1` | Number of seconds after which the probe times out. Defaults to 1 second. |
| app.replicas | int | `1` | specifies the default number of replica sizes, it will be ignored if app.autoscaling.enabled is true |
| app.resources | object | `{}` | specifies resource size of the application container |
| app.rollingUpdate | object | `{"maxSurge":"30%","maxUnavailable":0}` | control how rolling update is performed during the deployment |
| app.rollingUpdate.maxSurge | string | `"30%"` | specifies the maximum number of Pods that can be created over the desired number of Pods. |
| app.rollingUpdate.maxUnavailable | int | `0` | specifies the maximum number of Pods that can be unavailable during the update process |
| app.securityContext | object | `{}` | specifies security context applied to the pod |
| app.service.annotations | object | `{}` | additional annotations attached to the Service |
| app.service.enabled | bool | `true` | specifies whether to expose the application through the Kubernetes Service |
| app.service.labels | object | `{}` | additional labels attached to the Service |
| app.service.ports | object | `{"http":{"port":80,"protocol":"TCP","targetPort":0}}` | specifies list of Kubernetes Service ports being exposed |
| app.service.ports.http | object | `{"port":80,"protocol":"TCP","targetPort":0}` | the Service's named port |
| app.service.ports.http.port | int | `80` | the Service's port, recommended to always use port 80 |
| app.service.ports.http.protocol | string | `"TCP"` | the Service's protocol |
| app.service.ports.http.targetPort | int | `0` | the Pod target port, it defaults to the service's named port |
| app.service.type | string | `"ClusterIP"` | the Kubernetes Service's type, (supported values: `ClusterIP`, `LoadBalancer`) |
| app.startupProbe.enabled | bool | `false` | specifies whether pod startup probe being created or not |
| app.startupProbe.failureThreshold | int | `20` | Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 20. |
| app.startupProbe.initialDelaySeconds | int | `1` | Number of seconds after the container has started before probes are initiated. |
| app.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. Default to 1 seconds. |
| app.startupProbe.timeoutSeconds | int | `1` | Number of seconds after which the probe times out. Defaults to 1 second. |
| app.terminationGracePeriodSeconds | int | `30` | duration in seconds the pod needs to terminate gracefully |
| app.tolerations | list | `[]` | describes which toleration used for the application pod to specify target node |
| app.topologySpreadConstraints | list | `[]` | describes how a group of pods ought to spread across topology domains |
| configmap.annotations | object | `{}` | additional annotations attached to the ConfigMap |
| configmap.data | object | `{}` | specifies literal data as a form of Key/Value |
| configmap.enabled | bool | `false` | specifies whether to create ConfigMap object. |
| configmap.injectAsConfig.enabled | bool | `false` | specifies whether attach configmap to the container as config through volume or environment variable. It defaults to false, which mean injected as environment variable. Once enabled, the app config file will be mounted at `/usr/share/app-config-file/`. |
| configmap.injectAsConfig.keys | list | `[]` | list of keys as file name to be mounted |
| configmap.labels | object | `{}` | additional labels attached to the ConfigMap |
| global.channel | string | `"none"` | specifies application deployment channel (supported values: `none`, `stable`, and `canary`) |
| global.image.pullPolicy | string | `"IfNotPresent"` | specifies what policy for the image pull |
| global.image.repository | string | `"img"` | specifies which image container registry being used |
| global.image.tag | string | `"undefined"` | specifies which image container version being used |
| global.imagePullSecrets | list | `[]` | specifies list of image pull secrets attached to the pod |
| global.managedBy | string | `""` | mark the manager of the resource, default to 'Helm' |
| global.serviceAccount.additionalClusterRoles | list | `[]` | additional cluster roles specification to add to service account access |
| global.serviceAccount.additionalRoles | list | `[{"apiGroups":[""],"resources":["secrets","configmaps"],"verbs":["get","list","watch"]}]` | additional roles specification to add to service account access |
| global.serviceAccount.create | bool | `false` | specifies whether to create a service account or not for the Pod |
| global.serviceAccount.createToken | bool | `false` | specifies whether to create non-expired token for the service account |
| global.serviceAccount.name | string | `""` | specifies the existing service account name |
| job.activeDeadlineSeconds | int | `0` | specifies the duration in seconds relative to the startTime that the job  may be continuously active before the system tries to terminate it |
| job.affinity | string | `nil` | specifies job's pod affinity rules |
| job.args | list | `[]` | specifies list of job's container args |
| job.backoffLimit | int | `6` | specifies the number of retries before marking this job failed |
| job.command | list | `[]` | specifies list of job's container commands |
| job.completionMode | string | `"NonIndexed"` | completionMode specifies how Pod completions are tracked. |
| job.completions | int | `1` | specifies the desired number of successfully finished pods the job should  be run with |
| job.cron.annotations | object | `{}` | additional annotations attached to the CronJob |
| job.cron.concurrencyPolicy | string | `"Allow"` | specifies how to treat concurrent executions of a Job, default to Allow please refer to https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#concurrency-policy |
| job.cron.enabled | bool | `false` | specifies whether to create CronJob object instead of Job |
| job.cron.labels | object | `{}` | additional labels attached to the CronJob |
| job.cron.schedule | string | `""` | the cron schedule |
| job.cron.startingDeadlineSeconds | int | `0` | optional deadline in seconds for starting the job if it misses scheduled time for any reason. |
| job.cron.suspend | bool | `false` | decide whether the cron job is suspended for a while |
| job.cron.timeZone | string | `"UTC"` | the time zone name for the given cron schedule |
| job.enabled | bool | `false` | specifies whether to create Job object |
| job.env | list | `[]` | pod customized environment variable injected to the application container |
| job.envFrom | list | `[]` | pod customized environment variable from selected reference to be injected to the application container |
| job.extraVolumeMounts | list | `[]` | specifies mount point from list of extra volumes attached to the application |
| job.extraVolumes | list | `[]` | specifies a list of extra volumes to be attached to the pod |
| job.initContainers | list | `[]` | specifies list of initContainers for the job's container |
| job.jobAnnotations | object | `{}` | additional annotations attached to the Job |
| job.jobLabels | object | `{}` | additional labels attached to the Job |
| job.nodeSelector | object | `{}` | describes which node must be used for the job pod |
| job.parallelism | int | `1` | specifies the maximum desired number of pods the job should run at any given time |
| job.podAnnotations | object | `{}` | additional annotations attached to the pods |
| job.podLabels | object | `{}` | additional labels attached to the pods |
| job.resources | object | `{}` | specifies resource size of the job container |
| job.restartPolicy | string | `"OnFailure"` | specifies the job's Pod restart policy |
| job.securityContext | object | `{}` | specifies security context applied to the pod |
| job.terminationGracePeriodSeconds | int | `30` | duration in seconds the pod needs to terminate gracefully |
| job.tolerations | list | `[]` | describes which toleration used for the job pod to specify target node |
| job.topologySpreadConstraints | list | `[]` | describes how a group of pods ought to spread across topology domains |
| job.ttlSecondAfterFinished | string | `nil` | define the lifetime of a Job that has finished execution. If set, the job will be automatically deleted after Job finished (either Completed or Failed) in defined seconds. |
| labels | object | `{"domain":"common","team":"core"}` | specifies a reserved labels attached to all objects used in the release |
| labels.domain | string | `"common"` | specifies the application belong to which product domain |
| labels.team | string | `"core"` | specifies the application belong to which team |
| legacy.enabled | bool | `false` | specifies whether the release follows legacy deployment |
| secret.annotations | object | `{}` | additional annotations attached to the Secret |
| secret.data | object | `{}` | specifies literal data as a form of Key/Value |
| secret.enabled | bool | `false` | specifies whether to create Secret object. |
| secret.externalSecret.enabled | bool | `false` | specifies whether to create ExternalSecret (by ExternalSecretOperator) object. |
| secret.externalSecret.refreshInterval | string | `"10s"` | specifies the refresh interval which refer to an interval to rematching the value from the provider. It is a valid time units such as "ns", "ms", "s", "m", and so forth. |
| secret.externalSecret.remoteRefs | list | `[]` | specifies list of remote reference to be populated. |
| secret.externalSecret.secretStoreRef.kind | string | `"ClusterSecretStore"` | specifies the secret store being used. It defaults to `ClusterSecretStore`. |
| secret.externalSecret.secretStoreRef.name | string | `"default"` | specifies the secret store name |
| secret.externalSecret.targetCreationPolicy | string | `"Owner"` | specifies how external secret treat the secret object creation. |
| secret.injectAsConfig.enabled | bool | `false` | specifies whether attach secret to the container as config file (volume) or environment variable. It defaults to false, which mean injected as environment variable. Once enabled, the app secret file will be mounted at `/usr/share/app-secret-file/`. |
| secret.injectAsConfig.keys | list | `[]` | list of keys as file name to be mounted |
| secret.labels | object | `{}` | additional labels attached to the Secret |
| secret.type | string | `"Opaque"` | the secret type. Supported values: `Opaque`, `kubernetes.io/tls`, and `kubernetes.io/dockerconfigjson` |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| ardikabs | <me@ardikabs.com> | <https://site.ardikabs.com> |
