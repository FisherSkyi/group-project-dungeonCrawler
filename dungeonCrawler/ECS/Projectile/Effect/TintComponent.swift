import Foundation

public class TintComponent: Component {
    /// Seconds remaining on the slow.
    public var remaining: Float
    
    public var newTint: SIMD4<Float>
    public let defaultTint: SIMD4<Float>
 
    public init(remaining: Float, newTint: SIMD4<Float>, defaultTint: SIMD4<Float>) {
        self.remaining = remaining
        self.newTint = newTint
        self.defaultTint = defaultTint
    }
}

enum TintLibrary {
    case slowTint
    case fireTint
    case poisonTint
    case defaultTint
    
    var tint: SIMD4<Float> {
        switch self {
        case .slowTint: SIMD4<Float>(0.3, 0.6, 1.0, 1.0)
        case .fireTint: SIMD4<Float>(1.0, 0.4, 0.1, 1.0)
        case .poisonTint: SIMD4<Float>(0.4, 1.0, 0.3, 1.0)
        case .defaultTint: SIMD4<Float>(1, 1, 1, 1)
        }
    }
}
