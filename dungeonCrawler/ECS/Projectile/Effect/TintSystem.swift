import Foundation

public final class TintSystem: System {
    public var dependencies: [System.Type] { [] }
    public init() {}
    public func update(deltaTime: Double, world: World) {
        let dt = Float(deltaTime)
        for entity in world.entities(with: TintComponent.self) {
            guard let tint = world.getComponent(type: TintComponent.self, for: entity) else {continue}
            tint.remaining -= dt
            if tint.remaining <= 0 {
                world.getComponent(type: SpriteComponent.self, for: entity)?.tint = TintLibrary.defaultTint.tint
            } else {
                world.getComponent(type: SpriteComponent.self, for: entity)?.tint = tint.newTint
            }
        }
    }
}
