import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

/**
 * Content collections (brief §4d, on Astro's current content-layer API).
 * RULE (CLAUDE.md): fields must stay in sync with public/admin/config.yml —
 * any field change updates both files in the same commit.
 * Photos use image() so every CMS upload goes through Astro's optimizer
 * (approved deviation from the brief's public/ storage).
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
      featured: z.boolean().default(false),
    }),
});

export const collections = { adoptables, residents };
