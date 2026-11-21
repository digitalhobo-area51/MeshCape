---
title: Recommended settings
description: The South African MeshCore radio preset used by MeshCape — EU/UK (Narrow), 869.618 MHz
published: true
date: 2026-11-21T00:00:00.000Z
tags: settings, radio, preset, icasa
editor: markdown
dateCreated: 2026-11-21T00:00:00.000Z
---

# Recommended settings

Every node on a MeshCore mesh must use **identical radio settings** — frequency, bandwidth, spreading factor and coding rate — or it won't hear the others. These are the settings used in South Africa, and on the MeshCape mesh.

## The preset

> In the MeshCore app, open your node's radio settings and choose the **EU/UK (Narrow)** preset. It sets all of the values below.
{.is-success}

| Parameter | Value |
| --- | --- |
| App preset | **EU/UK (Narrow)** |
| Frequency | **869.618 MHz** |
| Bandwidth (BW) | **62.5 kHz** |
| Spreading factor (SF) | **8** |
| Coding rate (CR) | **8** (4/8) |
| Duty cycle | **10%** |

## Why it's legal here

This falls inside ICASA's **licence-free 868 MHz ISM sub-band, 869.4–869.65 MHz**. With 62.5 kHz bandwidth centred on 869.618 MHz, the signal occupies roughly 869.587–869.649 MHz — inside the sub-band edges.

- **Duty cycle 10%:** a device may transmit for at most 10% of the time. MeshCore's short packets at SF8 keep normal use well within this; it matters most for busy repeaters.
- **Power:** keep total radiated power within ICASA's limit for this sub-band, including antenna gain. High-gain antennas on repeaters may need lower transmit power.

> **TODO:** add the ICASA regulation's title, version and link, and the maximum power figure for this sub-band, for reference.
{.is-info}

## What each setting does

- **Frequency** — where in the band we transmit. The whole signal (centre ± half the bandwidth) must stay inside the licence-free allocation.
- **Bandwidth** — narrower bandwidth improves sensitivity (range) but slows transmissions.
- **Spreading factor** — higher SF gives more range but much longer airtime per packet, which means more collisions and more duty cycle used. SF8 is a balance suited to a busy city mesh.
- **Coding rate** — extra error correction. 4/8 is the most robust option, at the cost of slightly longer packets.

## Same as elsewhere

The same EU/UK (Narrow) preset is used by other communities — for example MeshCore Switzerland lists 869.618 MHz / 62.5 kHz / SF8 / CR8 — so radios set up abroad work here out of the box.

## Decision record

| Date | Decision | Notes |
| --- | --- | --- |
| 2026-11-21 | Adopt EU/UK (Narrow): 869.618 MHz, BW 62.5 kHz, SF8, CR8, 10% duty cycle | Within ICASA 869.4–869.65 MHz licence-free sub-band |
