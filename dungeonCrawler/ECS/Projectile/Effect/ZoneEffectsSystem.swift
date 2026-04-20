//
//  ZoneEffectsSystem.swift
//  dungeonCrawler
//
//  Created by Letian on 11/4/26.
//

import Foundation

public final class ZoneEffectsSystem: System {

    private let destructionQueue: DestructionQueue

    public init(destructionQueue: DestructionQueue) {
        self.destructionQueue = destructionQueue
    }

    public func update(deltaTime: Double, world: World) {
        let dt = Float(deltaTime)
        let enemies = world.entities(with: EnemyTagComponent.self)
        let players = world.entities(with: PlayerTagComponent.self)
        let targets = enemies + players

        for zoneEntity in world.entities(with: ZoneComponent.self) {
            guard let zone = world.getComponent(type: ZoneComponent.self, for: zoneEntity) else { continue }
            zone.elapsed += dt
            if zone.elapsed >= zone.duration {
                destructionQueue.enqueue(zoneEntity)
                continue
            }
            guard let zoneTransform = world.getComponent(type: TransformComponent.self, for: zoneEntity) else { continue }
            let zonePos = zoneTransform.position
            let radiusSq = zone.radius * zone.radius

            for target in targets {
                guard let targetPos = world.getComponent(type: TransformComponent.self, for: target) else { continue }
                let diff = targetPos.position - zonePos
                guard (diff.x * diff.x + diff.y * diff.y) <= radiusSq else { continue }
                let context = HitContext(center: zonePos, world: world, target: target)
                for effect in zone.hitEffects {
                    effect.apply(context: context)
                }
            }
        }
        destructionQueue.flush(world: world)
    }
}
