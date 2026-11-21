---
title: Companion nodes
description: Your personal MeshCore node that pairs with your phone
published: true
date: 2026-11-21T00:00:00.000Z
tags: companion, getting-started
editor: markdown
dateCreated: 2026-11-21T00:00:00.000Z
---

# Companion nodes

A **companion** is your personal node. It runs MeshCore companion firmware and connects to the MeshCore app on your phone or computer, which is where you read and send messages. Start here before thinking about repeaters.

## Ways to connect

| Firmware variant | Connects by | Good for |
| --- | --- | --- |
| Companion — Bluetooth (BLE) | Phone app over Bluetooth | Carrying around, everyday use |
| Companion — USB | Cable to a computer | Desk use, web/desktop clients |
| Companion — Wi-Fi | Your home network (TCP) | Fixed home node, [Home Assistant](/home-assistant) |

Pick the variant when you flash the firmware. Check the official flasher for which variants exist for your board.

## First-time setup

1. **Attach the antenna** before powering on.
2. Flash companion firmware using the official web flasher (Chrome or Edge, USB cable). See [Hardware builds](/hardware/builds) for board-specific notes, e.g. [Heltec V4](/hardware/heltec-v4-companion).
3. Install the MeshCore app ([Android](https://play.google.com/store/apps/details?id=com.liamcottle.meshcore.android) · [iOS](https://apps.apple.com/gb/app/meshcore/id6742354151)) and connect to your node.
4. Set a **node name** people will recognise (avoid your full name or address).
5. Apply the [recommended settings](/settings/recommended).
6. Send an **advert** so others' devices learn about you, then say hello on the public channel.

## Tips

- Height beats power: a node on a windowsill upstairs will hear far more than one in a pocket.
- Keep the antenna vertical and clear of metal.
- If you hear nothing, see [Troubleshooting](/troubleshooting).
