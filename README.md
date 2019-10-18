# openshift-42-operator-work

## Background

Notes for getting the Tekton Dashboard and Webhooks Extension available on OpenShift 4.2, ideally with all dependencies installed through operators that are readily available. Zoom to the bottom of this for issues.

## Versions

- [x] **Tekton Pipelines** 0.7 via the Tekton operator (RedHat provided, community)
- [x] **ServiceMesh** 1.0.1 via the Service Mesh operator (RedHat provided)
- [x] **Knative Eventing** 0.8 via the Knative Eventing Operator (community)
- [x] **Knative Eventing-Contrib** 0.8 installed directly: 
`oc apply -f https://github.com/knative/eventing-contrib/releases/download/v0.8.0/github.yaml`
- [ ] **Knative Serving** 0.8.1 installed by the Knative Serverless Operator 1.1.0?

Todo confirm this is good!

Follow https://access.redhat.com/documentation/en-us/openshift_container_platform/4.2/html/serverless/installing-openshift-serverless which involves

1) install the RedHat provided 1.0.1 Service Mesh operator through OLM
2) create the `istio-system` namespace and apply sample yaml which will mention `servicemeshcontrolplane.maistra.io/basic-install created`
3) indeed watch the pods coming up as you will hit an ErrImagePull problem for a while. After five minutes, all is well
4) when installing serverless 1.1.0 there's a mistake in the readme, you want:

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

## Testing

1) On an OpenShift 4.2 cluster with one master and three workers (my cluster died after installing two operators with just one worker)...
2) With one master and three workers, it died again after installing ServiceMesh, the Serverless 1.1.0 operator, eventing!

```
adams-mbp:serverless-operator aroberts$ oc login
error: EOF
```

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

- Todo get the Serverless 1.1.0 operator working
- Ran out of memory I think even with three worker nodes! 

```
An OpenShift cluster with 10 CPUs and 40 GB memory is the minimum requirement for getting started with your first serverless application. This usually means you must scale up one of the default MachineSets by two additional machines.
```

