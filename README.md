# openshift-42-operator-work

## Background

Notes for getting the Tekton Dashboard and Webhooks Extension available on OpenShift 4.2, ideally with all dependencies installed through operators that are readily available. Zoom to the bottom of this for issues.

## Critical

https://docs.openshift.com/container-platform/4.2/nodes/nodes/nodes-nodes-working.html#nodes-nodes-working-master-schedulable_nodes-nodes-working

Fyre's OpenShift ember makes the master nodes schedulable. After installing everything and waiting a while, your cluster will become completely unusable unless you make the master nodes *only* master nodes and *not* masters and workers too.

## Versions

- [x] **Tekton Pipelines** 0.7 via the Tekton operator (RedHat provided, community)
- [x] **ServiceMesh** 1.0.1 via the Service Mesh operator (RedHat provided)
- [x] **Knative Eventing** 0.8 via the Knative Eventing Operator (community)
- [x] **Knative Eventing-Contrib** 0.8 installed directly: 
`oc apply -f https://github.com/knative/eventing-contrib/releases/download/v0.8.0/github.yaml`
- [x] **Knative Serving** 0.8.1 installed by the Knative Serverless Operator 1.1.0

When installing from GitHub (https://github.com/openshift-knative/serverless-operator) you'll notice there's a mistake in the readme, you want this (so where OLM_NS was mentioned it's now `openshift-marketplace`):

`./hack/catalog.sh | kubectl apply -n openshift-marketplace -f -`

```
OPERATOR_NS=$(kubectl get og --all-namespaces | grep global-operators | awk '{print $1}')

cat <<-EOF | kubectl apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: serverless-operator-sub
  generateName: serverless-operator-
  namespace: $OPERATOR_NS
spec:
  source: serverless-operator
  sourceNamespace: openshift-marketplace
  name: serverless-operator
  channel: techpreview
EOF

./hack/catalog.sh | kubectl apply -n openshift-marketplace -f -
```
Then you install the operator through the UI.

## Instructions

- Step 1: get a cluster running OpenShift 4.2: I've used IBM's Fyre service, choosing the OpenShift 4.2 ember - three master nodes, five workers, or you'll get EOF problems aka Kube API server deaths because master nodes are labelled as workers too
- Step 2: log in to your cluster console and head to the Operators view on the left
- Step 3: install operators (see *versions*) above
- Step 4: follow https://access.redhat.com/documentation/en-us/openshift_container_platform/4.2/html/serverless/installing-openshift-serverless
- Step 5: install Tekton Dashboard and Webhooks Extension
- Step 6: access created Tekton Dashboard route and test:

`oc apply -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-tekton-dashboard.yaml --validate=false`

`oc apply -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-webhooks-extension.yaml`

## A note on namespaces and the ServiceMesh

See https://access.redhat.com/documentation/en-us/openshift_container_platform/4.2/html/serverless/installing-openshift-serverless#installing-service-mesh-member-roll_installing-openshift-serverless.

Ensure any namespace that creates a ksvc is in that ServiceMeshMemberRoll. Should be made easier with Serverless 1.2.0.
