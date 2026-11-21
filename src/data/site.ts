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

// Table 1 — community radio preset for South Africa.
// 869.618 MHz ± 31.25 kHz = 869.587–869.649 MHz, inside ICASA's licence-free
// 868 MHz ISM sub-band 869.4–869.65 MHz.
export const radio = {
  confirmed: true,
  appPreset: 'EU/UK (Narrow)',
  frequencyMHz: '869.618',
  bandwidthKHz: '62.5',
  spreadingFactor: '8',
  codingRate: '8',
  codingRateRatio: '4/8',
  dutyCycle: '10%',
  band: '869.4–869.65 MHz',
};

/** Menu items. External links open in a new tab. */
export const nav: { href: string; label: string; external?: boolean }[] = [
  { href: '/', label: 'Home' },
  { href: '/#get-started', label: 'Get Started' },
  { href: 'https://meshcore.io/', label: 'Official MeshCore Site', external: true },
  { href: 'https://wiki.meshcape.io', label: 'Local Community Wiki', external: true },
  { href: 'https://map.meshcore.io/?lat=-33.5379&lon=19.2532&zoom=8', label: 'Dynamic Mesh Map', external: true },
];

/** Link to a page on the wiki, e.g. wiki('/hardware/builds'). */
export const wiki = (path = '') => `${site.wikiUrl}${path}`;

// Community channels. href: null hides the button until the link exists.
export const channels = [
  { label: 'Wiki', note: 'Guides anyone can edit', href: wiki() },
  { label: 'Chat group', note: 'Day-to-day chat — link to come', href: null },
  { label: 'GitHub', note: 'Source for this site', href: 'https://github.com/digitalhobo-area51/meshcape' },
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

// Paths match the starter pages in wiki/seed/.
export const wikiSections = [
  { title: 'Start here', path: '/' },
  { title: 'Cape Town region & coverage', path: '/cape-town/region' },
  { title: 'Recommended settings', path: '/settings/recommended' },
  { title: 'Companion nodes', path: '/companion' },
  { title: 'Repeaters & deployment checklist', path: '/repeaters' },
  { title: 'Hardware builds', path: '/hardware/builds' },
  { title: 'Home Assistant integration', path: '/home-assistant' },
  { title: 'Troubleshooting', path: '/troubleshooting' },
];
