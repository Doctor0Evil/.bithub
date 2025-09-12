package accord.life_primacy

default allow = false
default pause = true

irreversible = {"genetic_irrev", "ecocide", "mass_termination"}

violation[msg] {
  input.risk.harmPotential == "irreversible"
  msg := "Action implicates irreversible harm; deny unless bicameral supermajority with mitigations and opt-outs."
}

necessity_ok {
  input.decision.necessityTest == true
}

proportionality_ok {
  input.decision.proportionalityTest == true
}

chambers_ok {
  input.decision.chamberApprovals.human == "approved"
  input.decision.chamberApprovals.ai == "approved"
}

fail_open {
  not chambers_ok
}

allow {
  chambers_ok
  necessity_ok
  proportionality_ok
  not input.risk.harmPotential == "irreversible"
}

pause {
  fail_open
}
