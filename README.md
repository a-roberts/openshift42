# openshift-42-operator-work

## Background

Notes for getting the Tekton Dashboard and Webhooks Extension available on OpenShift 4.2, ideally with all dependencies installed through operators that are readily available. Zoom to the bottom of this for issues.

## Versions

- [x] **Tekton Pipelines** 0.7 via the Tekton operator
- [x] **Knative Eventing** 0.8 via the Knative Eventing Operator


- [x] **Knative Serving** 0.8.1 installed by a future/soon version of the Serverless operator, or by bypassing the Serverless Operator. 

Tried https://github.com/openshift-knative/knative-serving-operator/tree/openshift-knative/v0.8.1-1.1.0-05, details as follow.

```
git clone https://github.com/openshift-knative/knative-serving-operator.git
cd knative-serving-operator/
git checkout openshift-knative/v0.8.1-1.1.0-05
kubectl apply -f deploy/crds/serving_v1alpha1_knativeserving_crd.yaml
kubectl apply -f deploy/
```

Unfortunately the pod gets stuck in CrashLoopBackOff.

```
{"level":"error","ts":1571326555.584742,"logger":"cmd","msg":"","error":"routes.route.openshift.io is forbidden: User \"system:serviceaccount:openshift-operators:knative-serving-operator\" cannot list resource \"routes\" in API group \"route.openshift.io\" at the cluster scope","stacktrace":"github.com/openshift-knative/knative-serving-operator/vendor/github.com/go-logr/zapr.(*zapLogger).Error\n\tknative-serving-operator/vendor/github.com/go-logr/zapr/zapr.go:128\nmain.main\n\tknative-serving-operator/cmd/manager/main.go:111\nruntime.main\n\t/home/jim/local/go/src/runtime/proc.go:200"}
```
even with a manually enhanced ClusterRole.

**Pods come up great with the official Knative Serverless 1.0.0 operator so let's try that for now.**

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

