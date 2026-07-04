# _incoming — file drop zone

Drop anything here, in any structure (or none): photos, her story doc, screenshots,
folders straight off a phone. This folder is the handoff point, not part of the site.

How it works:

- Everything here is **gitignored** (except this README) — nothing in this folder is
  ever committed or published by accident.
- When files get used, they're renamed, resized, and copied into their proper place in
  the site (`src/content/…`, `src/assets/…`); the site never references this folder.
- Once processed, the originals here are **safe to delete** — keeping the real
  originals in her camera roll / cloud is the actual backup.
- `Initial Files/` is the frozen first handoff — new material goes here instead.
