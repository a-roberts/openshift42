#!/bin/bash

echo "Make sure your master nodes aren't schedulable, see https://docs.openshift.com/container-platform/4.2/nodes/nodes/nodes-nodes-working.html#nodes-nodes-working-master-schedulable_nodes-nodes-working"

echo "Now https://access.redhat.com/documentation/en-us/openshift_container_platform/4.2/html/serverless/installing-openshift-serverless"

echo "Install the ServiceMesh operator before you continue"

read -p "Press enter to continue - I've installed the ServiceMesh operator"

oc apply -f MaistraFile.yaml

echo "Install the Tekton Pipelines operator before you continue"

read -p "Press enter to continue - I've installed the Tekton Pipelines operator"

echo "Install the Knative Eventing 0.8 operator"

read -p "Press enter to continue - I've installed the Knative Eventing operator"

echo "Installing the Knative Eventing Contrib GitHubSource CRD"

oc apply -f https://github.com/knative/eventing-contrib/releases/download/v0.8.0/github.yaml

echo "Installing the Serverless Operator 1.1.0 from GitHub: https://github.com/openshift-knative/serverless-operator"

rm -rf ./serverless-operator
git clone https://github.com/openshift-knative/serverless-operator.git
cd serverless-operator
./hack/catalog.sh | kubectl apply -n openshift-marketplace -f -

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

echo "Installing Tekton Dashboard - todo through an operator?"

oc apply -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-tekton-dashboard.yaml --validate=false

oc apply -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-webhooks-extension.yaml

echo "Done!"
