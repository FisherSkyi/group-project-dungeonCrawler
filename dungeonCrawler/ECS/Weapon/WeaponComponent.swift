import Foundation
import simd

typealias FireBehaviour = (WeaponComponent, SIMD2<Float>, SIMD2<Float>, Entity, World) -> Void

public struct WeaponComponent: Component {
    var type: WeaponType
    var fireBehaviour: FireBehaviour
    var damage: Float
    var manaCost: Float
    var attackSpeed: Float
    var coolDownInterval: TimeInterval
    var lastFiredAt: Float = 0

    // @escaping as the closure outlive init function call
    init(type: WeaponType,
         fireBehaviour: @escaping FireBehaviour,
         damage: Float,
         manaCost: Float,
         attackSpeed: Float,
         coolDownInterval: TimeInterval,
         lastFiredAt: Float = 0) {
        self.type = type
        self.fireBehaviour = fireBehaviour
        self.damage = damage
        self.manaCost = manaCost
        self.attackSpeed = attackSpeed
        self.coolDownInterval = coolDownInterval
        self.lastFiredAt = lastFiredAt
    }
}
