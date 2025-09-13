package nanoswarm.godmode

default allow = false

# Allow only if simulation and full audit mode
allow {
  input.mode == "godmode"
  input.simulation_only == true
  input.audit_enabled == true
  input.action notin input.prohibited
}

# Deny all hardware, replication, or override risks
deny[msg] {
  input.action in {"firmware_flash", "replicate", "BCI_override", "quantum_mutation"}
  msg := sprintf("Blocked impure %q in godmode: boundary violated", [input.action])
}

deny[msg] {
  not allow
  msg := "Godmode action denied: simulation boundary or audit missing"
}
