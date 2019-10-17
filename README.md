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

