#!/bin/bash

echo "Make sure your master nodes aren't schedulable, see https://docs.openshift.com/container-platform/4.2/nodes/nodes/nodes-nodes-working.html#nodes-nodes-working-master-schedulable_nodes-nodes-working"

echo "Now https://access.redhat.com/documentation/en-us/openshift_container_platform/4.2/html/serverless/installing-openshift-serverless"

echo "Install the ServiceMesh operator before you continue"

read -p "Press enter to continue - I've installed the ServiceMesh operator"

oc new-project istio-system
oc apply -f MaistraFile.yaml
sleep 5
oc apply -f MemberRoll.yaml

echo "Install the Tekton Pipelines operator AND an instance before you continue"

read -p "Press enter to continue - I've installed the Tekton Pipelines operator"

echo "Install the Knative Eventing 0.8 operator"

read -p "Press enter to continue - I've installed the Knative Eventing operator"

echo "Installing the Knative Eventing Contrib GitHubSource CRD"

oc apply -f https://github.com/knative/eventing-contrib/releases/download/v0.8.0/github.yaml

echo "Install the Serverless 1.1.0 operator"

read -p "Press enter to continue - I've installed the Serverless operator"

echo "Installing Knative Serving object"

oc apply -f Serving.yaml

echo "Installing Tekton Dashboard"

curl -L https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-tekton-dashboard.yaml \
  | sed 's/namespace: tekton-pipelines/namespace: kabanero/' \
  | sed 's/value: tekton-pipelines/value: kabanero/' \
  | oc apply --validate=false --filename -

curl -L https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-webhooks-extension.yaml \
  | sed 's/namespace: tekton-pipelines/namespace: kabanero/' \
  | sed 's/default: tekton-pipelines/default: kabanero/' \
  | oc apply --filename -

echo "Done!"

echo "Post install notes you should be aware of"

echo "member roll super important - ensure namespaces you want serverless stuff to be in, are mentioned in the roll"
echo "describe your virtualservices if your ksvc isn't ready"
echo "networking pod in istio-system for debugging"
echo "enjoy"
