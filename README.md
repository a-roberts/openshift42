# openshift-42-operator-work

## Background

Notes for getting the Tekton Dashboard and Webhooks Extension available on OpenShift 4.2, ideally with all dependencies installed through operators that are readily available. Zoom to the bottom of this for issues.

## Versions

- [x] **Tekton Pipelines** 0.7 via the Tekton operator
- [x] **Knative Eventing** 0.8 via the Knative Eventing Operator


- [ ] **Knative Serving** 0.8.1 installed by the Knative Serverless Operator 1.1.0

https://github.com/openshift-knative/serverless-operator/blob/master/olm-catalog/serverless-operator/serverless-operator.v1.1.0.clusterserviceversion.yaml

I think this 1.1.0 operator does nothing, I'm in the `openshift-operators` namespace - changed placeholder to be `openshift-operators` then did an `oc apply` of https://raw.githubusercontent.com/openshift-knative/serverless-operator/master/olm-catalog/serverless-operator/serverless-operator.v1.1.0.clusterserviceversion.yaml

```
adams-mbp:serverless-operator aroberts$ oc apply -f serverless-operator.v1.1.0.clusterserviceversion.yaml 
clusterserviceversion.operators.coreos.com/serverless-operator.v1.1.0 created

adams-mbp:serverless-operator aroberts$ k get all -n openshift-operators
NAME                                                READY     STATUS    RESTARTS   AGE
pod/knative-eventing-operator-56b75948c5-x7sll      1/1       Running   0          19h
pod/openshift-pipelines-operator-75d79846c5-tdvs5   1/1       Running   0          19h

NAME                                           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
service/knative-eventing-operator              ClusterIP   172.30.254.4     <none>        8383/TCP            19h
service/openshift-pipelines-operator-metrics   ClusterIP   172.30.255.229   <none>        8383/TCP,8686/TCP   19h

NAME                                           READY     UP-TO-DATE   AVAILABLE   AGE
deployment.apps/knative-eventing-operator      1/1       1            1           19h
deployment.apps/openshift-pipelines-operator   1/1       1            1           19h

NAME                                                      DESIRED   CURRENT   READY     AGE
replicaset.apps/knative-eventing-operator-56b75948c5      1         1         1         19h
replicaset.apps/openshift-pipelines-operator-75d79846c5   1         1         1         19h
```

- [x] **Knative Eventing-Contrib** 0.8 installed directly: 

`oc apply -f https://github.com/knative/eventing-contrib/releases/download/v0.8.0/github.yaml`

- [x] **Istio 1.1.7** still (installed directly?).

Eventually something like this (quoting Dan Cleyrat) as a method:

```
install service mesh via OLM
it has deps on other operators, need to install those deps, because the dep resolution in OLM isn't ideal - working something out for the entirety of the kab stack, will socialize it once i'm satisfied
```

For now, I'll use the existing install script for our Tekton Webhooks Extension pointing to 1.1.16.

## Testing

On an OpenShift 4.2 cluster with one master and three workers (my cluster died after installing two operators with just one worker)...

Success criteria:

1. 
`oc apply -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-tekton-dashboard.yaml --validate=false`

and

`oc apply -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-webhooks-extension.yaml`

must work

2. Access the Tekton Dashboard via its Route
3. Test the Tekton Dashboard's main functions
4. Test the Webhooks Extension

## Instructions

- Step 1: get a cluster running OpenShift 4.2: I've used IBM's Fyre service, choosing the OpenShift 4.2 ember
- Step 2: log in to your cluster console and head to the Operators view on the left
- Step 3: install operators (see *versions*) above
- Step 4: apply above yaml
- Step 5: access created Tekton Dashboard route and test

## Issues

- 0.8.1 latest code for Knative Serving gives an RBAC error (cloned and applied from a tag)
- Our yaml still references tekton-pipelines but the Tekton operator installs into openshift-pipelines, so it's time to apply a big ol' sed *or* change all of our references to be `openshift-pipelines`. I'll do a big ol' sed for now

