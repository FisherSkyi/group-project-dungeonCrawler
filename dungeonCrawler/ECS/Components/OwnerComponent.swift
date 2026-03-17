import Foundation

struct OwnerComponent: Component {
    public var ownerEntity: Entity

    public var offset: SIMD2<Float>

    init(ownerEntity: Entity, offset: SIMD2<Float> = .zero) {
        self.ownerEntity = ownerEntity
        self.offset = offset
    }
}
