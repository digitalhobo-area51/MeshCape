---
title: Troubleshooting
description: Common MeshCore problems and what to check first
published: true
date: 2026-11-21T00:00:00.000Z
tags: troubleshooting, help
editor: markdown
dateCreated: 2026-11-21T00:00:00.000Z
---

# Troubleshooting

## I can't see anyone on the mesh

Work down the list — most problems are the first two.

1. **Radio settings don't match.** Frequency, bandwidth, spreading factor and coding rate must all match the [recommended settings](/settings/recommended) exactly.
2. **Wrong hardware band.** Check your board is the 868 MHz (or 863–928 MHz) version.
3. **Antenna.** Is it attached, tight, vertical, and the right band? A 433 MHz or 2.4 GHz antenna won't work.
4. **Location.** Indoors, low down, or behind a hill you may simply be out of range. Try upstairs, a window, or outside.
5. **Send an advert.** Others only learn about your node when it advertises.
6. **Nobody nearby yet.** Check the [region page](/cape-town/region) for repeaters in your area.

## The app won't connect to my node

- **Bluetooth:** make sure the node is flashed with the *Bluetooth* companion variant, it's powered, and not already connected to another phone. Remove old pairings and retry.
- **Wi-Fi:** check the node is on your network and you're using the right IP; a DHCP reservation stops the address changing.
- **USB:** use a data-capable cable and Chrome or Edge.

## Messages send but don't arrive

- The recipient may be out of range of any repeater.
- Very busy periods cause collisions — wait and retry rather than resending repeatedly.

## Still stuck?

Add your question to this page's comments with: board, firmware variant and version, your settings, and your rough area.

> **TODO:** add more problems as we meet them.
{.is-info}
