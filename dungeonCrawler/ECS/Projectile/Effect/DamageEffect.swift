
import Foundation

public struct DamageEffect: ProjectileHitEffect {
    private let amount: Float
    public init(amount: Float) {
        self.amount = amount
    }
    public func apply(context: HitContext) {
        guard let target = context.target, let hp = context.world.getComponent(type: HealthComponent.self, for: target) else { return }
        hp.value.current -= amount
    }
}
