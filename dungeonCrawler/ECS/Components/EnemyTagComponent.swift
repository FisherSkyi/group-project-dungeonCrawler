//
//  EnemyTagComponent.swift
//  dungeonCrawler
//
//  Created by Wen Kang Yap on 16/3/26.
//

import Foundation

public enum EnemyType {
    case Charger
    case Mummy
    case Ranger
    case Tower

    var textureName: String {
        switch self {
        case .Charger: return "Charger"
        case .Mummy:   return "Mummy"
        case .Ranger:  return "Ranger"
        case .Tower:   return "Tower"
        }
    }

    var scale: Float {
        switch self {
        case .Charger: return 1.0
        case .Mummy:   return 1.0
        case .Ranger:  return 0.75
        case .Tower:   return 1.5
        }
    }
}

public struct EnemyTagComponent: Component {
    public let enemyType: EnemyType

    public init(enemyType: EnemyType) {
        self.enemyType = enemyType
    }
}
