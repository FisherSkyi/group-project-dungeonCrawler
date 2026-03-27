//
//  WanderStrategy.swift
//  dungeonCrawler
//
//  Created by Wen Kang Yap on 27/3/26.
//

import Foundation
import simd

/// A strategy that Enemy will wander around by choosing a random point within the wanderRadius
/// Simple AI movement when Player is not in range
public final class WanderStrategy: EnemyAIStrategy {

    public var wanderRadius: Float
    public var wanderSpeed: Float
    private var wanderTarget: SIMD2<Float>?

    public init(wanderRadius: Float = 100, wanderSpeed: Float = 40) {
        self.wanderRadius = wanderRadius
        self.wanderSpeed = wanderSpeed
    }

    // entity refers to Enemy here and the transform is the enemy's transform
    public func update(entity: Entity, transform: TransformComponent, playerPos: SIMD2<Float>, world: World) {
        let arrivalThreshold: Float = 8

        if wanderTarget == nil ||
            simd_length(transform.position - wanderTarget!) < arrivalThreshold {
            let angle = Float.random(in: 0..<(2 * .pi))
            let radius = Float.random(in: 0...wanderRadius)
            wanderTarget = transform.position +
                SIMD2(cos(angle) * radius, sin(angle) * radius)
        }

        guard let target = wanderTarget else { return }

        let wanderDelta = target - transform.position
        guard simd_length_squared(wanderDelta) > 1e-6 else { return }

        world.modifyComponent(type: VelocityComponent.self, for: entity) { vel in
            vel.linear = normalize(wanderDelta) * self.wanderSpeed
        }
    }
}
