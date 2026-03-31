//
//  FiringBehaviors.swift
//  dungeonCrawler
//
//  Created by Letian on 31/3/26.
//

import Foundation
import simd

enum FiringBehaviors {
    static let singleShot: FireBehaviour = { weapon, fireDirection, spawnPosition, owner, world in
        ProjectileEntityFactory(
            from: spawnPosition,
            aimAt: fireDirection,
            speed: 300,
            effectiveRange: 400,
            damage: weapon.damage,
            owner: owner
        ).make(in: world)
    }
}
