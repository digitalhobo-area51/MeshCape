---
title: Repeaters
description: Fixed MeshCore repeaters — the backbone of the Cape Town mesh
published: true
date: 2026-11-21T00:00:00.000Z
tags: repeaters, infrastructure
editor: markdown
dateCreated: 2026-11-21T00:00:00.000Z
---

# Repeaters

A **repeater** is a node that runs MeshCore repeater firmware, sits somewhere high, and relays other people's packets. It has no phone attached and runs unattended. Repeaters are what let a message from Muizenberg reach Durbanville.

## Roles

Not every repeater needs to be on a mountain. Rough roles we use when planning:

| Role | Where | Job |
| --- | --- | --- |
| **Core** | Major high sites with wide line of sight | Link regions across the city |
| **Distribution** | Tall buildings, ridges | Connect a suburb to the core |
| **Infill / edge** | Rooftops, poles | Fill shadows behind hills and buildings |

More repeaters isn't always better: too many in one place that all hear each other just add airtime. Coordinate on the [region page](/cape-town/region) before adding one.

## Before you deploy

Work through the [deployment checklist](/repeaters/deployment-checklist). In short:

- Bench-test it at home first, on the [recommended settings](/settings/recommended).
- Plan power for winter and load-shedding (solar + battery sizing).
- Weatherproof everything; protect against lightning where exposed.
- Set a strong **admin password** and keep it private.

## Managing a repeater

Repeaters can be configured over USB serial or remotely from the app as admin. Record your configuration (without passwords) on the [region page](/cape-town/region) so others understand the network.

> **TODO:** add a CLI quick reference, checked against the official MeshCore docs for the current firmware version.
{.is-info}
