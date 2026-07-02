# Supabase Pilot Setup Instructions
## CMMC Compliance Tracker — Invite-Only Auth Gate

Complete these steps in order. All steps happen inside your Supabase project dashboard at supabase.com.

---

## Step 1 — Enable Magic Link Auth

1. Go to **supabase.com** and open your project
2. In the left sidebar, click **Authentication**
3. Click **Providers** (under Configuration)
4. Find **Email** in the provider list and click it
5. Make sure **Enable Email Provider** is ON
6. Make sure **Confirm email** is ON (this is what sends the magic link)
7. Turn OFF **Enable email confirmations** if it asks about a separate confirmation flow — you want magic links only
8. Click **Save**

---

## Step 2 — Set Your Site URL

1. Still in **Authentication**, click **URL Configuration**
2. Set **Site URL** to: `https://cmmctool.netlify.app`
3. Under **Redirect URLs**, add: `https://cmmctool.netlify.app`
4. Click **Save**

---

## Step 3 — Run the Database SQL

1. In the left sidebar, click **SQL Editor**
2. Click **New query**
3. Paste the entire block below and click **Run**

```sql
-- ── Pilot allowlist ──────────────────────────────────────
-- You add rows here manually to invite users
CREATE TABLE IF NOT EXISTS pilot_allowlist (
  email       TEXT PRIMARY KEY,
  invited_at  TIMESTAMPTZ DEFAULT NOW(),
  notes       TEXT
);
ALTER TABLE pilot_allowlist ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can check allowlist"
  ON pilot_allowlist FOR SELECT USING (true);

-- ── Waitlist ──────────────────────────────────────────────
-- Anyone can sign up; only you can read the list
CREATE TABLE IF NOT EXISTS waitlist (
  email         TEXT PRIMARY KEY,
  signed_up_at  TIMESTAMPTZ DEFAULT NOW(),
  source        TEXT DEFAULT 'auth-gate'
);
ALTER TABLE waitlist ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can join waitlist"
  ON waitlist FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update their waitlist row"
  ON waitlist FOR UPDATE USING (true);

-- ── Checklist status (user-scoped) ───────────────────────
DROP TABLE IF EXISTS checklist_status;
CREATE TABLE checklist_status (
  control_id  TEXT NOT NULL,
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status      TEXT NOT NULL DEFAULT 'not-started',
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (control_id, user_id)
);
ALTER TABLE checklist_status ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_status REPLICA IDENTITY FULL;
CREATE POLICY "Users manage own data" ON checklist_status
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── Assessment objectives (user-scoped) ──────────────────
DROP TABLE IF EXISTS assessment_objectives;
CREATE TABLE assessment_objectives (
  objective_id TEXT NOT NULL,
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status       TEXT NOT NULL DEFAULT 'not-reviewed',
  updated_at   TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (objective_id, user_id)
);
ALTER TABLE assessment_objectives ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_objectives REPLICA IDENTITY FULL;
CREATE POLICY "Users manage own data" ON assessment_objectives
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

4. You should see **Success. No rows returned** — that means it worked.

---

## Step 4 — Add Yourself as the First Pilot User

1. Still in **SQL Editor**, click **New query**
2. Paste and run — replace the email with yours:

```sql
INSERT INTO pilot_allowlist (email, notes)
VALUES ('your@email.com', 'Admin / founder');
```

---

## Step 5 — Invite Additional Pilot Users

Each time you want to invite someone, run this in the SQL Editor:

```sql
INSERT INTO pilot_allowlist (email, notes)
VALUES ('pilot@theircompany.com', 'Company name or notes here');
```

To see who is currently on the list:
```sql
SELECT * FROM pilot_allowlist ORDER BY invited_at DESC;
```

To remove someone:
```sql
DELETE FROM pilot_allowlist WHERE email = 'someone@company.com';
```

---

## Step 6 — Verify It Works

1. Go to **https://cmmctool.netlify.app**
2. You should see the auth gate (dark background, email input)
3. Enter your email (the one you added in Step 4)
4. Click **Get Access →**
5. Check your inbox for a magic link email from Supabase
6. Click the link — you should land back on the tool, now logged in
7. The sign-out button appears in the top-right corner

---

## Troubleshooting

**"Not on the pilot list" for an email you just added** — double-check for typos in the email. The check is case-sensitive in the input, but the app lowercases it before checking.

**No magic link email arrives** — check your spam folder. If still missing, go to Supabase → Authentication → Logs to see if the email was attempted.

**Magic link redirects to localhost** — your Site URL in Step 2 is wrong. Fix it to `https://cmmctool.netlify.app` exactly (no trailing slash).

**Tool loads but data doesn't save** — the RLS policies may not have applied. Re-run the SQL from Step 3.
