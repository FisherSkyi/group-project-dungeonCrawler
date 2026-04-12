//
//  StationaryBehaviour.swift
//  dungeonCrawler
//
//  Created by Wen Kang Yap on 9/4/26.
//

import Foundation

/// A behaviour that does nothing — the enemy stays in place.
public struct StationaryBehaviour: EnemyBehaviour {
    public init() {}

    public func update(entity: Entity, context: BehaviourContext) {}
}
