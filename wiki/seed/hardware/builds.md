---
title: Hardware builds
description: Boards, antennas, enclosures and power builds — plus the template for writing up your own
published: true
date: 2026-11-21T00:00:00.000Z
tags: hardware, builds, template
editor: markdown
dateCreated: 2026-11-21T00:00:00.000Z
---

# Hardware builds

Write-ups of real builds by members. Good builds to share: a first companion that worked well, a portable field kit, a repeater enclosure, solar/battery setups, antenna and mounting examples — and builds that **didn't** work, so others can avoid them.

## Builds

| Build | Type | Board | Status |
| --- | --- | --- | --- |
| [Heltec V4 — first companion node](/hardware/heltec-v4-companion) | Companion | Heltec WiFi LoRa 32 V4 | in use |
| *add yours* | | | |

## Boards tested locally

Only list boards someone in Cape Town has actually used. Buy the **868 MHz** (or 863–928 MHz) version — not 433 MHz or 915-only.

| Board | Tested by | Roles used | Notes |
| --- | --- | --- | --- |
| Heltec WiFi LoRa 32 V4 (863–928 MHz) | @rob | Companion | Built-in screen, USB-C, Wi-Fi + BLE |
| *add yours* | | | |

## Build template

Copy everything below into a new page under `/hardware/`.

```markdown
# Build name

## Purpose
What this build is for and where it's used.

## Parts
- Board:
- Firmware / role:  (companion BLE / USB / Wi-Fi, or repeater)
- Firmware version:
- Antenna:
- Enclosure:
- Power:
- Mounting:

## Setup notes
Flashing, wiring, configuration and mounting details.

## Test results
How it was tested, where, and what it reached (areas, not addresses).

## Limitations
Battery life, range, weather, maintenance — anything someone copying it should know.

## Photos
```
