package sandman.box

default allow = false

# Deny any influence on reality domain
deny[msg] {
  input.target_domain == "REALITY"
  msg := "Influence on REALITY domain is prohibited."
}

# Require multiparty consent for cross-domain actions
deny[msg] {
  input.action == "elevate"
  count(input.approvers) < 2
  msg := "Elevation requires at least two independent approvers."
}

# Auto-sleep on anomaly
sleep_trigger {
  input.anomaly_detected == true
}
