import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

/**
 * Content collections (brief §4d as amended, on Astro's content-layer API).
 * RULE (CLAUDE.md): fields must stay in sync with public/admin/config.yml —
 * any field change updates both files in the same commit.
 * Photos use image() so every CMS upload goes through Astro's optimizer.
 *
 * OWNER-PROOFING (learned in the 2026-07-11 publish test): Sveltia writes
 * optional fields the owner leaves blank as '' (and lists as []). A strict
 * schema then fails the WHOLE site build on a perfectly normal CMS save.
 * Every optional field below therefore passes through `blank`, which turns
 * '' / null into undefined before validation. Never remove that wrapper.
 */

// '' or null → undefined, so .optional()/.default() behave as intended
const blank = (v: unknown) => (v === '' || v === null ? undefined : v);

const adoptables = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/adoptables' }),
  schema: ({ image }) =>
    z.object({
      name: z.string(),
      species: z.enum(['Cat', 'Dog', 'Other']),
      sex: z.enum(['Male', 'Female', 'Unknown']),
      age: z.string(),
      size: z.preprocess(blank, z.enum(['Small', 'Medium', 'Large']).optional()),
      status: z.preprocess(blank, z.enum(['Available', 'Pending', 'Adopted']).default('Available')),
      photo: image(),
      gallery: z.preprocess(blank, z.array(image()).optional()),
      bio: z.string(),
      temperament: z.preprocess(blank, z.array(z.string()).optional()),
      adoption_fee: z.preprocess(blank, z.string().optional()),
      adopted_date: z.preprocess(blank, z.coerce.date().optional()),
      featured: z.preprocess(blank, z.boolean().default(false)),
    }),
});

const residents = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/residents' }),
  schema: ({ image }) =>
    z.object({
      name: z.string(),
      species: z.enum(['Cat', 'Dog', 'Horse', 'Other']),
      photo: image(),
      gallery: z.preprocess(blank, z.array(image()).optional()),
      story: z.string(),
      arrived: z.preprocess(blank, z.coerce.date().optional()),
      // Family who have passed — shown in the "Forever in our hearts" section
      memorial: z.preprocess(blank, z.boolean().default(false)),
      featured: z.preprocess(blank, z.boolean().default(false)),
    }),
});

// Homepage photo strip (brief amendment 2026-07-04): owner-curated tiles,
// each linking to its Instagram post (profile link when unset).
const highlights = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/highlights' }),
  schema: ({ image }) =>
    z.object({
      title: z.string(), // short caption — doubles as the image alt text
      photo: image(),
      // Deliberately NOT .url(): the owner pastes this by hand in the CMS, and
      // a strict schema would fail the whole site build on one malformed paste.
      // The homepage guards at render time (non-http values fall back to the
      // Instagram profile link).
      link: z.preprocess(blank, z.string().optional()),
      order: z.preprocess(blank, z.coerce.number().default(0)),
    }),
});

export const collections = { adoptables, residents, highlights };
