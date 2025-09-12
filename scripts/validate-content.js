// scripts/validate-content.js
const fs = require('fs');
const payload = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));

// Simple label check for outgoing text blocks
payload.meta = payload.meta || {};
payload.meta.outgoing_text_has_labels = /

\[FACT\]

|

\[INTERPRETATION\]

/.test(payload.draftText || "");

console.log(JSON.stringify(payload));
