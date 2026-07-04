# progress.md — build state

Rules live in [CLAUDE.md](CLAUDE.md); this file is only status, decisions, and open
questions. Update at every phase gate and every real decision — a stale log is worse
than none. **Last updated: 2026-07-04.**

## Where we are

- **Current phase:** 3 — Content + CMS — **built, at the phase gate.**
- **Done (phase 3):** content collections (`src/content.config.ts`, Astro content-layer
  API, `image()`-optimized photos); Sveltia admin at `/admin` (config.yml in §4c sync,
  backend placeholders until phase 5); `AnimalCard` with the full §5 status mechanic
  (verified: Available = apply + feed buttons; Pending = pill, no apply; Adopted =
  dimmed + banner + "Found their home {Month Year}"); Adopt page (Available grid +
  dark Happy Tails band + teaser of latest 3 + count link); paginated `/happy-tails`
  (24/page); detail pages `/adopt/{slug}` + `/family/{slug}` with galleries; Our Family
  (Ash + Midna, real photos, draft stories); `/apply` with working `?pet=` prefill
  (verified); §5 empty states; custom 404 (verified). Seeds: 3 obviously-fake sample
  animals covering all three statuses. Home featured section now CMS-driven with the
  §5 fallback chain. Header got a wordmark (logo lettering illegible at 64px).
- **Done (phases 1–2):** scaffold + static pages; gates passed by owner 2026-07-04.
- **Next:** owner reviews → Phase 4 (Integrations: Behold, YouTube embed, Web3Forms
  wiring, donate URL). Phase 5 needs the GitHub push decision.
- **Blocked / awaiting owner:** phase 3 gate review. Later: her content feedback +
  real images; remaining Our Family pets (only Ash + Midna for now, per owner
  2026-07-04); config values (§11 table below).

## Phase log (brief §8)

| # | Phase | Scope | Status |
|---|---|---|---|
| 1 | Scaffold | Astro project; base layout/nav/footer; tokens; fonts; global styles; logo variants + favicon; git init + .gitignore | **done 2026-07-04 — at gate** |
| 2 | Static pages | Home (hero still, featured, story video slot, IG strip slot, donate band), About, Intake + surrender form, Contact + form | **done 2026-07-04 — at gate** |
| 3 | Content + CMS | content schema; Sveltia `config.yml`; `AnimalCard` (§5 logic); Adopt (Available + Happy Tails); detail pages; Our Family; empty states + 404; fake seed animals | **done 2026-07-04 — at gate** |
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

- **2026-07-04 — Our Family roster (phase 3): Ash + Midna only**, confirmed by owner —
  photos of her other pets don't exist yet; they'll be added later (via CMS or a
  follow-up). Both are cats; best shots picked from `Temporary Photos/` (Ash in the
  lampshade, Midna in the window), resized to 1600px/q85 on import, EXIF-corrected.
- **2026-07-04 — §9 boundary set for microcopy:** structural system text (empty
  states, Adopted banner, 404, pagination) is dev-owned and final; page intros and
  anything in "her voice" stays [DRAFT] until she writes it. Why: the §5/§9 empty-state
  wording comes from the brief itself; her voice is only the storytelling copy.
- **2026-07-04 — `/apply` built in phase 3** (brief leaves its phase implicit):
  Available cards link to it, so shipping the grid without it meant dead links. The
  `?pet={slug}` prefill works now; only the endpoint wiring remains (phase 4).
- **2026-07-04 — Sample photos made distinct** (KITTEN/PUP/SENIOR labels): identical
  striped placeholders got content-hash-deduplicated by Astro into one image, making
  sample cards indistinguishable at review.
- **2026-07-04 — Card names inherit section color:** on the dark Happy Tails band the
  card title was ebony-on-ebony (invisible). Fixed via `color: inherit` + underline
  hover. Caught by visual verification — exactly why every phase gets eyes on it.

- **2026-07-04 — Instagram strip: CMS-editable "Photo highlights" instead of Behold.**
  Owner proposed making the curated grid editable in Sveltia; endorsed and adopted.
  Design: a third small collection (image + Instagram post URL, ~12 tiles guidance),
  managed exactly like animals. Why: solves freshness without any external account,
  and makes Behold permanently unnecessary (still a 10-min add later if ever wanted).
  Amends the "owner edits only two collections" rule — CLAUDE.md updates when built
  (phase 4). Brief §2/§7's Behold plan is superseded.
- **2026-07-04 — Web3Forms verified** (current sources, not memory): warning email at
  100% of the free 250/month quota, then submissions pause until next month or a paid
  tier (~$5–18/mo). ~10× realistic volume for a small rescue; honeypot guards the
  quota; provider swap = one config value. Decision: forms get a visible failure
  state with a "email us directly at …" fallback so no application ever dies silently.
- **2026-07-04 — OWNER-CHECKLIST.md created** (repo root): everything needed from the
  sanctuary owner across all phases — Web3Forms key steps, PayPal/YouTube links, story
  doc prompts (incl. Charlie the horse, the namesake — hero-photo candidate and maybe
  an Our Family page), photo requests, and quick confirmations. Phase 4 starts when
  the owner gives the go (with or without her items — wiring is placeholder-first).

## Open questions (awaiting owner)

Waiting on the OWNER-CHECKLIST.md items from the sanctuary owner: Web3Forms key,
PayPal link, YouTube video, story doc, photos (hero/Charlie/pets/highlights), form
email + domain confirmation. Phase 4 go-ahead pending.

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
- [x] Home featured section — ~~hardcoded cards~~ — **CMS-driven since 2026-07-04**
  (shows sample animals until real ones exist; §5 fallback chain in place)
- [ ] Home Instagram strip — 6 striped sample tiles — live Behold feed in phase 4
- [ ] About page media — striped `PlaceholderBlock` — a photo of the sanctuary/owner
- [ ] `src/content/adoptables/` — 3 sample animals (sample-kitten, sample-pup,
  sample-senior) + striped sample photos — DELETE once real animals are in the CMS
- [ ] `src/content/residents/ash.md` + `midna.md` — [DRAFT] stories — her words;
  photos are temp picks she may swap; `arrived` dates unknown
- [ ] `site.ts` → `copy.adopt.intro`, `copy.family.intro`, `copy.apply.intro` —
  [DRAFT] — final wording from owner

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
