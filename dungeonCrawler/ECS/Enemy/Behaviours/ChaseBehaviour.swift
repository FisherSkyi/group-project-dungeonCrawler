//
//  ChaseBehaviour.swift
//  dungeonCrawler
//
//  Created by Wen Kang Yap on 9/4/26.
//

import Foundation
import simd

/// Moves the enemy directly toward the player at a fixed speed.
public struct ChaseBehaviour: EnemyBehaviour {

    public var speed: Float

    public init(speed: Float = 70) {
        self.speed = speed
    }

    public func update(entity: Entity, context: BehaviourContext) {
        let delta = context.playerPos - context.transform.position
        guard simd_length_squared(delta) > 1e-6 else { return }

        context.world.modifyComponentIfExist(type: VelocityComponent.self, for: entity) { vel in
            vel.linear = normalize(delta) * self.speed
        }
    }
}
