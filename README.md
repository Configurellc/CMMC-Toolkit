# CMMC Toolkit

**Free, open-source CMMC Level 2 / NIST SP 800-171 Rev 2 compliance tool for small defense contractors.**

Built for micro to small businesses in the Defense Industrial Base (DIB) who handle Controlled Unclassified Information (CUI) and need to achieve CMMC Level 2 certification — without paying $10,000+ for a consultant.

🔗 **[Live App](https://cmmc-toolkit.netlify.app)** *(coming soon)*

---

## What it does

### 📋 Organization Mode
Track implementation status across all 110 NIST SP 800-171 Rev 2 controls. Mark controls as complete, in-progress, or not started. Add evidence notes. Filter by domain, status, or search by keyword. Progress tracked per control family.

### 🔍 Auditor Mode (800-171A)
Expands to all 320 assessment objectives from NIST SP 800-171A — the exact criteria used by C3PAO assessors during a formal CMMC Level 2 audit. Dual-status tracking: your self-assessment vs. auditor findings.

### 📊 SPRS Score Calculator
Computes your DoD Supplier Performance Risk System (SPRS) score in real time using the official DoD Assessment Methodology v1.2.1 point weights. Shows a live score gauge, prioritized remediation table sorted by point value, and handles the two partial-credit controls (3.5.3 and 3.13.11). Score range: −203 to +110.

### 📄 Evidence Templates
Generates a pre-filled **System Security Plan (SSP)** and **Plan of Action & Milestones (POA&M)** directly from your checklist data — the two mandatory documents required before any C3PAO assessment. Exportable via print-to-PDF.

### 📜 Policy Documents
Full draft language for all **14 required NIST SP 800-171 policy documents**, one per control family. Each policy includes purpose, scope, requirements, roles & responsibilities, review cycle, and an approval signature block. Print the complete policy package in one click.

### 🧭 Gap Wizard
Step-through guided review of every incomplete control, highest SPRS impact first. Each card explains the control in plain English, describes what "implemented" looks like for a small business, and lists concrete first steps with real tool recommendations.

---

## Tech stack

- **Single-file HTML** — vanilla JavaScript, no build step, no dependencies
- **localStorage** — all data persists in the browser
- **Docker + nginx:alpine** — for local hosting
- **Netlify** — static site hosting, deploys on push to `main`
- **Supabase** *(optional)* — PostgreSQL backend for multi-user shared state

---

## Running locally

### Option 1: Open directly in a browser
Just open `nist-800171-checklist.html` in any modern browser. No server required.

### Option 2: Docker
```bash
docker compose up --build
```
Then visit `http://localhost:8080`

---

## Deploying to Netlify

1. Fork this repo
2. Connect to Netlify via **Import from Git**
3. Build command: *(leave blank)*
4. Publish directory: `/`
5. Deploy

Every push to `main` triggers an automatic redeploy.

---

## Roadmap

- [ ] Remediation recommendations (per-control tool/vendor suggestions)
- [ ] SPRS score history (track score trajectory over time)
- [ ] Multi-user support via Supabase (real-time shared state)
- [ ] Export SSP/POA&M to Word (.docx)
- [ ] CUI data flow / asset scoping wizard

---

## Contributing

Pull requests welcome. This tool exists to make CMMC compliance accessible to small businesses that can't afford consultant fees. If you work in the DIB or cybersecurity space and want to improve it, open an issue or submit a PR.

---

## License

MIT — free to use, modify, and distribute.

---

## Disclaimer

This tool is provided for informational and self-assessment purposes only. It does not constitute legal or compliance advice. CMMC certification requires assessment by an authorized C3PAO. Always verify requirements against official NIST and DoD sources.
