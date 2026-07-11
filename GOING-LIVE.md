# Going live — the one-time setup (~20 minutes)

This connects the website to the internet. It's click-by-click, nothing can be
broken permanently, and it only ever needs to be done **once**. After this, the
only place you'll ever go is the site's `/admin` page.

Two rules before starting:

- **Never paste secret codes anywhere public** (not in messages, not in posts).
  They only go into the exact fields named below.
- If a screen doesn't match these steps exactly, don't guess — screenshot it and
  send it to Faraaz.

---

## Part A — Put the site on the internet (~7 min)

You'll connect Cloudflare (which hosts the site) to GitHub (where the site's
files live).

1. Go to **dash.cloudflare.com** and log in to your Cloudflare account.
2. In the left sidebar, click **Workers & Pages**.
3. Click **Create** (or "Create application"), then switch to the **Pages** tab.
4. Click **Connect to Git** (may say "Import an existing Git repository").
5. It will ask you to sign in to GitHub and authorize Cloudflare. Approve it.
   When GitHub asks **where** to install: pick the **charlies-animal-sanctuary**
   organization (not your personal account), choose **Only select
   repositories**, and select **website**.
6. Back in Cloudflare, select the **website** repository and click
   **Begin setup**.
7. Fill in the setup screen:
   - **Project name:** `charlies-animal-sanctuary`
     (this becomes your free web address: `charlies-animal-sanctuary.pages.dev`)
   - **Production branch:** `main`
   - **Framework preset:** choose **Astro** if offered.
   - **Build command:** make sure it says exactly `npm run build`
     (fix it by hand if the preset filled in anything else — this matters).
   - **Build output directory:** `dist`
8. Still on that screen, expand **Environment variables** and add TWO:
   - Name: `PUBLIC_WEB3FORMS_KEY`
     Value: the long dashed code from your Web3Forms email
     (the one titled something like "Your Access Key").
   - Name: `NODE_VERSION` — Value: `22`
9. Click **Save and Deploy**. A build log will scroll by for a minute or two
   and end with a green success message.
10. **The site is now live.** Click the link it shows
    (`https://charlies-animal-sanctuary.pages.dev`) and have a look around —
    then send that link to Faraaz.

From now on, every change published from `/admin` goes live automatically in
about two minutes. No one ever repeats these steps.

---

## Part B — Turn on the admin login (~10 min)

This lets you log into the site's `/admin` page with your GitHub account.
Three short pieces, in this order.

### B1. Deploy the login helper (a tiny free Cloudflare service)

1. Open this page: **github.com/sveltia/sveltia-cms-auth**
2. In the description there's a **"Deploy to Cloudflare Workers"** button.
   Click it.
3. Follow the prompts (it will connect to your GitHub and your Cloudflare —
   approve both) and finish the deploy.
4. When it's done, Cloudflare shows your new worker with a web address like
   `https://sveltia-cms-auth.SOMETHING.workers.dev`.
   **Copy that address into a note** — you need it twice below.

### B2. Register the login with GitHub

1. On GitHub, click your profile photo (top right) → **Your organizations** →
   **charlies-animal-sanctuary** → **Settings**.
2. In the left sidebar, scroll to the bottom: **Developer settings** →
   **OAuth Apps** → **New OAuth App**.
3. Fill in:
   - **Application name:** `Charlie's Sanctuary admin login`
   - **Homepage URL:** `https://charlies-animal-sanctuary.pages.dev`
   - **Authorization callback URL:** the worker address from B1 with
     `/callback` on the end, e.g.
     `https://sveltia-cms-auth.SOMETHING.workers.dev/callback`
4. Click **Register application**.
5. On the next page:
   - Copy the **Client ID** into your note.
   - Click **Generate a new client secret** and copy it into your note
     immediately (GitHub only shows it once).

### B3. Give the login helper its two codes

1. Back at **dash.cloudflare.com** → **Workers & Pages** → click the
   **sveltia-cms-auth** worker → **Settings** → **Variables** (may be under
   "Variables and Secrets").
2. Add two variables:
   - Name: `GITHUB_CLIENT_ID` — Value: the Client ID from B2.
   - Name: `GITHUB_CLIENT_SECRET` — Value: the client secret from B2.
     Click **Encrypt** on this one if the button is offered.
3. Save (and confirm the deploy if it asks).

### B4. Send Faraaz two things

- The worker address from B1
- Confirmation that Parts A and B are done

He'll flip one switch in the site's code, and then…

---

## Part C — The victory lap (after Faraaz says go)

1. Go to `https://charlies-animal-sanctuary.pages.dev/admin`
2. Click **Sign in with GitHub** and approve it (first time only).
3. You're in your admin. Try the full loop:
   - **Adoptable animals** → **Add** → make a test animal (name it "Test",
     any photo) → **Publish**.
   - Wait ~2 minutes, refresh the live site — Test is on the Adopt page.
   - Change Test's **Status** to "Adopted" → Publish → refresh: Test moved
     to Happy Tails.
   - Delete Test (this is the ONE time deleting is correct — real adopted
     animals stay in Happy Tails forever).
4. That loop — add an animal, flip a status — is the whole job, forever.

Still to pick whenever you're ready (quick, no rush): which of your domains
the site should live at, and whether to turn on Cloudflare's free, cookieless
visitor analytics.
