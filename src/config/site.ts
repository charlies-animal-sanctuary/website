/**
 * Central static-site config (brief §9): ALL static copy, links, and §11
 * config values live here. Swapping placeholder → final means editing THIS
 * file only — never hunt through templates.
 * Every "[PLACEHOLDER]" value is tracked in progress.md's placeholder tracker.
 */
export const site = {
  name: "Charlie's Animal Sanctuary",
  location: 'Peterborough, ON', // city only — never a street address (brief §12)

  // [PLACEHOLDER] meta description — final wording comes from the owner
  description:
    "[PLACEHOLDER] Draft description: Charlie's Animal Sanctuary is a small animal rescue in Peterborough, ON.",

  nav: [
    { label: 'Home', href: '/' },
    { label: 'About', href: '/about' },
    { label: 'Adopt', href: '/adopt' },
    { label: 'Our Family', href: '/family' },
    { label: 'Intake', href: '/intake' },
    { label: 'Contact', href: '/contact' },
  ],

  // [PLACEHOLDER] DONATE_URL (brief §11) — real PayPal link TBD from owner
  donateUrl: '#placeholder-donate-url',

  social: {
    // [PLACEHOLDER] Instagram profile URL TBD from owner
    instagram: '#placeholder-instagram-url',
    // Real channel, given in brief §2
    youtube: 'https://www.youtube.com/@CharliesAnimalSanctuary',
  },
} as const;
