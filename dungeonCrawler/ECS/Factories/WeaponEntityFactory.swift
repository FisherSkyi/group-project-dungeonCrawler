//
//  WeaponEntityFactory.swift
//  dungeonCrawler
//
//

import Foundation
import simd

public struct WeaponEntityFactory: EntityFactory {
    let player: Entity?
    let textureName: String
    let offset: SIMD2<Float>
    let scale: Float
    let lastFiredAt: Float
    let coolDownIntervel: TimeInterval?
    let attackSpeed: Float?
    let effects: [any WeaponEffect]
    let anchorPoint: SIMD2<Float>
    let initRotation: Float
    var initLocation: SIMD2<Float>? = nil

    public init(player: Entity?, spec: WeaponDefinition) {
        self.player = player
        self.textureName = spec.textureName
        self.offset = spec.offset
        self.scale = spec.scale
        self.lastFiredAt = spec.lastFiredAt ?? 0
        self.coolDownIntervel = spec.cooldown
        self.attackSpeed = spec.attackSpeed
        self.effects = spec.effects
        self.anchorPoint = spec.anchorPoint ?? SIMD2<Float>(0.5, 0.5)
        self.initRotation = spec.initRotation ?? 0
        self.initLocation = spec.initLocation
    }

    /// Components include:
    /// Transform Component
    /// Facing Component
    /// Owner Component
    /// Weapon Timing Component
    /// Weapon Effects Component
    /// Weapon Render Component
    @discardableResult
    public func make(in world: World) -> Entity {
        let entity = world.createEntity()
        
        var startPos: SIMD2<Float>? = nil
        if let player = player {
            startPos = world.getComponent(type: TransformComponent.self, for: player)?.position ?? .zero
            let ownerFacing = world.getComponent(type: FacingComponent.self, for: player)?.facing ?? .right
            world.addComponent(component: FacingComponent(facing: ownerFacing), to: entity)
            world.addComponent(component: OwnerComponent(ownerEntity: player, offset: offset), to: entity)
        }
        let weaponPosition = startPos ?? self.initLocation ?? { fatalError("No location for weapon") }()
        world.addComponent(
            component: TransformComponent(
                position: weaponPosition + offset,
                rotation: initRotation,
                scale: scale),
            to: entity
        )
        world.addComponent(
            component: WeaponTimingComponent(
                lastFiredAt: lastFiredAt,
                coolDownInterval: coolDownIntervel,
                attackSpeed: attackSpeed),
            to: entity)
        world.addComponent(
            component: WeaponRenderComponent(
                textureName: textureName,
                anchorPoint: anchorPoint,
                initRotation: initRotation
            ),
            to: entity
        )
        world.addComponent(component: WeaponEffectsComponent(effects: effects), to: entity)

        return entity
    }
}
