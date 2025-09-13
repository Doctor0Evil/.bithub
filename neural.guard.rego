package neural.guard

default allow = false

is_neural_class(x) {
  x.classification == "direct-bci-telemetry"
} or {
  x.classification == "neural-intent-rf"
}

is_inferred(x) {
  x.classification == "inferred-neural"
}

violation["NS-000 block BCI/neuromorphic"] {
  is_neural_class(input)
}

violation["NS-020 sandbox egress requires re-attestation"] {
  input.path == "sandbox->prod"
  not input.attestation.fresh
}

# Only permit via safe broker
allow {
  is_inferred(input)
  input.path == "external->safe-broker->analysis"
  input.provenance.signature.valid
  input.transforms == {"format-normalize","PII-redact","high-risk-field-mask"}
}
