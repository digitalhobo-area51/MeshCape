---
title: Home Assistant integration
description: Connecting a Wi-Fi MeshCore companion node to Home Assistant
published: true
date: 2026-11-21T00:00:00.000Z
tags: home-assistant, integration, wifi
editor: markdown
dateCreated: 2026-11-21T00:00:00.000Z
---

# Home Assistant integration

A MeshCore companion node running **Wi-Fi firmware** sits on your home network and accepts TCP connections. Home Assistant can connect to it and turn the mesh into sensors and events.

```
LoRa mesh  ⇄  MeshCore node (Wi-Fi, TCP)  ⇄  Home Assistant  →  automations
```

## What you can do

- Log public-channel and direct messages
- Track node battery, signal and last-heard times
- Trigger automations from mesh messages

## What you need

- A board with Wi-Fi (e.g. [Heltec V4](/hardware/heltec-v4-companion)) flashed with the **companion — Wi-Fi** firmware variant
- The node joined to your Wi-Fi with a **fixed IP** (DHCP reservation on your router)
- Home Assistant on the same network
- The Home Assistant MeshCore integration — **TODO:** name, install method (e.g. HACS) and link

## Setup

> **TODO (Rob):** write up the working setup — integration install, connection settings, entities created, and an example automation.
{.is-info}

1. Flash the Wi-Fi companion firmware and join the node to your network.
2. Confirm the MeshCore app can connect to the node over IP.
3. Install the Home Assistant integration.
4. Add the integration and point it at the node's IP address and TCP port.
5. Check the entities that appear and build automations.

## Privacy

When posting screenshots or config here, **remove** local IP addresses, tokens, your Home Assistant URL and your node's exact location.
