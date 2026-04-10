//
//  WanderTargetComponent.swift
//  dungeonCrawler
//
//  Created by Wen Kang Yap on 28/3/26.
//

import Foundation
import simd

/// Stores the current wander destination for an entity using WanderBehaviour.
/// Added lazily by WanderBehaviour on first update and removed on deactivate —
/// entities that do not wander will never have this component.
public struct WanderTargetComponent: Component {
    public var target: SIMD2<Float>?

    public init(target: SIMD2<Float>? = nil) {
        self.target = target
    }
}
