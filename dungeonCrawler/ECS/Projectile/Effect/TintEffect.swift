//
//  TintEffect.swift
//  dungeonCrawler
//
//  Created by Letian on 20/4/26.
//

import Foundation

public struct TintEffect: ProjectileHitEffect {
    public let duration: Float
    public let newTint: SIMD4<Float>
    public init(duration: Float, newTint: SIMD4<Float>) {
        self.duration = duration
        self.newTint = newTint
    }
    public func apply(context: HitContext) {
        guard let target = context.target else { return }
        if let existing = context.world.getComponent(type: TintComponent.self, for: target) {
            existing.remaining = max(existing.remaining, duration)
            existing.newTint = self.newTint
        } else {
            context.world.addComponent(component: TintComponent(remaining: duration, newTint: newTint, defaultTint: SIMD4<Float>(1.0, 1.0, 1.0, 1.0)), to: target)
        }
    }
}
