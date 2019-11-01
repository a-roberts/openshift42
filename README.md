# openshift-42-operator-work

## Background

Notes for getting the Tekton Dashboard and Webhooks Extension available on OpenShift 4.2, ideally with all dependencies installed through operators that are readily available. Zoom to the bottom of this for issues.

## Critical

https://docs.openshift.com/container-platform/4.2/nodes/nodes/nodes-nodes-working.html#nodes-nodes-working-master-schedulable_nodes-nodes-working

Fyre's OpenShift ember makes the master nodes schedulable. After installing everything and waiting a while, your cluster will become completely unusable unless you make them not so following the above.

## Versions

- [x] **Tekton Pipelines** 0.7 via the Tekton operator (RedHat provided, community)
- [x] **ServiceMesh** 1.0.1 via the Service Mesh operator (RedHat provided)
- [x] **Knative Eventing** 0.8 via the Knative Eventing Operator (community)
- [x] **Knative Eventing-Contrib** 0.8 installed directly: 
`oc apply -f https://github.com/knative/eventing-contrib/releases/download/v0.8.0/github.yaml`
- [x] **Knative Serving** 0.8.1 installed by the Knative Serverless Operator 1.1.0

## Instructions

- Step 1: get a cluster running OpenShift 4.2: I've used IBM's Fyre service, choosing the OpenShift 4.2 ember - three master nodes, five workers, or you'll get EOF problems aka Kube API server deaths because master nodes are labelled as workers too
- Step 2: log in to your cluster console and head to the Operators view on the left
- Step 3: run `install-script.sh`

## A note on namespaces and the ServiceMesh

See https://access.redhat.com/documentation/en-us/openshift_container_platform/4.2/html/serverless/installing-openshift-serverless#installing-service-mesh-member-roll_installing-openshift-serverless.

Ensure any namespace that creates a ksvc is in that ServiceMeshMemberRoll. Should be made easier with Serverless 1.2.0.

## A note on PersistentVolumes

You'll need them! Set up dynamic provisioning, if you're an IBMer you're in luck:

```
git clone https://github.ibm.com/dacleyra/ocp-on-fyre
cd ocp-on-fyre
./nfs-storage-provisioner.sh
```
