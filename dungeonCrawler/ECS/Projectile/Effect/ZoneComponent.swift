//
//  SpecialEffects.swift
//  dungeonCrawler
//
//  Created by Letian on 11/4/26.
//

import Foundation

class ZoneComponent: Component {
    var radius: Float
    var hitEffects: [any ProjectileHitEffect] = []
    var duration: Float
    var elapsed: Float = 0
    
    init(radius: Float, hitEffects: [any ProjectileHitEffect], duration: Float, elapsed: Float) {
        self.radius = radius
        self.hitEffects = hitEffects
        self.duration = duration
        self.elapsed = elapsed
    }
}
