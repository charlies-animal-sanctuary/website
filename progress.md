# progress.md — build state

Rules live in [CLAUDE.md](CLAUDE.md); this file is only status, decisions, and open
questions. Update at every phase gate and every real decision — a stale log is worse
than none. **Last updated: 2026-07-04.**

## Where we are

- **Current phase:** 2 — Static pages — **built, at the phase gate.**
- **Done (phase 2):** Home rebuilt as the real §3 structure (hero still slot + CTAs,
  featured section with sample cards at the agreed 4:5, "Watch our story" video slot,
  Instagram strip with 6 sample tiles + real follow link, donate band); About; Intake
  with the full surrender form; Contact with form + location + real social links. Both
  forms have honeypots, required-field marking, and the §10 privacy note; they post to
  a placeholder endpoint and say so on-page until phase 4. All copy is [DRAFT]-marked
  and chip-labelled per §9; all four pages verified at desktop + mobile widths.
- **Done (phase 1):** Astro 7 static scaffold, tokens + WCAG gate, fonts, layout,
  logo/favicon assets, git repo. Gate passed by owner 2026-07-04.
- **Next:** owner (and the sanctuary owner — his girlfriend) review the formed pages →
  Phase 3 (Content + CMS: collections, AnimalCard, Adopt/Happy Tails, detail pages,
  Our Family, 404).
- **Blocked / awaiting owner:** phase 2 gate review. Needed for phase 3: the Our Family
  roster (which pets, correct names/species). Broader content feedback + real images
  expected later from the sanctuary owner — everything placeholder is swappable via
  `src/config/site.ts` and the tracker below.

## Phase log (brief §8)

| # | Phase | Scope | Status |
|---|---|---|---|
| 1 | Scaffold | Astro project; base layout/nav/footer; tokens; fonts; global styles; logo variants + favicon; git init + .gitignore | **done 2026-07-04 — at gate** |
| 2 | Static pages | Home (hero still, featured, story video slot, IG strip slot, donate band), About, Intake + surrender form, Contact + form | **done 2026-07-04 — at gate** |
| 3 | Content + CMS | content schema; Sveltia `config.yml`; `AnimalCard` (§5 logic); Adopt (Available + Happy Tails); detail pages; Our Family; empty states + 404; fake seed animals | not started |
| 4 | Integrations | Behold gallery; YouTube embeds; form service + apply prefill; donate URL; form privacy note | not started |
| 5 | Auth + deploy | **NEEDS REMOTE** — Cloudflare Pages, Sveltia auth worker, domain, analytics, owner end-to-end publish test | not started |
| 6 | Polish | motion (reduced-motion safe); image sizing/lazyload; WCAG AA audit; Lighthouse; a11y pass; SEO/OG incl. per-animal share images | not started |

Each phase ends at a gate: owner reviews before the next phase starts.

## Decision log

- **2026-07-04 — Docs before code.** Owner directed steps 1–4 only (read, docs, confirm,
  suggest); scaffolding awaits explicit go-ahead. Why: owner directs and reviews; feeling
  our way through v1 deliberately.
- **2026-07-04 — Brief referenced in place** at `Initial Files/BUILD_BRIEF - Animal
  Sanctuary.md` instead of moving it to root. Why: it's the single source of truth;
  moving/duplicating it risks divergence. Can relocate later if owner prefers.
- **2026-07-04 — No logo recolor step.** Both variants already provided
  (`charlie-logo-white.png`, `charlie-logo-ebony.png`); §6e's recolor task is already
  satisfied. Only favicon derivation remains (proposal: paw-print element at small sizes —
  the full circular mark will be illegible at 16–32px).
- **2026-07-04 — Proposed technical deviations (awaiting owner sign-off, see Open
  Questions #6):**
  - (a) Pure static output, no Cloudflare adapter. Why: the adapter is only needed for
    SSR; this site is pure SSG and deploys to Pages as static files — one less
    dependency (§12: minimal deps).
  - (b) Current Astro v5 content-collection API instead of the v4-style code in §4d.
    Why: §4d's syntax is a major version stale; fields stay identical, only plumbing
    differs, and Sveltia-schema parity is preserved.
  - (c) CMS-uploaded images stored where Astro's image pipeline can optimize them,
    rather than `public/images/animals`. Why: `public/` ships files verbatim, so an
    8 MB phone upload ships at 8 MB; build-time optimization protects "fast" (§1).
  - (d) Fonts self-hosted via Fontsource rather than Google Fonts CDN. Why: faster, no
    third-party request, keeps the cookieless / no-consent-banner story (§10) airtight.

  Outcomes will be logged here once the owner decides.
- **2026-07-04 — Owner accepted ALL recommendations** ("go ahead, all recommendations
  accepted"), resolving every open question: (1) Happy Tails = teaser row on Adopt +
  dedicated paginated `/happy-tails` page; (2) cards are 4:5; (3) Web3Forms in phase 4;
  (4) Our Family seeds with the owner's real pets + clearly-draft stories (roster/names
  still to confirm before phase 3); (5) favicon = paw element of the mark; (6) all four
  technical deviations approved; (7) `Initial Files/` untracked. One nuance on (7): the
  gitignore uses `Initial Files/*` with an exception so the BUILD_BRIEF stays tracked —
  the source of truth must survive a clone; only photos/colors stay out.
- **2026-07-04 — Astro 7.0.6, not 5.x.** Fresh install of `astro@^5` carried a
  high-severity advisory set (multiple XSS; esbuild dev-server arbitrary file read on
  Windows — our dev OS). 7.0.6 is current stable with 0 vulnerabilities; the scaffold
  built on it unchanged. Why: never lock a known-vulnerable major into the first commit.
  Supersedes the "Astro v5 API" wording of deviation (b) — same intent, current major.
- **2026-07-04 — Text links on light backgrounds are Coffee Bean, never Dusty Olive.**
  Measured: olive text on cream = 4.22:1, below AA 4.5 (the brief's "links" role for
  olive only works as white-on-olive fills). Enforced by the contrast gate; also noted
  in CLAUDE.md and tokens.css. Why it matters: this is exactly the tested-number-over-
  judgment-call discipline §6a demands.
- **2026-07-04 — Measured contrast baselines** (gate output, all PASS): ebony/cream
  7.37:1 (AAA), cream/ebony 7.37:1 (AAA), white/coffee 6.44:1, white/olive 5.47:1,
  coffee-links/cream 4.97:1. The brief's ≈9:1 and ≈7:1 estimates were optimistic but
  nothing dips below AA. Camel/cream = 2.52:1 — confirmed decorative-only.
- **2026-07-04 — Asset pipeline:** `scripts/generate-assets.ps1` (Windows/GDI+) derives
  trimmed logo variants (`src/assets/logo/`) and the paw favicon tiles (`public/`) from
  the white master PNG via ColorMatrix recolor (clean alpha). Outputs are committed;
  the script only reruns if the master logo changes.

- **2026-07-04 — Real Instagram URL received from owner and wired** into `site.ts`
  (footer, contact page, home follow button): 
  https://www.instagram.com/charliesanimalsanctuary/ — first placeholder retired.
- **2026-07-04 — Phase 2 copy strategy:** every static-copy block is short draft prose
  prefixed `[DRAFT]` plus a section chip, and pages state what final content is needed
  (e.g. "the real story comes from the owner, in her own words"). Why: §9 forbids copy
  that could quietly become final; this shape gives the sanctuary owner something
  concrete to react to AND a checklist of what to write.

## Open questions (awaiting owner)

None currently open. Still due later: **Our Family roster** — which pets and correct
names/species (needed at phase 3; will use `Initial Files/Temporary Photos/`).

## Placeholder tracker (§9)

Every placeholder asset and copy block gets a line here when created, and is checked
off when the final replaces it. All copy lives in `src/config/site.ts` → `copy`.
Format: `- [ ] <where> — <what's fake> — <what the final needs to be>`

- [x] `site.ts` → `social.instagram` — ~~placeholder~~ — **real URL wired 2026-07-04:**
  https://www.instagram.com/charliesanimalsanctuary/
- [ ] `site.ts` → `description` — draft meta description — final wording from owner
- [ ] `site.ts` → `donateUrl` — `#placeholder-donate-url` — real PayPal link (§11)
- [ ] `site.ts` → `formEndpoint` — `#placeholder-form-endpoint` — Web3Forms endpoint
  (phase 4); both forms show a "not wired yet" chip until then
- [ ] `site.ts` → `youtubeStoryVideoId` — empty — featured video ID (§11); home shows
  a placeholder panel; embed wired in phase 4
- [ ] `site.ts` → `copy.home` — hero headline/sub + donate-band copy, all [DRAFT]
- [ ] `site.ts` → `copy.about` — intro + 3 story paragraphs, all [DRAFT] — her story,
  in her words
- [ ] `site.ts` → `copy.intake` — intro + 3 steps, all [DRAFT]
- [ ] `site.ts` → `copy.contact` — intro, [DRAFT]
- [ ] Home hero media — striped `PlaceholderBlock` — owner's chosen still (4:3-ish)
- [ ] Home featured section — 2 hardcoded sample cards — real `featured: true`
  adoptables via CMS in phase 3
- [ ] Home Instagram strip — 6 striped sample tiles — live Behold feed in phase 4
- [ ] About page media — striped `PlaceholderBlock` — a photo of the sanctuary/owner

## Config values (brief §11) — all currently unfilled

| Key | Value | Needed by |
|---|---|---|
| `OWNER/REPO` | — | phase 5 (config.yml placeholder until then) |
| `AUTH_WORKER_URL` | — | phase 5 |
| `BEHOLD_FEED_URL` | — | phase 4 |
| `YOUTUBE` featured video ID | — | phase 2 slot, phase 4 wiring |
| `DONATE_URL` | — | phase 2 (placeholder link until real) |
| `FORM_SERVICE_ENDPOINT` / `OWNER_EMAIL` | — | phase 4 |
| `DOMAIN` | — | phase 5; also OG absolute URLs in phase 6 |
| `ANALYTICS_TOKEN` | — | phase 5 (recommend on) |
| `TURNSTILE_SITE_KEY` / `TURNSTILE_SECRET` | — | only if honeypot proves insufficient |
