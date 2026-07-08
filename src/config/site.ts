/**
 * Central static-site config (brief §9): ALL static copy, links, and §11
 * config values live here. Swapping placeholder → final means editing THIS
 * file only — never hunt through templates.
 *
 * Copy status: written from the owner's own words (interview + her welcome
 * paragraph, 2026-07-08) — pending her review at the phase 4 gate.
 * Remaining temporaries are marked [TEMP] and tracked in progress.md.
 */
export const site = {
  name: "Charlie's Animal Sanctuary",
  location: 'Peterborough, ON', // city only — never a street address (brief §12)
  email: 'CharliesAnimalSanctuary@gmail.com',

  description:
    "Charlie's Animal Sanctuary is a small animal rescue in Peterborough, ON — taking in cats and dogs, giving them vet care and time to heal, and matching them with the right homes.",

  nav: [
    { label: 'Home', href: '/' },
    { label: 'About', href: '/about' },
    { label: 'Adopt', href: '/adopt' },
    { label: 'Our Family', href: '/family' },
    { label: 'Intake', href: '/intake' },
    { label: 'Contact', href: '/contact' },
  ],

  // [TEMP] owner-provided placeholder PayPal link — replace with the real
  // donation link before launch (tracked in progress.md)
  donateUrl: 'https://www.paypal.com/paypalme/lilycharlestwitch',

  // Web3Forms access key (from .env locally; Cloudflare Pages env at phase 5).
  // Empty key ⇒ forms render with a "not wired" notice.
  web3formsKey: import.meta.env.PUBLIC_WEB3FORMS_KEY ?? '',

  // [TEMP] owner-provided placeholder video — replace with the real "our
  // story" video before launch (tracked in progress.md)
  youtubeStoryVideoId: '7zB-pkw2B4U',

  social: {
    instagram: 'https://www.instagram.com/charliesanimalsanctuary/',
    youtube: 'https://www.youtube.com/@CharliesAnimalSanctuary',
    facebook: 'https://www.facebook.com/people/Charlies-Animal-Sanctuary/61581016065923/',
  },

  copy: {
    home: {
      heroHeadline: 'Small rescue. Big dream.',
      heroSub:
        "We take in cats and dogs around Peterborough, give them vet care and time to heal, and match them with the homes they deserve. We're starting small — one person, a few animals at a time — but the dream is a full farm sanctuary where rescues live out their lives in peace.",
      featuredHeading: 'Looking for a home',
      videoHeading: 'Watch our story',
      instagramHeading: 'Follow along on Instagram',
      donateHeading: 'Help us help them',
      donateSub:
        'The sanctuary runs on one person, funded by content creation, adoption fees — and people like you. Every donation helps.',
    },

    about: {
      title: 'About us',
      intro:
        'Welcome to Charlie’s Animal Sanctuary. This rescue is named in honour of my heart horse Charlie — the one who taught me patience, compassion, and the true meaning of unconditional love. Everything the sanctuary stands for begins with him.',
      sections: [
        {
          heading: 'Charlie',
          paragraphs: [
            'Charlie was my first horse, and we were together for thirteen years. He was a sweet boy with a rough past, and it took a long time to earn his trust — but once I had it, he would follow me anywhere. He was sensitive, funny, and magnificently dramatic: a thrown shoe was a medical emergency, a fly was the end of the world. When he acted like royalty, I called him Sir Charles.',
            'People used to say he was lucky to have found someone who would put up with his antics. I don’t think that’s true. I think we were both lucky.',
            'Charlie was boarded at a facility, and I always wanted him at home with me — I promised him that someday it would happen. He’s no longer here — but the sanctuary carries his name, and when the farm finally exists, he’ll be there in spirit.',
          ],
        },
        {
          heading: 'How the rescue works',
          paragraphs: [
            'When an animal comes into the rescue, vet care comes first: a full health exam, vaccines, parasite control — whatever they need. Then comes the part that can’t be rushed: time and space to decompress. Animals arrive tired, because they’ve been busy surviving.',
            'I work from home, so they get company on their own terms — quiet time, treats, and a slightly obnoxious baby voice until they decide I’m alright. They set the pace, always. Dogs get walks, trails, and new toys; kittens get a lap that doesn’t grab.',
            'By the time an animal is ready for adoption, I know them — their personality, their quirks, their challenges. That’s what makes it possible to match them with the right home, and it’s what gives them the best chance at their perfect fit.',
          ],
        },
        {
          heading: 'The dream',
          paragraphs: [
            'One day, this will be a full farm sanctuary — a place where, alongside the cats and dogs, there’s room for horses, goats, pigs, ducks, chickens, and any farm animal that needs help. That’s the promise this whole thing is built on.',
          ],
        },
        {
          heading: 'The person behind it',
          paragraphs: [
            'I’m Katheryn. My first word was "kitty," and it’s been more or less downhill from there: a lifetime of riding and rescuing, a degree in Animal Biology, and years working in shelters, kennels, and farms.',
            'Whenever there’s an animal in need, I have to help — it’s just part of me. This is what I’m meant to do.',
          ],
        },
      ],
    },

    intake: {
      title: 'Intake & surrender',
      intro:
        'Found a stray, or know an animal that needs help? Tell me what’s going on: where the animal is, what kind of animal it is, any health concerns, and roughly how old they are if you know. If I have the space and the ability to help, we’ll go from there — and if I can’t take them in, I’ll do my best to point you to someone who can.',
      note:
        'One thing to know: the sanctuary is one person with limited space, so intake is never guaranteed — it comes down to space and the ability to help.',
      steps: [
        'Fill out the form below with as much detail as you can.',
        'It goes straight to my inbox, and I’ll get back to you by email.',
        'If I can help, we arrange next steps together. If I can’t, I’ll try to point you to other resources.',
      ],
      formHeading: 'Tell me about the animal',
    },

    contact: {
      title: 'Contact',
      intro:
        'Questions about adopting, donating — or just want to say hi? Send a message and it goes straight to my inbox.',
      formHeading: 'Send a message',
    },

    adopt: {
      title: 'Adopt',
      intro:
        'Every animal here has had their vet care, had time to settle in, and been loved on enough that I can tell you exactly who they are. If one of them feels right, apply — and we’ll see if it’s a match.',
      // §5 empty-state microcopy (wording from the brief)
      emptyMessage:
        'No animals are looking for homes right now — follow along on Instagram, or check back soon.',
      happyTailsHeading: 'Happy Tails',
      happyTailsBlurb: 'The ones who made it home. This list only ever gets longer.',
    },

    family: {
      title: 'Our family',
      intro:
        'These are the permanent residents — the ones who are already home. They run the place, supervise the fosters, and keep me humble.',
      memorialHeading: 'Forever in our hearts',
      memorialBlurb: 'With us in spirit, always.',
    },

    apply: {
      title: 'Adoption application',
      intro:
        'Fill this out and it lands straight in my inbox. By the time an animal is ready for adoption I know them well, and the goal is always the right match — so the more you share, the better.',
    },

    // §10 form privacy note — shown under every form
    formPrivacyNote:
      'Anything you submit goes straight to our inbox. It is never shared or sold.',
    formSuccessNote: 'Got it — thank you. It’s in my inbox.',
    formErrorNote:
      'That didn’t go through — sorry. Please try again in a minute, or email us directly at',
  },
} as const;
