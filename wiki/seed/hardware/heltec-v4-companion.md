---
title: Heltec V4 — first companion node
description: A simple first MeshCore companion build on the Heltec WiFi LoRa 32 V4
published: true
date: 2026-11-21T00:00:00.000Z
tags: hardware, companion, heltec
editor: markdown
dateCreated: 2026-11-21T00:00:00.000Z
---

# Heltec V4 — first companion node

## Purpose

A pocket or desk node that pairs with your phone — the simplest way onto the Cape Town mesh.

## Parts

- **Board:** Heltec WiFi LoRa 32 V4, 863–928 MHz version
- **Firmware / role:** MeshCore companion (Bluetooth or Wi-Fi)
- **Firmware version:** TODO
- **Antenna:** TODO (stock / upgraded — model)
- **Enclosure:** TODO
- **Power:** USB-C, or a 1S LiPo on the battery connector
- **Mounting:** n/a

## Setup notes

1. Screw the antenna on **before** connecting power.
2. Open the official MeshCore web flasher in Chrome or Edge, connect the board by USB-C, choose the Heltec V4 and the companion variant you want.
3. Open the MeshCore app and connect to the node (Bluetooth, or Wi-Fi/TCP for the Wi-Fi variant).
4. Set your node name and apply the [recommended settings](/settings/recommended).
5. Send an advert and a test message on the public channel.

> Never transmit without an antenna attached — it can damage the radio.
{.is-warning}

## Test results

TODO — where you tested and which repeaters or nodes you reached (areas only).

## Limitations

TODO — battery life on LiPo, range with the stock antenna, case options.
