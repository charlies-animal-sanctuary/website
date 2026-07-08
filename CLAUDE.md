# CLAUDE.md — Charlie's Animal Sanctuary Website

Durable project rules. Current status lives in [progress.md](progress.md) — never here.
The complete spec is **the brief**: `Initial Files/BUILD_BRIEF - Animal Sanctuary.md`.
It is the source of truth; §n references below point into it. This file summarizes and
points — when in doubt, the brief wins.

## What this is

v1 website for Charlie's Animal Sanctuary — a small animal rescue in Peterborough, ON
(mostly cats, some dogs), run by a solo, non-technical owner, with farm-sanctuary
aspirations. The site's jobs, in priority order (§1):

1. Make a stranger fall for an animal and start an adoption.
2. Make donating easy.
3. Feel warm and trustworthy — a real place worth giving money to.

Aesthetic: calm, warm, photo-forward, fast. Restraint IS the look — no flashy or heavy
motion; it reads as untrustworthy when asking for donations.

## Roles

- **Owner/approver** (the user): directs, reviews, decides. Non-technical on the tooling;
  final say on everything.
- **Claude Code**: builds. Stops at every §8 phase gate for review. Never runs ahead.

## Locked stack (§2 — do not substitute)

- **Astro** — SSG, content collections, islands only where interactivity is truly needed.
- **Sveltia CMS** at `/admin` — three collections: `adoptables`, `residents`, and
  `highlights` (homepage photo strip; lands in phase 4). GitHub backend + Sveltia auth
  Cloudflare Worker (wired only after the repo is pushed). Her editing world is ONE
  tool — never add software she'd have to install or learn.
- **Cloudflare Pages** — git-connected auto-deploy (wired post-push).
- **Forms** — free form-to-email service, one-way to owner's inbox, `reply-to` = submitter,
  honeypot. No email server, no Resend.
- **Instagram** — owner-curated `highlights` collection renders the strip (each tile
  links to its post); Behold superseded 2026-07-04, optional later. **Video** — YouTube
  embeds (`youtube-nocookie.com`) only; never self-host. **Donations** — one site-wide
  `DONATE_URL`.

## Architecture & folder conventions

- `src/pages/` — Home, About, Adopt, Our Family (`/family`), Intake, Contact, `/apply`
  (standalone, not in nav), `/happy-tails` (paginated, 24/page), detail routes
  `/adopt/[slug]` + `/family/[slug]`, 404.
  Nav is exactly: Home · About · Adopt · Our Family · Intake · Contact (§3).
- CMS media is entry-relative: uploads land in an `images/` folder beside each
  collection's markdown (`./images/…` in frontmatter) so Astro's `image()` pipeline
  optimizes them. Global fallback: `src/assets/uploads`.
- `src/content/adoptables/` + `src/content/residents/` + `src/content/highlights/` —
  CMS-owned markdown. The Astro content schema and `public/admin/config.yml` (§4) must
  stay field-for-field in sync; any field change updates both in the same commit.
- `src/config/site.ts` — ALL static copy, media references, social links, and §11 config
  values live here (§9). Templates never hard-code copy, URLs, or contact details.
- `src/components/` — `AnimalCard` owns the §5 status logic; shared layout/nav/footer in
  `src/layouts/`.
- `src/styles/tokens.css` — the only place a color is ever defined.

## Design-token discipline (§6 — enforced, not judged)

| Role | Name | Hex |
|---|---|---|
| Page background / light surface | Almond Cream | `#EDE0D4` |
| Body text + dark sections / footer | Ebony | `#414833` |
| Primary CTA (Apply, Donate) — white text | Coffee Bean | `#7F5539` |
| Secondary button / links — **white** text, not cream | Dusty Olive | `#656D4A` |
| Accent only (tags, borders, hover) — never body text | Camel | `#A68A64` |

- Colors ONLY via tokens. Never hand-pick a hex anywhere else.
- WCAG **AA** is a tested number, not a judgment call (owner and developer are partly
  colorblind): `scripts/check-contrast.mjs` gates every build; nothing ships below AA.
- Text links on light surfaces are **Coffee Bean** — Dusty Olive TEXT on cream measures
  4.22:1 (fails AA); olive is fill-only, always with white text.
- Type: Fraunces (headings) + Inter (body), two weights each, sentence case throughout (§6b).
- Motion: gentle only, wrapped in `prefers-reduced-motion: no-preference`, added last (§6c).
- Cards: fixed aspect ratio, `object-fit: cover`, 12px radius, hairline border, hover lift,
  lazy-load below the fold (§6d).
- Logos (§6e): white variant on Ebony sections, Ebony variant on cream — both provided in
  `Initial Files/logo/` (`charlie-logo-white.png`, `charlie-logo-ebony.png`). Favicon derived
  from the mark. `Animal_Sanctuary1_Logo.png` is the original export (gray bg) — reference only.

## Content model & the status mechanic (§4–§5)

- Two collections only. Adoptables: name, species, sex, age, size?, status, photo, gallery?,
  bio (first person), temperament?, adoption_fee?, adopted_date?, featured. Residents: name,
  species, photo, gallery?, story (first person), arrived?, featured. Exact schema: §4.
- **`status` alone drives all rendering** (§5):
  - Available → "Available now" grid; `Apply to adopt {name}` → `/apply?pet={slug}`;
    secondary `Can't adopt? Help feed {name}` → `DONATE_URL` (copy only, no fund routing).
  - Pending → stays in grid, "Adoption pending" pill, apply button hidden.
  - Adopted → leaves grid, joins **Happy Tails** (sorted `adopted_date` desc), dimmed photo +
    "Adopted" banner, no apply. Happy Tails grows forever by design — paginate/lazy-load.
- Owner's entire recurring job: add an animal, flip a status. Adoptions become Happy Tails,
  **never deletions** (deleting is only for genuine mistakes).
- The `{slug}` is the shared key: card link, detail route, and `/apply?pet={slug}` prefill.
- Required empty states (§5): zero-available message, featured-animal fallback, on-voice 404.

## Standing constraints (§12 — non-negotiable)

- The owner edits ONLY the three CMS collections (`adoptables`, `residents`,
  `highlights`); everything else is static, developer-owned.
- No self-hosted video or email. No home address anywhere — "Peterborough, ON" only.
- Minimal dependencies; static output.
- Placeholder discipline (§9): obviously-fake sample animals seed Adopt (one Available, one
  Pending, one Adopted) — the owner's real pets go ONLY in Our Family. Copy reads as draft,
  never final voice. Hero is a still for v1. Every placeholder is tracked in progress.md.

## Workflow rules

- Build in §8 phases; STOP at each gate for owner review. Don't run ahead.
- Update progress.md at every phase gate and every real decision — it is part of "done."
- Ambiguity → ask the owner, don't guess. Fix causes, not symptoms.
- Git is **local-only** for now: no GitHub remote, no Cloudflare Pages connection, no live
  Sveltia auth. Build those in code; note in progress.md that they get wired once pushed.
  Clean, meaningful commits; `.gitignore` (node_modules, dist, .env) from the first commit.
- This repo will eventually be **public**: real keys/tokens only in gitignored `.env`;
  `Initial Files/` stays untracked (owner's personal photos) — copy needed assets into the
  site tree instead. Anything ever committed is in history forever.
- **File drops land in `_incoming/`** (gitignored except its README): unsorted photos,
  docs, and dumps from the owner go there; anything used gets renamed/resized/processed
  into the site tree (usually via `scripts/generate-assets.ps1`). Originals are never
  committed; the folder is safe to empty at any time. `Initial Files/` is the frozen
  original handoff (tracked exception: the brief) — don't add to it.
- Don't run `astro build` while the dev server is serving — it re-optimizes the shared
  Vite dep cache and the dev server starts dropping scoped styles. Stop dev first (or
  restart it after building).
