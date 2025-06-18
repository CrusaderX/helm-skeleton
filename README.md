![tests](https://github.com/CrusaderX/helm-skeleton/actions/workflows/ci.yaml/badge.svg?event=push)
![unittests](https://github.com/CrusaderX/helm-skeleton/actions/workflows/unittest.yaml/badge.svg?event=push)

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

Every push or pull-request triggers a full test battery to keep our charts safe and sane:

| Check                            | What it does                                                                                                                             | Where to extend it |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------ |
| **YAML & CRD schema validation** | Renders the chart, then lints each manifest to make sure it’s valid Kubernetes and matches the cluster’s CRDs and admission policies.    | —                  |
| **Custom validators**            | The shell function `run_validators` in `tests/src.sh` is executed automatically. Drop any extra checks you need in there.                | `tests/src.sh`     |
| **Helm-unittest**                | Runs declarative tests that verify we set/override values correctly and that key fields (labels, probes, PVCs, etc.) render as expected. | `tests/*.yaml`     |

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)
