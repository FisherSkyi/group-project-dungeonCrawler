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
                id: "sword",
                textureName: "sword",
                offset: SIMD2<Float>(12, -6),
                scale: 0.3,
                cooldown: 0.5,
                attackSpeed: 1,
                anchorPoint: SIMD2<Float>(0.1, 0.5),
                initRotation: .pi / 9,
                tags: ["melee"],
                config: [
                    "damage": .float(50),
                    "range": .float(100),
                    "halfAngleDegrees": .float(90),
                    "maxTargets": .int(1),
                    "swingDuration": .float(0.3),
                    "swingAngleDegrees": .float(40)
                ]
            )
        case .sniper:
            return WeaponDefinition(
                id: "sniper",
                textureName: "Sniper",
                offset: SIMD2<Float>(10, -5),
                scale: WorldConstants.standardEntityScale,
                cooldown: TimeInterval(0.8),
                attackSpeed: 1,
                anchorPoint: nil,
                initRotation: nil,
                tags: ["projectile", "usesMana"],
                config: [
                    "manaCost": .float(20),
                    "projectileSpeed": .float(400),
                    "effectiveRange": .float(800),
                    "damage": .float(50),
                    "projectileSpriteName": .string("normalHandgunBullet"),
                    "collisionSize": .vector2(SIMD2<Float>(6, 6))
                ]
            )
        }
    }
}
