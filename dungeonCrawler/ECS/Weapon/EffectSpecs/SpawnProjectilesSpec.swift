//
//  SpawnProjectilesSpec.swift
//  dungeonCrawler
//
//  Created by Letian on 9/4/26.
//

import Foundation
import simd

struct SpawnProjectilesSpec: Spec {
    let speed: Float
    let effectiveRange: Float
    let damage: Float
    let spriteName: String
    let collisionSize: SIMD2<Float>

    func turnIntoEffect() -> any WeaponEffect {
        return SpawnProjectileEffect(
            speed: sp, effectiveRange: effectiveRange,
            damage: damage, spriteName: spriteName,
            collisionSize: <#T##SIMD2<Float>#>)
    }
}
