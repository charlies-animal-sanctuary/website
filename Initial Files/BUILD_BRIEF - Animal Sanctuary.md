# Charlie's Animal Sanctuary — Website Build Brief

> Single, self-contained brief to hand to Claude Code. Fill in the placeholders in **§11 Config values** first (they're the only project-specific unknowns). Everything else is decided.

> **Amendments log** — owner-approved changes since the original brief (full reasoning in `progress.md`'s decision log):
> - **2026-07-04 (technical):** Astro current major (v7, content-layer API); no Cloudflare adapter (pure SSG). CMS images stored entry-relative under `src/content/` so Astro optimizes every upload (supersedes §4c's `public/` paths). Fonts self-hosted via Fontsource. Text links on light backgrounds use Coffee Bean — olive text on cream measures 4.22:1, below AA. `/apply` page built in phase 3.
> - **2026-07-12 (media storage):** CMS uploads moved from entry-relative `images/` folders to shared root-relative `src/assets/{animals,family,highlights}` folders — Sveltia's entry-delete sweeps entry-relative media wholesale (two build-breaking incidents). Supersedes the 2026-07-04 entry-relative note below; optimization pipeline unchanged.
> - **2026-07-04 (Instagram):** Behold superseded — the homepage Instagram strip is an owner-curated third CMS collection, `highlights` (image + link to the matching post). §2, §3, §7, §11, §12 amended below. Guiding principle: the owner's entire editing world stays one tool (Sveltia at `/admin`) — nothing new to install or learn; simplicity over hard constraints.
> - **2026-07-11 (§4b):** residents' `featured` field removed — no template ever consumed it, so it was a silent no-op toggle in the CMS. The homepage featured spot is adoptables-only per §3.
> - **2026-07-12 (§5, owner feedback):** adopted photos are no longer dimmed — semi-transparency over the dark Happy Tails band read as washed-out/broken. Photos stay full colour; the "Adopted" banner and "Found their home {Month Year}" line carry the status. Happy Tails is a celebration wall, not an archive.

---

## 1. Project overview

Charlie's Animal Sanctuary is a small animal rescue in **Peterborough, ON** that does intake and adoptions (mostly cats, some dogs), run by a solo, non-technical owner, with a long-term aspiration to grow into a farm sanctuary.

The site has three jobs, in priority order:
1. Make a stranger fall for an animal and start an adoption.
2. Make donating easy.
3. Feel warm and trustworthy — a real place worth giving money to.

**Aesthetic principle:** calm, warm, photo-forward, fast. Restraint *is* the modern look here. Deliberately **not** flashy / animation-heavy / "clickbait" — heavy motion reads as untrustworthy when asking for donations.

**Users:**
- Public: adopters and supporters.
- One internal editor: the non-technical owner, who self-manages only the animal content. Everything else is developer-owned and static.

---

## 2. Tech stack (locked)

- **Framework:** Astro (SSG, content collections, built-in image handling, islands only where interactivity is needed).
- **CMS:** Sveltia CMS (git-based, Decap-compatible). Three collections: `adoptables`, `residents`, and `highlights` (the homepage photo strip — image + Instagram post link). *(Amended 2026-07-04; originally two.)* Admin at `/admin`. Login = GitHub OAuth via the Sveltia auth Cloudflare Worker.
- **Hosting:** Cloudflare Pages (git-connected; auto-deploys on every commit, including Sveltia's). Domain already on Cloudflare — custom domain wires up in-account. (Workers Static Assets is an equivalent alternative; Pages is the simpler path for a content-first static site.)
- **Forms:** a free form-to-email service (Web3Forms / Formspree / Basin). One-way: submission emails the owner, `reply-to` = the submitter's email. **No email server, no Resend for v1.**
- **Instagram gallery:** owner-curated `highlights` CMS collection — each tile is an image + a link to the matching Instagram post, rendered with the site's own design tokens. *(Amended 2026-07-04; Behold auto-feed superseded, remains an optional later add.)*
- **Video:** YouTube embeds (channel `@CharliesAnimalSanctuary`). Never self-host video.
- **Donations:** a single donation URL held in site config (PayPal to start; possibly Zeffy later). No per-animal fund routing.

---

## 3. Information architecture

Top-level nav (keep to these 6): **Home · About · Adopt · Our Family · Intake · Contact**

Content ownership:
- **Static (developer-owned, in repo):** Home, About, Intake, Contact.
- **CMS (owner-editable, no code):** Adopt → `adoptables` collection; Our Family → `residents` collection; Home photo strip → `highlights` collection *(amended 2026-07-04)*.

Page contents:
- **Home:** hero (short silent looped clip with poster fallback, *or* one strong still) + primary CTAs (Adopt / Donate); a featured animal or two (`featured: true`); an embedded "Watch our story" YouTube video; an Instagram gallery strip; a donate call-to-action band; footer.
- **About:** the rescue's story and mission (first-person, warm). Static.
- **Adopt:** see §5. Available animals up top; adopted animals flow into a "Happy Tails" archive. Each animal also has its own **detail page**.
- **Our Family:** the owner's permanent, non-adoptable residents. Same card look as Adopt, minus status/apply. Each resident also has a detail page.
- **Intake:** how to surrender/report an animal + a surrender form (emails the owner). Static copy.
- **Contact:** contact form + `Peterborough, ON` + social links (Instagram, YouTube). **Do not publish a home address** — city / service area only.
- **Animal detail pages:** `/adopt/{slug}` and `/family/{slug}` — full bio/story, photo gallery, and (for adoptables) the apply/donate buttons. This is what a shared link lands on, so it also sets the per-page share image (§7).
- **System pages:** a 404 page and sensible empty states (§5).
- **Footer (all pages):** social links (IG, YouTube), donate button, copyright. Newsletter signup optional/later.

---

## 4. Content model / schema

Two files must stay in sync: the **Sveltia config** (owner's editing UI) and the **Astro content collection schema** (type-safe reading). Both are given below.

### 4a. Adoptable animal — fields

| Field | Type | Required | Notes |
|---|---|---|---|
| name | string | yes | |
| species | select (Cat/Dog/Other) | yes | |
| sex | select (Male/Female/Unknown) | yes | |
| age | string | yes | free text, e.g. "12 weeks", "2 years" |
| size | select (Small/Medium/Large) | no | |
| status | select (Available/Pending/Adopted) | yes | drives all rendering; default Available |
| photo | image | yes | main card photo |
| gallery | list of images | no | optional extra photos |
| bio | long text | yes | **written in first person** ("I'm a…") |
| temperament | list of strings | no | tags, e.g. playful, cuddly, good with kids |
| adoption_fee | string | no | short note |
| adopted_date | datetime | no | set when status → Adopted; orders Happy Tails |
| featured | boolean | no | show on homepage (default false) |

### 4b. Resident (Our Family) — fields

| Field | Type | Required | Notes |
|---|---|---|---|
| name | string | yes | |
| species | select (Cat/Dog/Horse/Other) | yes | |
| photo | image | yes | |
| gallery | list of images | no | |
| story | long text | yes | first-person |
| arrived | datetime | no | |
| featured | boolean | no | default false |

### 4c. Sveltia CMS config — `public/admin/config.yml`

```yaml
backend:
  name: github
  repo: OWNER/REPO              # ← fill in
  branch: main
  base_url: https://AUTH_WORKER_URL   # ← Sveltia auth Cloudflare Worker (see §7)

media_folder: "public/images/animals"   # where uploaded images are committed
public_folder: "/images/animals"        # public URL path

collections:
  - name: adoptables
    label: "Adoptable animals"
    label_singular: "Animal"
    identifier_field: name
    folder: "src/content/adoptables"
    create: true
    slug: "{{slug}}"
    fields:
      - { name: name, label: "Name", widget: string }
      - { name: species, label: "Species", widget: select, options: ["Cat", "Dog", "Other"] }
      - { name: sex, label: "Sex", widget: select, options: ["Male", "Female", "Unknown"] }
      - { name: age, label: "Age", widget: string, hint: "e.g. 12 weeks, 2 years" }
      - { name: size, label: "Size", widget: select, options: ["Small", "Medium", "Large"], required: false }
      - { name: status, label: "Status", widget: select, options: ["Available", "Pending", "Adopted"], default: "Available" }
      - { name: photo, label: "Main photo", widget: image }
      - { name: gallery, label: "More photos", widget: list, required: false, field: { name: image, label: "Photo", widget: image } }
      - { name: bio, label: "Bio (write in first person)", widget: text, hint: "Write as the animal: 'I'm a...'" }
      - { name: temperament, label: "Temperament tags", widget: list, required: false, hint: "e.g. playful, cuddly, good with kids" }
      - { name: adoption_fee, label: "Adoption fee note", widget: string, required: false }
      - { name: adopted_date, label: "Adopted date", widget: datetime, required: false, hint: "Set when status becomes Adopted" }
      - { name: featured, label: "Feature on homepage", widget: boolean, default: false, required: false }

  - name: residents
    label: "Our family (permanent residents)"
    label_singular: "Resident"
    identifier_field: name
    folder: "src/content/residents"
    create: true
    slug: "{{slug}}"
    fields:
      - { name: name, label: "Name", widget: string }
      - { name: species, label: "Species", widget: select, options: ["Cat", "Dog", "Horse", "Other"] }
      - { name: photo, label: "Main photo", widget: image }
      - { name: gallery, label: "More photos", widget: list, required: false, field: { name: image, label: "Photo", widget: image } }
      - { name: story, label: "Their story (first person)", widget: text }
      - { name: arrived, label: "Arrived", widget: datetime, required: false }
      - { name: featured, label: "Feature on homepage", widget: boolean, default: false, required: false }
```

> In Decap/Sveltia, fields are **required by default**; only those marked `required: false` are optional.

### 4d. Matching Astro schema — `src/content/config.ts`

```ts
import { defineCollection, z } from "astro:content";

const adoptables = defineCollection({
  type: "content",
  schema: z.object({
    name: z.string(),
    species: z.enum(["Cat", "Dog", "Other"]),
    sex: z.enum(["Male", "Female", "Unknown"]),
    age: z.string(),
    size: z.enum(["Small", "Medium", "Large"]).optional(),
    status: z.enum(["Available", "Pending", "Adopted"]).default("Available"),
    photo: z.string(),
    gallery: z.array(z.string()).optional(),
    bio: z.string(),
    temperament: z.array(z.string()).optional(),
    adoption_fee: z.string().optional(),
    adopted_date: z.coerce.date().optional(),
    featured: z.boolean().default(false),
  }),
});

const residents = defineCollection({
  type: "content",
  schema: z.object({
    name: z.string(),
    species: z.enum(["Cat", "Dog", "Horse", "Other"]),
    photo: z.string(),
    gallery: z.array(z.string()).optional(),
    story: z.string(),
    arrived: z.coerce.date().optional(),
    featured: z.boolean().default(false),
  }),
});

export const collections = { adoptables, residents };
```

---

## 5. Adopt page behaviour (the core mechanic)

Everything on a card is template-driven from the record. The **status field alone** decides the card's appearance. The owner never touches layout.

- **Available** → shown in the "Available now" grid. Primary button: `Apply to adopt {name}` → `/apply?pet={slug}`. Secondary button: `Can't adopt? Help feed {name}` → the donation URL. (The donation link is the single site-wide URL; `{name}` is copy only, not per-animal fund routing.)
- **Pending** → stays in the Available grid with an "Adoption pending" pill; hide the apply button.
- **Adopted** → removed from the Available grid; added to the **Happy Tails** section (a separate section or page), sorted by `adopted_date` descending. Card photo stays full colour with an "Adopted" banner *(amended 2026-07-12 — dimming dropped per owner feedback)*; no apply button. Optional line: "Found their home {Month Year}".

**Handling accumulation:** Happy Tails will grow indefinitely — that's a feature (social proof), not a problem. Paginate or lazy-load it (e.g. 24 per page or infinite scroll with lazy images) so it never slows the page. The Available grid stays short and current. The split is automatic from `status`; the owner does nothing extra.

**Owner's entire recurring job:** add an animal, flip a status, and rarely delete a mistake. Deleting is only for genuine errors — adoptions become Happy Tails, never deletions.

**Detail pages:** each animal has its own page at `/adopt/{slug}` (residents at `/family/{slug}`) with the full bio/story, the photo gallery, and — for available adoptables — the apply and donate buttons. The `{slug}` is the shared key used by the card link, the detail route, and the `/apply?pet={slug}` prefill.

**Empty and edge states:** a small rescue will regularly sit at zero available animals between litters, and a blank grid reads as broken. Handle all three:
- Empty Available grid → a warm message with a nudge, e.g. "No animals looking for homes right now — follow along on Instagram, or check back soon."
- No `featured` animal set → fall back to the most recent Available animal, or hide the homepage feature section entirely.
- A 404 page written in the site's voice, linking back to Adopt and Home.

---

## 6. Design direction

### 6a. Color tokens (Rustic Earthy Tones)

Lock these as CSS variables / design tokens. **Never hand-pick a color anywhere else.** Assign roles once; enforce contrast in the build (the owner and the developer are partly colorblind, so contrast must be a tested number, not a judgment call).

| Role | Hex | Name | Text pairing / note |
|---|---|---|---|
| Page background / light surface | `#EDE0D4` | Almond Cream | Ebony text on it (≈ 9:1, AAA) |
| Body text + dark sections / footer | `#414833` | Ebony | On cream, or bg with cream text (≈ 9:1, AAA) |
| Primary CTA (Apply, Donate) | `#7F5539` | Coffee Bean | White text (≈ 7:1, AAA) |
| Secondary button / links / fills | `#656D4A` | Dusty Olive | **White** text (≈ 5.5:1) — not cream |
| Accent only (tags, borders, hover) | `#A68A64` | Camel | Weak text contrast (≈ 3:1) — decorative, never body text |

Add a WCAG **AA** contrast check to the build; nothing ships below it.

### 6b. Typography

Warm display face for headings + clean sans for body. Recommended (free, Google Fonts), swappable: **Fraunces** for headings, **Inter** for body. Two weights only for each. Sentence case throughout.

### 6c. Motion

Gentle and slow: soft scroll reveals, fades, hover lifts, smooth transitions. No bounce, no parallax spectacle. Wrap all animation in `prefers-reduced-motion: no-preference` (opt-out by default). Motion is polish, added last.

### 6d. Cards & images

- Fixed aspect ratio per card (4:5 or 1:1), `object-fit: cover`, center focal point — uniform grid regardless of source photo. (Sveltia stores originals; there's no smart-crop, so ~occasionally a photo crops awkwardly and the fix is swapping in a better-framed one.)
- 12px corner radius, hairline border, subtle hover lift.
- Lazy-load images below the fold.

### 6e. Logo

White line-art logo (provided) sits on Ebony dark sections. Create a recolored **Ebony (`#414833`)** variant for use on cream backgrounds. Generate a favicon/app icon from the mark.

---

## 7. Integrations

- **Instagram gallery** *(amended 2026-07-04 — Behold superseded)*: the strip renders the owner-curated `highlights` collection (~6–12 tiles; each links to its Instagram post) plus a "Follow on Instagram" button. She updates it in the same admin where she manages animals. The original Behold JSON-feed plan stays on the shelf as a 10-minute upgrade if auto-updating is ever wanted.
- **YouTube:** channel `@CharliesAnimalSanctuary`. One embedded "Watch our story" on Home and/or About using `youtube-nocookie.com`, click-to-play, no autoplay-with-sound. Optional: a Shorts strip.
- **Forms (two, both one-way to owner's inbox):**
  - *Adoption application* — reached from `Apply to adopt {name}` → `/apply?pet={slug}`; the form reads the `pet` query param and pre-fills "which animal are you applying for."
  - *Intake / surrender* — on the Intake page; someone bringing an animal *to* the rescue.
  - Both POST to `FORM_SERVICE_ENDPOINT`; notifications go to `OWNER_EMAIL`, `reply-to` = submitter. Add a honeypot for spam.
- **Donations:** single `DONATE_URL` in site config, dropped into every card's secondary button and the header/footer donate button.
- **Hero media:** if using video, a short (≤ ~5s), compressed, muted, autoplay, looped clip with a poster-image fallback; fall back to the still under reduced-motion.
- **Social share / Open Graph:** every page sets Open Graph + Twitter-card meta (title, description, image). Animal detail pages use that animal's photo as the share image and the animal's name in the title, so sharing a specific animal on Facebook or in a text shows *that animal*, not a blank card. Provide a default site OG image for pages without one. High-leverage for a rescue that grows by sharing.

---

## 8. Build phases (suggested order)

1. **Scaffold** — Astro project + Cloudflare adapter; base layout, nav, footer; design tokens (CSS vars from §6a); font loading; global styles; logo variants + favicon.
2. **Static pages** — Home (hero, featured, story video, IG strip, donate band), About, Intake (+ surrender form), Contact (+ form, location, socials).
3. **Content + CMS** — `src/content/config.ts` (§4d); Sveltia `config.yml` at `/admin` (§4c); `AnimalCard` component with the §5 status logic; Adopt page (Available grid + Happy Tails); animal detail pages (`/adopt/{slug}`, `/family/{slug}`); Our Family page; empty/edge states + 404 (§5). Seed with obviously-fake sample animals (§9).
4. **Integrations** — Behold gallery; YouTube embeds; form service wiring + apply-page prefill; donation URL; form privacy note (§10).
5. **Auth + deploy** — Cloudflare Pages project (git-connected); Sveltia auth (GitHub OAuth app + Cloudflare Worker authenticator); custom domain; Cloudflare Web Analytics (§10); test owner login + a full add/edit/publish/deploy cycle.
6. **Polish** — motion (with reduced-motion); image sizing/lazyload; WCAG AA contrast audit; performance/Lighthouse; accessibility pass; SEO meta + Open Graph tags (per-animal share images, §7).

---

## 9. v1 content readiness & placeholder strategy

The owner has lots of temporary photos of her pets, but hasn't chosen final images or copy, or decided what goes where. So v1 is a **complete, real skeleton wearing obviously-fake content** — her feedback should be about layout and feel, never about placeholder words and photos she has to mentally filter out.

- **Centralize static content.** Put all static-page media and copy — hero image/headline, About story, section images, Intake/Contact copy, social links, `DONATE_URL` — in one config/data file (e.g. `src/config/site.ts` or a `src/content/site/` entry). Swapping in finals later means editing one file, not hunting through templates. (Animal images already flow through the CMS.)
- **Placeholders must look temporary.** Use neutral branded blocks or clearly-labelled stand-ins — never her real pet photos dressed up as final. On review she should never wonder "is this the real one?"
- **No collection cross-contamination.** Seed Adopt with 2–3 obviously-fake sample animals (e.g. "Sample Kitten", placeholder image) covering all three states — one Available, one Pending, one Adopted — so the grid, buttons, and Happy Tails all render. Her actual pets go **only** in Our Family.
- **Copy is placeholder too.** Use clearly-draft topical text; the real About/mission/Intake wording comes from her. Claude Code should not write copy that reads as final site voice and quietly becomes it.
- **Hero = still for v1.** Ship a strong still (easiest to swap, no encoding). The looped-video hero is a fast-follow once she picks a clip.
- **Track placeholders.** Keep a short list (or code comments) of every placeholder asset and copy block, so nothing temporary silently ships to production.

---

## 10. Recommended (decide during build)

Low-effort, all free, and mostly already in her Cloudflare account — confirm during the build rather than pre-committing.

- **Cloudflare Web Analytics** — free, cookieless, in her account. Because it's cookieless and the YouTube embeds use `nocookie`, this likely means **no cookie-consent banner needed** — a real simplification. Recommend on. (`ANALYTICS_TOKEN`)
- **Form privacy note** — the adoption form collects personal info, so add a one-line note that submissions are emailed to the owner, not shared or sold.
- **Cloudflare Turnstile** — free (her account); the spam upgrade path if the form honeypot isn't enough. (`TURNSTILE_SITE_KEY` / `TURNSTILE_SECRET`)
- **Owner "how to add an animal" guide** — not v1 code: a short, illustrated one-pager walking the Sveltia flow (add → set status → publish, and flipping to Adopted). Saves a pile of "how do I…" texts once she's driving it.

---

## 11. Config values to fill in

- `OWNER/REPO` — GitHub repo
- `AUTH_WORKER_URL` — deployed Sveltia auth Cloudflare Worker URL
- ~~`BEHOLD_FEED_URL`~~ — no longer needed *(amended 2026-07-04: `highlights` collection supersedes Behold)*
- `YOUTUBE` — channel `@CharliesAnimalSanctuary` + the featured video ID
- `DONATE_URL` — PayPal link now (Zeffy later if she registers as a charity)
- `FORM_SERVICE_ENDPOINT` + `OWNER_EMAIL` — form-to-email service endpoint and notification address
- `DOMAIN` — the Cloudflare domain
- `ANALYTICS_TOKEN` — Cloudflare Web Analytics (optional, §10)
- `TURNSTILE_SITE_KEY` / `TURNSTILE_SECRET` — optional, only if spam becomes an issue (§10)
- **Assets** — white logo (provided) + Ebony recolor to create; hero clip + poster (optional); animal photos come in via the CMS

---

## 12. Standing constraints & principles

- Warm, trustworthy, photo-forward — **not** flashy. The animals are the design.
- Colors only via tokens; enforce WCAG **AA** contrast in the build.
- Respect `prefers-reduced-motion`.
- No self-hosted video (YouTube only). No self-hosted email/SMTP.
- No home address on the site — `Peterborough, ON` / service area only.
- The owner edits **only** the three CMS collections (`adoptables`, `residents`, `highlights`); all other content is static and developer-owned. Her editing world stays one tool — Sveltia at `/admin` — with nothing new to install or learn. *(Amended 2026-07-04; originally two collections.)*
- Keep dependencies minimal and output static.
- All card images: fixed aspect ratio + `object-fit: cover`.
- Temporary content must look temporary — no placeholder photo or copy passing as final (§9).
