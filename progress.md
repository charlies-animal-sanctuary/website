# progress.md — build state

Rules live in [CLAUDE.md](CLAUDE.md); this file is only status, decisions, and open
questions. Update at every phase gate and every real decision — a stale log is worse
than none. **Last updated: 2026-07-11.**

## Where we are

- **Current phase:** 6 — Polish — **built + adversarially reviewed 2026-07-11,
  at the phase gate.** Shipped: §6c motion (scroll reveals + micro-transitions,
  reduced-motion/no-JS/print safe); SEO/OG (canonical URLs, per-animal JPEG
  share images, og-default.jpg card, sitemap via @astrojs/sitemap, robots.txt);
  responsive image srcsets everywhere + eager/high-priority LCP images on hero
  and detail pages; ADMIN-GUIDE.md (the §10 owner one-pager). A 16-agent review
  confirmed 9 real findings — all fixed: webp→jpeg og:images (LinkedIn/WhatsApp
  can't render webp), print-blank reveal sections, a Chromium-only observer
  trap that would silently hide the memorial section as it grows, duplicate
  Happy Tails page titles, card srcset overfetch, lazy LCP photos, a guide
  section describing a Sveltia delete dialog that doesn't exist, the homepage
  "sample animals" chip mislabeling real animals (now auto-hides), and the
  residents' no-op `featured` toggle (removed; brief §4b amended).
  Remaining before "done": owner review of the polish + the two §11 stragglers
  (analytics — optional) + real PayPal/video swaps whenever ready. DOMAIN
  resolved 2026-07-11: charliesanimalsanctuary.com (zone already on her
  Cloudflare NS); `site` switched in astro.config — owner adds the two custom
  domains in the Pages dashboard to activate.
- **Done (phase 5, 2026-07-11):** repo public on GitHub; owner deployed
  Cloudflare Pages + Sveltia auth worker herself via GOING-LIVE.md; full owner
  e2e publish test passed (add → publish → live → flip to Adopted → Happy
  Tails → delete), surfacing two real bugs fixed same-day (blank-tolerant
  schemas; delete photo-sweep restore).
- **Done (phase 4, 2026-07-08):** owner's file drop ingested from `_incoming/`
  (interview + config values + adoption-form PDF + 34 photos). Forms live on
  Web3Forms (key via `.env`, inline success/error with direct-email fallback,
  Web3Forms `botcheck` honeypot, privacy note); `/apply` now mirrors her real
  adoption application field-for-field; Intake form gained location/age/health
  fields from her interview. `highlights` collection built (schema + config.yml +
  home strip, 6 real tiles seeded). Real hero (Charlie's pasture in autumn).
  YouTube embed live (temp video). Donate URL live (temp PayPal). Real About page
  (her welcome + Charlie's story + how the rescue works + the dream + about
  Katheryn). Our Family: 4 living cats (Ash, Midna, Lily, Oliver) + memorial
  section "Forever in our hearts" (Charlie the horse, Molson the dog) via new
  optional `memorial` field. All resident stories written from her interview.
  Verified in preview: memorial pages, apply prefill, wired key, 18 pages build,
  contrast gate passes.
- **Done (phases 1–3):** scaffold; static pages; content + CMS. Gates passed.
- **Next:** owner reviews phase 4 (especially: her copy, the memorial treatment,
  the hero) → phase 5 (needs GitHub push) or content fixes first.
- **Blocked / awaiting owner:** gate review; the short "still needed" list below.

**2026-07-11 — Owner e2e test COMPLETE.** Login → add → publish → live →
status flip → Happy Tails → delete: all exercised by the owner herself. Two
real bugs surfaced and fixed (blank-optional schema failure below, and the
delete step: Sveltia's asset cleanup swept ALL photos in the shared
`images/` folder, including the three sample animals' — build failed until
they were restored from git history, commit a107745). Lesson for the owner
guide (§10, phase 6): when deleting an animal, only remove that animal's own
photos — or just ask. Deletes are rare by design (mistakes only; adoptions
become Happy Tails). Phase 5 remaining: optional analytics only (domain
resolved 2026-07-11 — charliesanimalsanctuary.com).

**2026-07-11 — Publish-test bug found & fixed (the test doing its job):** the
owner's first CMS publish committed fine, but the build rejected it — Sveltia
writes blank optional fields as `''`/`[]`, and the strict schema (`size` enum,
`adopted_date` date) failed the whole build. All three schemas now route every
optional field through a `blank` preprocessor (`''`/null → undefined). Her
commit needed no changes; her photo pipeline worked perfectly (2.5 MB upload →
56 kB webp). Owner login, publish, auto-deploy: all verified end-to-end.

**2026-07-11 — Owner feedback round 1 (Katheryn), all applied:** hero copy
"provide vet care" (meta description aligned); "Sample animals" chip removed
from the homepage (the samples still label themselves); Instagram strip
heading → "Life at the sanctuary" (tiles are curated uploads until she pastes
per-post links, so the old heading over-promised); donate band → "How to
help", its button dropped (the footer's Donate is directly below) and the
dead space between band and footer tightened; gallery photos on all detail
pages now open a lightbox (new GalleryGrid component — native dialog, Esc/
backdrop close, no-JS fallback opens the full photo); headings moved to
Fraunces Variable pinned at 'opsz' 24 + 'WONK' 0 — the "strange lowercase f"
was Fraunces' leaning display-cut letterform. About/Adopt pages: approved
as-is. Custom domain verified live on both apex and www.

**2026-07-12 — First real animals + second delete-sweep + feedback round 2.**
Owner published Ghost and Grover (first real adoptables) and deleted the three
samples herself — the CMS delete swept the ENTIRE shared images folder again
(including Ghost's and Grover's photos), silently breaking every deploy after.
Restored all referenced photos from the Create commits; samples stay deleted.
Feedback fixes: lightbox now centers (the global `* { margin: 0 }` reset was
overriding the UA's `<dialog>` `margin: auto`); heading font swapped Fraunces →
Lora (owner twice flagged Fraunces' hooked lowercase f — it's an intrinsic
letterform of that typeface, not removable by any axis; brief §6b allows the
swap; contrast/weights unchanged). ADMIN-GUIDE delete section hardened to
"never delete — message Faraaz," with the honest why. OPEN ITEM: consider
moving CMS media out of entry-relative folders so Sveltia deletes stop
sweeping siblings — needs a careful migration, proposed to owner.

**2026-07-12 — Media migration (delete-sweep fix), owner-approved.** CMS media
moved from entry-relative `images/` folders to shared root-relative folders:
`/src/assets/{animals,family,highlights}` (public_folder `../../assets/…` so
Astro's `image()` keeps optimizing). Verified against Sveltia's SOURCE, not
assumption: deletes only attach assets when the folder is entry-relative, and
`entryRelative = !mediaFolder.startsWith('/')` — the leading slash in
media_folder is THE load-bearing character (a first draft without it would
have changed nothing). 45 images moved, 14 entries' paths rewritten, config +
CLAUDE.md + brief amended, sample-photo generation retired from the asset
script. Local build green. Remaining: live end-to-end test (create + delete a
throwaway animal in the real admin; expect the delete commit to touch ONLY
the .md file).

## Phase log (brief §8)

| # | Phase | Scope | Status |
|---|---|---|---|
| 1 | Scaffold | Astro project; base layout/nav/footer; tokens; fonts; global styles; logo variants + favicon; git init + .gitignore | **done 2026-07-04 — at gate** |
| 2 | Static pages | Home (hero still, featured, story video slot, IG strip slot, donate band), About, Intake + surrender form, Contact + form | **done 2026-07-04 — at gate** |
| 3 | Content + CMS | content schema; Sveltia `config.yml`; `AnimalCard` (§5 logic); Adopt (Available + Happy Tails); detail pages; Our Family; empty states + 404; fake seed animals | **done 2026-07-04 — at gate** |
| 4 | Integrations + real content | Web3Forms wiring; highlights strip; YouTube embed; donate URL; privacy note; owner's stories/photos/config ingested | **done 2026-07-08 — at gate** |
| 5 | Auth + deploy | Cloudflare Pages, Sveltia auth worker, domain, analytics, owner end-to-end publish test | **done 2026-07-11** (analytics optional/pending) |
| 6 | Polish | motion (reduced-motion safe); image sizing/lazyload; WCAG AA audit; Lighthouse; a11y pass; SEO/OG incl. per-animal share images | **built + reviewed 2026-07-11 — at gate** |

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

- **2026-07-04 — Brief formally amended (owner authorized).** An amendments log now
  sits at the top of the brief; §2/§3/§7/§11/§12 updated for the `highlights`
  collection (Behold superseded) and the previously approved technical deviations.
  CLAUDE.md updated to match (three collections; one-tool principle). Why: the brief
  is the source of truth — adopted changes must live IN it, not only alongside it.
  Guiding principle recorded per owner: keep her workflow simple, don't infantilize —
  no hard fences needed, but never a second tool to install or learn.
- **2026-07-04 — `_incoming/` drop zone created** for unsorted file handoffs:
  gitignored (README excepted), processed into the site tree on use, safe to empty.
  `Initial Files/` frozen as the original handoff. Why: the owner will deliver files
  in bulk without structure; the repo needs a boundary between raw handoffs and
  committed, optimized assets.

- **2026-07-08 — Owner's materials ingested** (`_incoming/File dump/`): interview MD
  (config values + her voice sample + full interview), her real cat-adoption Google
  Form (PDF), and 34 photos across 6 pets. Photo triage ran as a 6-agent parallel
  pass rating every shot for card/gallery/hero fit; picks recorded in
  `scripts/generate-assets.ps1`. Originals stay in `_incoming/` (safe to empty —
  processed copies are committed).
- **2026-07-08 — Copy status changed from [DRAFT] to "hers, pending approval".**
  All page copy is now synthesized from the owner's own interview words (voice
  sample as calibration); the [DRAFT] chips came off so she reviews the site as it
  would ship. §9 discipline continues only where content is still genuinely fake:
  the 3 sample adoptables (chip intact) and her missing About portrait.
- **2026-07-08 — Charlie and Molson are memorials.** The interview made clear both
  have passed. Added optional `memorial` boolean to residents (schema + config.yml,
  same commit); they render in a separate "Forever in our hearts" section and get
  "Forever in our hearts" instead of "Permanent resident" on their pages. Stories
  written in HER voice (they're remembrances); living pets stay in animal-voice
  first person per §4. Owner to confirm the treatment feels right.
- **2026-07-08 — Hero = Charlie's pasture in autumn** (triage hero-fit 9/10:
  landscape, on-palette golds, and it IS the farm-sanctuary dream — plus the
  namesake's own field). Owner can veto at gate.
- **2026-07-08 — Web3Forms wired via `PUBLIC_WEB3FORMS_KEY` in `.env`** (gitignored;
  `.env.example` documents it; Cloudflare Pages env at phase 5). The key is
  public-by-design (ships in built HTML) but stays out of the public repo source.
  Forms POST directly to the Web3Forms API; JS enhances with inline success/error +
  mailto fallback; no-JS plain POST still works. `subject`/`from_name`/`form_name`
  set per form so her inbox sorts cleanly.
- **2026-07-08 — `/apply` mirrors her real application** (the Google Form PDF),
  field-for-field in four fieldsets, generalized from "cat" to any animal. Her form
  can retire once the site is live.
- **2026-07-08 — Facebook added to socials** from the interview ("under
  CharliesAnimalSanctuary") — exact URL needs her confirmation (see below).

- **2026-07-08 — Adversarial review of phase 4 (20-agent workflow): 14 confirmed
  findings, all fixed same day.** Highlights: (1) the highlights `link` field was
  schema-validated as a strict URL while the CMS accepted any string — one malformed
  paste by the owner would have failed every future build; schema relaxed, homepage
  guards at render (non-http → profile link). (2) Date-only frontmatter + local-TZ
  formatting shifted first-of-month dates a month back; all date formatting now pins
  `timeZone: 'UTC'`. (3) About page imported Charlie's photo from the CMS-managed
  media folder (owner edit could break the build); it now uses a developer-owned
  copy in `src/assets/about/`. (4) **Content fidelity — the big one:** synthesis had
  invented facts beyond the interview, worst being a donation-allocation promise
  ("every donation goes to…"); also invented: lifelong boarding for Charlie, fosters
  using Molson's toys, a meet-and-greet step, a best-for-the-animal policy line,
  "volunteering", the other barn cats' fate, and a founding role implied for Molson.
  All copy pulled back to exactly what she said. (5) Form status live region was
  hidden-then-populated (screen readers wouldn't announce) and focus dropped to body
  on submit; region now always rendered and focused on completion. Lesson recorded:
  synthesized copy gets a fidelity pass against the source before it's called "hers."

## Still needed from the owner (small list)

1. **Confirm the memorial treatment** for Charlie and Molson (section name, stories,
   placement) — sensitive content, her call entirely.
2. **Approve the copy** — every page now reads in her voice; she should read About,
   the pet stories, and the intake/adopt/apply intros and correct anything.
   Specifically flagged for her explicit OK (reasonable but not literally hers):
   the donate-band line ("…funded by content creation, adoption fees — and people
   like you"), the reply-by-email commitments on Intake, and the apply intro.
3. **Instagram post links** for the 6 highlight tiles (currently they link to her
   profile; post links make each tile land on its post). She can also do this
   herself in `/admin` once live.
4. ~~The domain~~ — resolved 2026-07-11: charliesanimalsanctuary.com.
5. Real PayPal link + real "our story" video, when ready (temp ones live now).

Resolved 2026-07-08 (same-day owner replies): real Facebook URL wired
(facebook.com/people/Charlies-Animal-Sanctuary/61581016065923); Katheryn's About
photo = the selfie of Charlie resting his muzzle on her head (from the Charlie
folder — owner pointed it out), imported as a developer-owned copy; Charlie's
gallery swapped to the other selfie so both get used. The last placeholder
block on the site is gone.

## Placeholder / temp tracker (§9)

Checked = resolved with the real thing. Remaining opens are below.

- [x] `social.instagram` — real URL (2026-07-04)
- [x] Forms endpoint — **Web3Forms live** via `.env` key (2026-07-08)
- [x] Home hero — **real photo: Charlie's pasture** (2026-07-08)
- [x] Home IG strip — **6 real tiles via `highlights` collection** (2026-07-08);
  tiles link to her profile until per-post links arrive
- [x] Home featured section — CMS-driven (2026-07-04)
- [x] All page copy (`site.ts` → `copy`) — **synthesized from her interview**
  (2026-07-08), pending her read-through at the gate
- [x] Resident stories — real (Ash, Midna, Lily, Oliver, Charlie†, Molson†),
  from her interview (2026-07-08)
- [ ] `donateUrl` — **[TEMP]** her placeholder PayPal (`paypalme/lilycharlestwitch`)
  — swap for the real donation link before launch
- [ ] `youtubeStoryVideoId` — **[TEMP]** her placeholder video (`7zB-pkw2B4U`) —
  swap for the real "our story" video before launch
- [ ] `social.facebook` — guessed URL — owner to confirm
- [ ] About page — Katheryn's portrait — striped placeholder block until her photo
  arrives
- [ ] `src/content/adoptables/` — 3 obviously-fake sample animals (chip on homepage)
  — DELETE once real adoptables exist in the CMS
- [ ] Highlight tile `link` fields — empty (profile fallback) — her IG post links
- [ ] Resident `arrived` dates — unknown, omitted — optional, she can add in CMS

## Config values (brief §11)

| Key | Value | Status |
|---|---|---|
| `FORM_SERVICE_ENDPOINT` / key | Web3Forms, key in `.env` | **live 2026-07-08** |
| `OWNER_EMAIL` | CharliesAnimalSanctuary@gmail.com | **live** (forms, contact page) |
| `DONATE_URL` | paypalme/lilycharlestwitch | **[TEMP]** — real link later |
| `YOUTUBE` featured video ID | `7zB-pkw2B4U` | **[TEMP]** — real video later |
| ~~`BEHOLD_FEED_URL`~~ | superseded by `highlights` | closed |
| `OWNER/REPO` | — | phase 5 |
| `AUTH_WORKER_URL` | — | phase 5 |
| `DOMAIN` | charliesanimalsanctuary.com (set 2026-07-11) | wired in astro.config `site` |
| `ANALYTICS_TOKEN` | — | phase 5 (recommend on) |
| `TURNSTILE_SITE_KEY` / `TURNSTILE_SECRET` | — | only if honeypot proves insufficient |
