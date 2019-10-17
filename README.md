# openshift-42-operator-work

## Background

Notes for getting the Tekton Dashboard and Webhooks Extension available on OpenShift 4.2, ideally with all dependencies installed through operators that are readily available.

## Versions

- [x] **Tekton Pipelines** 0.7 via the Tekton operator
- [x] **Knative Eventing** 0.8 via the Knative Eventing Operator
- [x] **Knative Serving** 0.8.1 installed by a future/soon version of the Serverless operator, or by bypassing the Serverless Operator. https://github.com/openshift-knative/knative-serving-operator/tree/openshift-knative/v0.8.1-1.1.0-05 for now?

This repo's obsolete, 0.9 will be at https://github.com/knative/serving-operator so may as well test too

```
git clone https://github.com/openshift-knative/knative-serving-operator.git
cd knative-serving-operator/
git checkout openshift-knative/v0.8.1-1.1.0-05
kubectl apply -f deploy/crds/serving_v1alpha1_knativeserving_crd.yaml
kubectl apply -f deploy/
```
- [x] **Knative Eventing-Contrib** 0.8 installed directly: 

`oc apply -f https://github.com/knative/eventing-contrib/releases/download/v0.8.0/github.yaml`

- [ ] **Istio 1.1.7** still (installed directly?). Maybe not, installed through Maistra Operator?

Eventually something like this (quoting Dan Cleyrat) as a method:

```
install service mesh via OLM
it has deps on other operators, need to install those deps, because the dep resolution in OLM isn't ideal - working something out for the entirety of the kab stack, will socialize it once i'm satisfied
```

For now, I'll use the existing install script for our Tekton Webhooks Extension pointing to 1.1.16.

## Testing

On an OpenShift 4.2 cluster with one master and three workers (my cluster died after installing two operators with just one worker)...

Success criteria:

1. The applies

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
