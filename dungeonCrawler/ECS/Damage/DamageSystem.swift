//
//  DamageSystem.swift
//  dungeonCrawler
//
//  Created by Jannice Suciptono on 29/3/26.
//

import Foundation

public final class DamageSystem: System {
    public let priority: Int = 40

    private let events: CollisionEventBuffer

    public init(events: CollisionEventBuffer) {
        self.events = events
    }

    public func update(deltaTime: Double, world: World) {
        for event in events.playerHitByEnemy {
            applyContactDamage(
                to: event.player,
                damage: event.damage,
                world: world
            )
        }
    }

    private func applyContactDamage(to entity: Entity, damage: Float, world: World) {
        guard world.isAlive(entity: entity) else { return }
        
        // Skip if entity is currently in invincibility frames
        guard world.getComponent(type: InvincibilityComponent.self, for: entity) == nil else { return }
 
        world.modifyComponent(type: HealthComponent.self, for: entity) { health in
            health.value.current -= damage
            health.value.clampToMin()
        }
 
        // Grant invincibility frames so the next collision hit doesn't immediately deal damage again
        world.addComponent(component: InvincibilityComponent(remainingTime: 0.5), to: entity)
    }
}
