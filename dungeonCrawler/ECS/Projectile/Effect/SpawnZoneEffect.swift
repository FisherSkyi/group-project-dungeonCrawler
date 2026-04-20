import Foundation

/// Spawns a persistent damage zone at the impact position.
public struct SpawnZoneEffect: ProjectileHitEffect {
    public let textureName: String
    public let radius: Float
    public let duration: Float
    public let hitEffects: [any ProjectileHitEffect]

    public init(
        textureName: String,
        radius: Float,
        duration: Float,
        hitEffects: [any ProjectileHitEffect]
    ) {
        self.textureName = textureName
        self.radius = radius
        self.duration = duration
        self.hitEffects = hitEffects
    }

    public func apply(context: HitContext) {
        SpecialEffectZoneEntityFactory(
            textureName: textureName,
            radius: radius,
            hitEffects: hitEffects,
            duration: duration,
            position: context.center
        ).make(in: context.world)
    }
}
