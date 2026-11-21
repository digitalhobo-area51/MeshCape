// Central place for values that change. Edit here and every page updates.
// Anything marked TBC is still to be confirmed before launch.

export const site = {
  name: 'MeshCape',
  tagline: 'MeshCore community · Cape Town',
  region: 'Cape Town, ZA',
  url: 'https://meshcape.io',
  wikiUrl: 'https://wiki.meshcape.io',
  revision: 'A · DRAFT',
  contact: '[EMAIL / CHAT LINK]', // TBC
  contentLicence: 'CC BY 4.0',
};

// Table 1 — community radio preset. TBC until agreed and checked against
// ICASA's licence-exempt 868 MHz rules.
export const radio = {
  confirmed: false,
  frequencyMHz: 'TBC',
  bandwidthKHz: 'TBC',
  spreadingFactor: 'TBC',
  codingRate: 'TBC',
};

export const nav = [
  { href: '/', label: 'Home' },
  { href: '/get-started/', label: 'Get started' },
  { href: '/settings/', label: 'Settings' },
  { href: '/home-assistant/', label: 'Home Assistant' },
  { href: '/links/', label: 'Links' },
];

export const apps = {
  android: 'https://play.google.com/store/apps/details?id=com.liamcottle.meshcore.android',
  ios: 'https://apps.apple.com/gb/app/meshcore/id6742354151',
};

// href: null shows the card as "link to come".
export const references = [
  { id: 'A', title: 'Official MeshCore', note: 'Project home, docs and web flasher', href: 'https://meshcore.co.uk' },
  { id: 'B', title: 'MeshCore on GitHub', note: 'Firmware source and releases', href: 'https://github.com/meshcore-dev/MeshCore' },
  { id: 'C', title: 'World node map', note: 'Link to come', href: null },
  { id: 'D', title: 'MeshCore Discord', note: 'Link to come', href: null },
  { id: 'E', title: 'MeshCore Switzerland', note: 'Sister community', href: 'https://www.meshcore.ch/?lang=en' },
  { id: 'F', title: 'SA Mesh wiki (AU)', note: "South Australia's build notes", href: 'https://wiki.samesh.au' },
];

export const wikiSections = [
  'Start here',
  'Cape Town region & coverage',
  'Recommended settings',
  'Companion nodes',
  'Repeaters & deployment checklist',
  'Hardware builds',
  'Home Assistant integration',
  'Troubleshooting',
];
