// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// Pure static output — no adapter. The site deploys to Cloudflare Pages as
// static files (approved deviation from brief §8.1: the adapter is SSR-only).
export default defineConfig({
  // Absolute-URL base for canonical links, Open Graph images, and the sitemap.
  // Currently the pages.dev address — swap this ONE line when the custom
  // domain (brief §11 DOMAIN) is picked.
  site: 'https://charlies-animal-sanctuary.pages.dev',
  integrations: [sitemap()],
});
