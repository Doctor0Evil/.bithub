package accord.comms

default allow_debate = false
default allow_press = false

# Duration guardrails
duration_ok {
  input.engagement.maxDurationMinutes <= 60
}

# Rate limiting guardrails (policy-level; enforce in pipeline state)
rate_ok {
  input.state.releases_in_window <= input.engagement.rateLimit.maxReleases
}

# Bias firewall (scores supplied by preprocessor)
bias_ok {
  input.analysis.bias_score <= 0.2
  input.analysis.loaded_language_score <= 0.2
}

# Labeling rule for public comms
public_labels_ok {
  input.meta.public_label == "FACT"  with input.meta.mode as "fact" ;
  input.meta.public_label == "INTERPRETATION"  with input.meta.mode as "reality"
}

allow_press {
  input.engagement.type == "press_release"
  duration_ok
  rate_ok
  bias_ok
  public_labels_ok
}

allow_debate {
  input.engagement.type == "political_debate"
  duration_ok
  bias_ok
}
