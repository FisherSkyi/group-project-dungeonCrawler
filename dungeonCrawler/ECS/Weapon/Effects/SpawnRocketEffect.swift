import Foundation
import simd

struct SpawnRocketEffect: WeaponEffect {
    let speed: Float
    let effectiveRange: Float
    let damage: Float
    let spriteName: String
    let collisionSize: SIMD2<Float>
    let gravity: Float
    let launchAngle: Float

    init(
        speed: Float,
        effectiveRange: Float,
        damage: Float,
        spriteName: String,
        collisionSize: SIMD2<Float>,
        gravity: Float = 300,
        launchAngle: Float = .pi / 6
    ) {
        self.speed = speed
        self.effectiveRange = effectiveRange
        self.damage = damage
        self.spriteName = spriteName
        self.collisionSize = collisionSize
        self.gravity = gravity
        self.launchAngle = launchAngle
    }

    func apply(context: FireContext) -> FireEffectResult {
        let dir = simd_normalize(context.fireDirection)
        // Rotate the direction upward by launchAngle to create the initial arc
        let cosA = cos(launchAngle)
        let sinA = sin(launchAngle)
        let loftedDir = SIMD2<Float>(
            dir.x * cosA - dir.y * sinA,
            dir.x * sinA + dir.y * cosA
        )

        let entity = ProjectileEntityFactory(
            from: context.firePosition,
            aimAt: loftedDir,
            speed: speed,
            effectiveRange: effectiveRange,
            damage: damage,
            owner: context.owner,
            spriteName: spriteName,
            collisionBoxSize: collisionSize
        ).make(in: context.world)

        context.world.addComponent(
            component: GravityComponent(gravity: gravity),
            to: entity
        )

        return .success
    }
}
