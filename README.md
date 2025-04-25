![tests](https://github.com/CrusaderX/helm-skeleton/actions/workflows/ci.yaml/badge.svg?event=push)

# Helm chart library (skeleton)

A reusable "library" chart that provides:

- A flexible `merge` helper for combining chart‐wide defaults and per‐object overrides
- A tiny, reusable `field` helper to conditionally render a Kubernetes resource field only when a value is present, picking either a chart-default or a user-override, and formatting it correctly based on its type

A ready-to-go templates:

* deployment
* statefulset
* cronjob
* daemonset
* horizontalpodautoscaler
* scaledjob
* scaledobject
* secret
* service
* serviceaccount
* servicemonitor

Adding library locally:

```yaml
dependencies:
  - name: default
    version: 0.1.0
    repository: file://path/to/library
```

# What's new

Please refer to the [release page](https://github.com/CrusaderX/helm-skeleton/releases/latest) for the latest release notes.

# Usage

See `examples` folder.

# Tests

We include a suite of automated validation checks to ensure your rendered Kubernetes YAML is syntactically correct and conforms to your cluster's CRDs and policies. You can easily add any validators you need via `run_validators` function in `tests/src.sh` file.


# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)
