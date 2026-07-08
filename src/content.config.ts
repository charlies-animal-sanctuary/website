import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

/**
 * Content collections (brief §4d as amended, on Astro's content-layer API).
 * RULE (CLAUDE.md): fields must stay in sync with public/admin/config.yml —
 * any field change updates both files in the same commit.
 * Photos use image() so every CMS upload goes through Astro's optimizer.
 */

const adoptables = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/adoptables' }),
  schema: ({ image }) =>
    z.object({
      name: z.string(),
      species: z.enum(['Cat', 'Dog', 'Other']),
      sex: z.enum(['Male', 'Female', 'Unknown']),
      age: z.string(),
      size: z.enum(['Small', 'Medium', 'Large']).optional(),
      status: z.enum(['Available', 'Pending', 'Adopted']).default('Available'),
      photo: image(),
      gallery: z.array(image()).optional(),
      bio: z.string(),
      temperament: z.array(z.string()).optional(),
      adoption_fee: z.string().optional(),
      adopted_date: z.coerce.date().optional(),
      featured: z.boolean().default(false),
    }),
});

const residents = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/residents' }),
  schema: ({ image }) =>
    z.object({
      name: z.string(),
      species: z.enum(['Cat', 'Dog', 'Horse', 'Other']),
      photo: image(),
      gallery: z.array(image()).optional(),
      story: z.string(),
      arrived: z.coerce.date().optional(),
      // Family who have passed — shown in the "Forever in our hearts" section
      memorial: z.boolean().default(false),
      featured: z.boolean().default(false),
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
      link: z.string().optional(),
      order: z.number().default(0),
    }),
});

export const collections = { adoptables, residents, highlights };
