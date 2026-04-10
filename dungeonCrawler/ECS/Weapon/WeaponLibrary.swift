//
//  WeaponLibrary.swift
//  dungeonCrawler
//
//  Created by Letian on 9/4/26.
//

import Foundation

enum WeaponType: CaseIterable {
    case handgun
    case sword
    case sniper

    var definition: WeaponDefinition {
        switch self {
        case .handgun:
            return WeaponDefinition(
                textureName: "handgun",
                offset: SIMD2<Float>(10, -5),
                scale: WorldConstants.standardEntityScale,
                lastFiredAt: 0,
                cooldown: 0.2,
                attackSpeed: 1,
                effects: [
                    ConsumeManaEffect(amount: 5),
                    SpawnProjectileEffect(
                        speed: 300, effectiveRange: 400,
                        damage: 15, spriteName: "normalHandgunBullet",
                        collisionSize: SIMD2<Float>(6, 6)),
                ],
                anchorPoint: nil,
                initRotation: nil,
                initLocation: nil
            )
        case .sword:
            return WeaponDefinition(
                textureName: "sword",
                offset: SIMD2<Float>(12, -6),
                scale: 0.3,
                lastFiredAt: 0,
                cooldown: 0.5,
                attackSpeed: 1,
                effects: [
                    MeleeDamageEffect(
                        damage: 50, range: 100,
                        halfAngleDegrees: 90, maxTargets: 1,
                        swingDuration: 0.3, swingAngleDegrees: 40)
                ],
                anchorPoint: SIMD2<Float>(0.1, 0.5),
                initRotation: .pi / 9,
                initLocation: nil
            )
        case .sniper:
            return WeaponDefinition(
                textureName: "Sniper",
                offset: SIMD2<Float>(10, -5),
                scale: WorldConstants.standardEntityScale,
                lastFiredAt: 0,
                cooldown: TimeInterval(0.8),
                attackSpeed: 1,
                effects: [
                    ConsumeManaEffect(amount: 20),
                    SpawnProjectileEffect(
                        speed: 400, effectiveRange: 800,
                        damage: 50, spriteName: "normalHandgunBullet",
                        collisionSize: SIMD2<Float>(6, 6))
                ],
                anchorPoint: nil,
                initRotation: nil,
                initLocation: nil,
            )
        }
    }
}
