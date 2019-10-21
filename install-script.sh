#!/bin/bash

echo "Make sure your master nodes aren't schedulable, see https://docs.openshift.com/container-platform/4.2/nodes/nodes/nodes-nodes-working.html#nodes-nodes-working-master-schedulable_nodes-nodes-working"

echo "Now https://access.redhat.com/documentation/en-us/openshift_container_platform/4.2/html/serverless/installing-openshift-serverless"

echo "Install the ServiceMesh operator before you continue"

read -p "Press enter to continue - I've installed the ServiceMesh operator"

oc new-project istio-system
oc apply -f MaistraFile.yaml
sleep 5
oc apply -f MemberRole.yaml

echo "Install the Tekton Pipelines operator AND an instance before you continue"

read -p "Press enter to continue - I've installed the Tekton Pipelines operator AND an instance of Tekton Pipelines"

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

sleep 5

echo "Installing Knative Serving object"

cd ../

oc apply -f Serving.yaml

echo "Installing Tekton Dashboard"

curl -L https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-tekton-dashboard.yaml \
  | sed 's/namespace: tekton-pipelines/namespace: openshift-pipelines/' \
  | sed 's/value: tekton-pipelines/value: openshift-pipelines/' \
  | oc apply --validate=false --filename -

curl -L https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-webhooks-extension.yaml \
  | sed 's/namespace: tekton-pipelines/namespace: openshift-pipelines/' \
  | sed 's/default: tekton-pipelines/default: openshift-pipelines/' \
  | oc apply --filename -

echo "Done!"

echo "Post install notes you should be aware of"

echo "webhooks-route not needed (mentioned in our instructions so far for webhooks extension)"
echo "configmap already set (mentioned in our instructions so far for webhooks extension)"
echo "no need for those oc router commands (mentioned in our instructions so far for webhooks extension)"
echo "member roll super important - ensure namespaces you want serverless stuff to be in, are mentioned in the roll"
echo "describe your virtualservices if your ksvc isn't ready"
echo "networking pod in istio-system for debugging"
echo "enjoy"
