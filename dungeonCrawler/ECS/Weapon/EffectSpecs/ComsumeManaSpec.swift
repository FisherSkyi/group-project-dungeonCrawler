//
//  ConsumeManaProtocol.swift
//  dungeonCrawler
//
//  Created by Letian on 9/4/26.
//

import Foundation

struct ComsumeManaSpec: Spec {
    
    let amount: Float
    
    func turnIntoEffect() -> any WeaponEffect {
        return ConsumeManaEffect(amount: amount)
    }
}

