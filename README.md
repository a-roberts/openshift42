# openshift-42-operator-work

## Background

Musings around getting the Tekton Dashboard and Webhooks Extension available on OpenShift 4.2, ideally with all dependencies installed through operators that are readily available.

## Versions

Versions we care for:
- Tekton Pipelines: 0.7.0
- Knative components: likely 0.7.1, 0.8.1 or 0.9.0 even
- Istio: try to stick with 1.1.7

## Testing

Success criteria:

1. The applies
`oc apply -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-tekton-dashboard.yaml --validate=false`
and

`oc apply -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-webhooks-extension.yaml`

2. Access the Tekton Dashboard via its Route
3. Test the Tekton Dashboard's main functions
4. Test the Webhooks Extension

## Instructions

- Step 1: get a cluster running OpenShift 4.2: I've used IBM's Fyre service, choosing the OpenShift 4.2 ember
- Step 2: log in to your cluster console and head to the Operators view on the left
- Step 3: install operators

I've installed the OpenShift Pipelines operator (which mentions Tekton 0.7) and the Serverless 1.0.0 operator. The former is "community maintained" (RedHat) and the latter is official.

This gives me:

```
openshift-pipelines                                     tekton-pipelines-controller                             1/1       1            1           9m43s
openshift-pipelines                                     tekton-pipelines-webhook                                1/1       1            1           9m43s
```

and

```
adams-mbp:tekton-validate-github-event aroberts$ k get deployments --all-namespaces | grep knative
openshift-operators                                     knative-openshift-ingress                               1/1       1            1           11m
openshift-operators                                     knative-serving-operator                                1/1       1            1           11m
```

Step 4: todo! I'll install a bunch of other things and see what happens.

## Warning

After installing two operators, my cluster's died.

```
adams-mbp:tekton-validate-github-event aroberts$ k get deployments --all-namespaces
NAMESPACE                                               NAME                                                    READY     UP-TO-DATE   AVAILABLE   AGE
openshift-apiserver-operator                            openshift-apiserver-operator                            1/1       1            1           2d1h
openshift-authentication-operator                       authentication-operator                                 1/1       1            1           2d1h
openshift-authentication                                oauth-openshift                                         2/2       2            2           2d1h
openshift-cloud-credential-operator                     cloud-credential-operator                               1/1       1            1           2d1h
openshift-cluster-machine-approver                      machine-approver                                        1/1       1            1           2d1h
openshift-cluster-node-tuning-operator                  cluster-node-tuning-operator                            1/1       1            1           2d1h
openshift-cluster-samples-operator                      cluster-samples-operator                                1/1       1            1           2d1h
openshift-cluster-storage-operator                      cluster-storage-operator                                1/1       1            1           2d1h
openshift-cluster-version                               cluster-version-operator                                1/1       1            1           2d1h
openshift-console-operator                              console-operator                                        1/1       1            1           2d1h
openshift-console                                       console                                                 2/2       2            2           2d1h
openshift-console                                       downloads                                               2/2       2            2           2d1h
openshift-controller-manager-operator                   openshift-controller-manager-operator                   1/1       1            1           2d1h
openshift-dns-operator                                  dns-operator                                            1/1       1            1           2d1h
openshift-image-registry                                cluster-image-registry-operator                         1/1       1            1           2d1h
openshift-image-registry                                image-registry                                          1/1       1            1           2d1h
openshift-ingress-operator                              ingress-operator                                        1/1       1            1           2d1h
openshift-ingress                                       router-default                                          2/2       2            2           2d1h
openshift-insights                                      insights-operator                                       1/1       1            1           2d1h
openshift-kube-apiserver-operator                       kube-apiserver-operator                                 1/1       1            1           2d1h
openshift-kube-controller-manager-operator              kube-controller-manager-operator                        1/1       1            1           2d1h
openshift-kube-scheduler-operator                       openshift-kube-scheduler-operator                       1/1       1            1           2d1h
openshift-machine-api                                   cluster-autoscaler-operator                             1/1       1            1           2d1h
openshift-machine-api                                   machine-api-operator                                    1/1       1            1           2d1h
openshift-machine-config-operator                       etcd-quorum-guard                                       1/3       3            1           2d1h
openshift-machine-config-operator                       machine-config-controller                               1/1       1            1           2d1h
openshift-machine-config-operator                       machine-config-operator                                 1/1       1            1           2d1h
openshift-marketplace                                   certified-operators                                     1/1       1            1           2d1h
openshift-marketplace                                   community-operators                                     1/1       1            1           2d1h
openshift-marketplace                                   marketplace-operator                                    1/1       1            1           2d1h
openshift-marketplace                                   redhat-operators                                        1/1       1            1           2d1h
openshift-monitoring                                    cluster-monitoring-operator                             1/1       1            1           2d1h
openshift-monitoring                                    grafana                                                 1/1       1            1           2d1h
openshift-monitoring                                    kube-state-metrics                                      1/1       1            1           2d1h
openshift-monitoring                                    openshift-state-metrics                                 1/1       1            1           2d1h
openshift-monitoring                                    prometheus-adapter                                      2/2       2            2           2d1h
openshift-monitoring                                    prometheus-operator                                     1/1       1            1           2d1h
openshift-monitoring                                    telemeter-client                                        1/1       1            1           2d1h
openshift-network-operator                              network-operator                                        1/1       1            1           2d1h
openshift-operator-lifecycle-manager                    catalog-operator                                        1/1       1            1           2d1h
openshift-operator-lifecycle-manager                    olm-operator                                            1/1       1            1           2d1h
openshift-operator-lifecycle-manager                    packageserver                                           2/2       2            2           2d1h
openshift-operators                                     knative-openshift-ingress                               1/1       1            1           8m41s
openshift-operators                                     knative-serving-operator                                1/1       1            1           8m41s
openshift-operators                                     openshift-pipelines-operator                            1/1       1            1           10m
openshift-pipelines                                     tekton-pipelines-controller                             1/1       1            1           9m43s
openshift-pipelines                                     tekton-pipelines-webhook                                1/1       1            1           9m43s
openshift-service-ca-operator                           service-ca-operator                                     1/1       1            1           2d1h
openshift-service-ca                                    apiservice-cabundle-injector                            1/1       1            1           2d1h
openshift-service-ca                                    configmap-cabundle-injector                             1/1       1            1           2d1h
openshift-service-ca                                    service-serving-cert-signer                             1/1       1            1           2d1h
openshift-service-catalog-apiserver-operator            openshift-service-catalog-apiserver-operator            1/1       1            1           2d1h
openshift-service-catalog-controller-manager-operator   openshift-service-catalog-controller-manager-operator   1/1       1            1           2d1h
adams-mbp:tekton-validate-github-event aroberts$ k get deployments --all-namespaces
adams-mbp:tekton-validate-github-event aroberts$ k get deployments --all-namespaces | grep knative
openshift-operators                                     knative-openshift-ingress                               1/1       1            1           11m
openshift-operators                                     knative-serving-operator                                1/1       1            1           11m
```
A few minutes later...
```
adams-mbp:tekton-validate-github-event aroberts$ oc get route
No resources found.
Unable to connect to the server: 

adams-mbp:tekton-validate-github-event aroberts$ oc login
error: EOF
```
