//
//  EnemyInputSystem.swift
//  dungeonCrawler
//
//  Created by Jannice Suciptono on 14/4/26.
//

import Foundation
import simd
 
/// Drives the InputComponent on enemies each frame so that WeaponSystem
/// can fire their weapons without any changes to WeaponSystem itself.
///
/// Run order: after EnemyAISystem, before WeaponSystem.
/// EnemyAISystem decides *which* behaviour is active; this system translates
/// that into the shoot intent that WeaponSystem already knows how to consume.
public final class EnemyInputSystem: System {
    public var dependencies: [System.Type] { [EnemyAISystem.self] }
 
    public init() {}
 
    public func update(deltaTime: Double, world: World) {
        guard let (_, _, playerTransform) = world.entities(
            with: PlayerTagComponent.self, and: TransformComponent.self
        ).first else { return }
 
        let playerPos = playerTransform.position
 
        for (enemy, input, transform, _) in world.entities(
            with: InputComponent.self,
            and: TransformComponent.self,
            and: EnemyTagComponent.self
        ) {
            // Don't fire while being knocked back
            guard world.getComponent(type: KnockbackComponent.self, for: enemy) == nil else {
                input.isShooting = false
                input.aimDirection = .zero
                continue
            }
 
            let delta = playerPos - transform.position
            let distSquared = simd_length_squared(delta)
 
            if distSquared > 1e-6 {
                input.aimDirection = simd_normalize(delta)
            } else {
                input.aimDirection = .zero
            }
 
            // isShooting is always true while this behaviour is active —
            // WeaponSystem handles the cooldown gating
            input.isShooting = true
 
            // Keep FacingComponent in sync so the weapon sprite mirrors correctly
            if let facing = world.getComponent(type: FacingComponent.self, for: enemy) {
                if let aimFacing = FacingType.from(vector: input.aimDirection) {
                    facing.facing = aimFacing
                }
            }
        }
    }
}
