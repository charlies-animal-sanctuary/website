#!/usr/bin/env node
/**
 * Report-only orphan finder: lists CMS-uploaded photos that no content entry
 * references anymore. Orphans are EXPECTED and harmless — they accumulate
 * because entry deletes deliberately never remove photos (the delete-sweep
 * fix, 2026-07-12). Run occasionally; prune manually in a commit if desired.
 * Never deletes anything.
 */
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';

const root = new URL('..', import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1');
const mediaDirs = ['src/assets/animals', 'src/assets/family', 'src/assets/highlights'];
const contentDirs = ['src/content/adoptables', 'src/content/residents', 'src/content/highlights'];

const entryText = contentDirs
  .flatMap((dir) => {
    try {
      return readdirSync(join(root, dir))
        .filter((f) => f.endsWith('.md'))
        .map((f) => readFileSync(join(root, dir, f), 'utf8'));
    } catch {
      return [];
    }
  })
  .join('\n');

let orphanCount = 0;
let orphanBytes = 0;

for (const dir of mediaDirs) {
  let files = [];
  try {
    files = readdirSync(join(root, dir));
  } catch {
    continue;
  }
  for (const file of files) {
    if (!entryText.includes(file)) {
      const { size } = statSync(join(root, dir, file));
      orphanCount += 1;
      orphanBytes += size;
      console.log(`  orphan  ${dir}/${file}  (${(size / 1024).toFixed(0)} kB)`);
    }
  }
}

console.log(
  orphanCount === 0
    ? 'No orphaned media — every uploaded photo is referenced by an entry.'
    : `\n${orphanCount} orphaned file(s), ${(orphanBytes / 1024 / 1024).toFixed(1)} MB total. Harmless; prune in a commit whenever.`
);
