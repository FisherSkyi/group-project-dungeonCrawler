//
//  SpecialEffectEntityFactory.swift
//  dungeonCrawler
//
//  Created by Letian on 11/4/26.
//

import Foundation
import simd

public struct SpecialEffectZoneEntityFactory: EntityFactory {
    let textureName: String
    let radius: Float
    let hitEffects: [any ProjectileHitEffect]
    let duration: Float
    let position: SIMD2<Float>

    @discardableResult
    public func make(in world: World) -> Entity {
        let zone = world.createEntity()
        world.addComponent(
            component: ZoneComponent(radius: radius, hitEffects: hitEffects, duration: duration, elapsed: 0),
            to: zone
        )
        world.addComponent(component: SpriteComponent(content: .texture(name: textureName), layer: .zone), to: zone)
        world.addComponent(component: TransformComponent(position: position), to: zone)
        return zone
    }
}
