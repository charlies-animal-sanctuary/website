// @ts-check
import { defineConfig } from 'astro/config';

// Pure static output — no adapter. The site deploys to Cloudflare Pages as
// static files (approved deviation from brief §8.1: the adapter is SSR-only).
export default defineConfig({
  // site: 'https://DOMAIN-TBD' — set to the real DOMAIN (brief §11) once known;
  // required for absolute Open Graph URLs in phase 6.
});
