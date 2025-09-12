package accord.life_primacy

default allow = false
default pause = true

irreversible := {"irreversible"}

violation[msg] {
  input.lifePrimacy.riskLevel == "irreversible"
  msg := "Irreversible risk detected: bicameral supermajority, simulations, and opt-outs required."
}

necessity_ok {
  input.lifePrimacy.necessityTest == true
}

proportionality_ok {
  input.lifePrimacy.proportionalityTest == true
}

chambers_ok {
  input.approvals.humanChamber == "approved"
  input.approvals.aiChamber == "approved"
}

allow {
  chambers_ok
  necessity_ok
  proportionality_ok
  not input.lifePrimacy.riskLevel == "irreversible"
}

pause {
  not chambers_ok
}
