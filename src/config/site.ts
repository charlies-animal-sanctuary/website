/**
 * Central static-site config (brief §9): ALL static copy, links, and §11
 * config values live here. Swapping placeholder → final means editing THIS
 * file only — never hunt through templates.
 * Every "[PLACEHOLDER]"/"[DRAFT]" value is tracked in progress.md's tracker.
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

  // [PLACEHOLDER] FORM_SERVICE_ENDPOINT (brief §11) — Web3Forms, wired in phase 4
  formEndpoint: '#placeholder-form-endpoint',

  // [PLACEHOLDER] featured "Watch our story" video ID (brief §11) — empty string
  // renders the placeholder panel until the owner picks a video
  youtubeStoryVideoId: '',

  social: {
    instagram: 'https://www.instagram.com/charliesanimalsanctuary/',
    youtube: 'https://www.youtube.com/@CharliesAnimalSanctuary', // real channel (brief §2)
  },

  /**
   * Page copy. Everything below is DRAFT scaffolding copy (brief §9): it gives
   * the pages a real shape to react to, but the final voice comes from the
   * owner. Each block is marked so nothing temporary can pass as final.
   */
  copy: {
    home: {
      heroHeadline: 'Small rescue. Soft landings. [DRAFT]',
      heroSub:
        '[DRAFT] One or two warm sentences about taking in cats and dogs around Peterborough and finding them homes — final wording comes from the owner.',
      featuredHeading: 'Looking for a home',
      videoHeading: 'Watch our story',
      instagramHeading: 'Follow along on Instagram',
      donateHeading: 'Every little bit helps [DRAFT]',
      donateSub:
        '[DRAFT] A sentence about what donations pay for — food, vet visits, litter, blankets. Final wording comes from the owner.',
    },
    about: {
      title: 'About us',
      intro: '[DRAFT] A one-line warm introduction to the sanctuary goes here.',
      paragraphs: [
        '[DRAFT — the real story comes from the owner, in her own words] How the sanctuary started: the first rescue, why it kept going, and what it is today.',
        '[DRAFT] What we do: intake, fostering, vet care, and adoptions — mostly cats, some dogs, the occasional surprise.',
        '[DRAFT] Where this is going: the long-term dream of growing into a farm sanctuary.',
      ],
    },
    intake: {
      title: 'Intake & surrender',
      intro:
        '[DRAFT] A kind, judgment-free explanation of how to surrender an animal or report one that needs help. Final wording comes from the owner.',
      steps: [
        '[DRAFT] Step one: fill out the form below with as much detail as you can.',
        '[DRAFT] Step two: we read every submission and reply by email as soon as we can.',
        '[DRAFT] Step three: if we can take the animal in, we arrange a time and place together.',
      ],
      formHeading: 'Tell us about the animal',
    },
    contact: {
      title: 'Contact',
      intro:
        '[DRAFT] A friendly line inviting questions about adopting, donating, volunteering, or anything else.',
      formHeading: 'Send us a message',
    },
    adopt: {
      title: 'Adopt',
      intro:
        '[DRAFT] A line about how adopting works here — apply first, then a meet-and-greet. Final wording comes from the owner.',
      // §5 empty-state microcopy (dev-owned system text, wording from the brief)
      emptyMessage:
        'No animals are looking for homes right now — follow along on Instagram, or check back soon.',
      happyTailsHeading: 'Happy Tails',
      happyTailsBlurb: 'The ones who made it home. This list only ever gets longer.',
    },
    family: {
      title: 'Our family',
      intro:
        '[DRAFT] These are the permanent residents — the ones who are already home. Final wording comes from the owner.',
    },
    apply: {
      title: 'Adoption application',
      intro:
        '[DRAFT] A warm note about what happens after you apply — we read everything and reply by email. Final wording comes from the owner.',
    },
    // §10 form privacy note — shown under both forms
    formPrivacyNote:
      'Anything you submit goes straight to our inbox. It is never shared or sold.',
  },
} as const;
