package accord.sovereignty

default bridge_ok = true

# No shared mutable state; only audited message passing
bridge_ok {
  input.sovereignty.bridgeSession == "none"
}

bridge_ok {
  input.sovereignty.bridgeSession != "none"
  input.sovereignty.revocableConsent == true
  input.bridge.audit_log_present == true
  input.bridge.pre_conditions_ok == true
  input.bridge.post_conditions_ok == true
}

deny_bridge[msg] {
  input.sovereignty.bridgeSession != "none"
  not bridge_ok
  msg := "Bridge session blocked: consent/audit/conditions not satisfied."
}
