---
title: "Design of Weapon Module"
description: "Design decisions and architecture of the Weapon module."
sidebar_position: 1
---

## Patterns

### Command pattern
Encapsulate a request as an object, allowing queueing, validation, cancellation, and replay independently of execution.

> Used in `FireCommand`,`ReloadCommand`, ..., `CommandQueue` `CommandValidationSystem`

Every player or AI action becomes a typed struct pushed onto the CommandQueue. This decouples the input layer from the execution layer completely. e.g. the AI does not call FiringSystem.fire(), it pushes a FireCommand. 

CommandValidationSystem acts as the guard, so no execution system ever needs to check ammo, mana, or cooldowns itself. 

CancelCommand lets you abort queued actions (e.g. cancel a reload on dodge roll) without touching the reload state machine.

### Observer pattern

> Used in `EventBus`, `ProjectileFiredEvent`, `DamageAppliedEvent`, ...

We have Event Bus to handle one-to-many dependency so systems never call each other directly. 

e.g. FiringSystem publishes ProjectileFiredEvent; ResourceSystem, AnimSystem, and AudioSystem all subscribe independently. 

Adding a new subscriber (e.g. AchievementSystem listening for WeaponBrokenEvent) requires zero changes to existing systems.

### State Machine Pattern

