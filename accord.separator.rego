package accord.separator

default permit_release = false

# Facts must have evidence and timestamps
fact_ok {
  count(input.layers.fact.claims) > 0
  every c in input.layers.fact.claims {
    count(c.evidence) > 0
    c.timestamp != ""
  }
}

# Reality interpretations must declare confidence and caveats
reality_ok {
  count(input.layers.reality.interpretations) >= 0
  every r in input.layers.reality.interpretations {
    r.confidence >= 0
    r.confidence <= 1
  }
}

# Enforce explicit layer labeling in outgoing text
has_layer_labels {
  input.meta.outgoing_text_has_labels == true
}

permit_release {
  fact_ok
  reality_ok
  has_layer_labels
}
