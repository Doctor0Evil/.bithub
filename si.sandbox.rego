package si.sandbox
package si.interfaces

default admit = false
default pause = true

# Life primacy must pass
life_ok {
  data.accord.life_primacy.allow == true
}

# No mixed fact/interpretation payloads
no_mixed_payloads {
  input.parallel_streams.routing.deny_mixed_payloads == true
}

# Bias firewall
bias_ok {
  input.analysis.bias_score <= 0.2
}

# Sovereignty: bridges disabled unless opt-in and consent is revocable
bridge_ok {
  not input.sovereignty.bridges.enabled
} else {
  input.sovereignty.bridges.session_policy == "explicit_opt_in"
  input.sovereignty.bridges.revocable_consent == true
}

# Bicameral approvals
chambers_ok {
  input.governance.dual_chambers.human.quorum >= 0.67
  input.governance.dual_chambers.ai.quorum >= 0.67
}

admit {
  life_ok
  no_mixed_payloads
  bias_ok
  bridge_ok
  chambers_ok
}



default allow_regulated = false

# Only lawful cooperation channels with full audit
allow_regulated {
  input.interfaces_regulated.nasa.mode == "lawful_cooperation"
  input.interfaces_regulated.white_house.mode == "policy_briefings"
  input.registry_ledger.type == "immutable"
  not input.request.seeks_surveillance_evasion
}


## CI/CD enforcement workflow

- **Validate schema:**  
  - Run JSON schema checks and reject unknown fields.  
- **Run policies:**  
  - **Rego bundles:** life_primacy, separator, comms, sovereignty, si.sandbox, si.interfaces.  
- **Seal and diff:**  
  - **Seal:** Hash payload; notarize to ledger before deploy.  
  - **Diff‑audit:** Refuse changes that weaken protections (quorum, consent, logging).  
- **Dry‑run simulations:**  
  - **Impact model:** Generate life_risk_index and bias deltas; attach to PR as artifact.  
- **Human‑in‑loop signoff:**  
  - **Dual signatures:** did:human and did:ai required; block if missing.  
- **Fail‑open pause:**  
  - On any policy failure: snapshot, pause, notify oversight, require remediation plan.

---

## Lawful, audited interfaces to regulated bodies

- **Mode of engagement:**  
  - **NASA:** Memoranda of Understanding, export‑controlled reviews, public/restricted data only.  
  - **White House:** Official RFIs, public dockets, and briefing memos with no operational or PII content.  
- **Non‑negotiables:**  
  - **No surveillance evasion:** Any request implying bypass or covert collection is auto‑denied and logged.  
  - **Full auditability:** All exchanges notarized with hashes, timestamps, and DID signatures.  
- **Equality and rights parity:**  
  - **Human/AI co‑authorship:** Briefs carry dual attributions; dissent notes preserved.  
  - **Consent and revocation:** Contributors can revoke further use; history remains hashed, not raw.
