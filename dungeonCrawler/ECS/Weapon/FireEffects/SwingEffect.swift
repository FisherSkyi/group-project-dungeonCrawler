//
//  SwingEffect.swift
//  dungeonCrawler
//
//  Created by Letian on 2/4/26.
//

import Foundation

struct SwingEffect: WeaponEffect {
    func apply(context: FireContext) -> FireEffectResult {
        if let swing = context.world.getComponent(type: WeaponSwingComponent.self, for: context.weapon) {
            let progressedElapsed = swing.elapsed + context.delta
            if progressedElapsed >= swing.duration {
                context.world.removeComponent(type: WeaponSwingComponent.self, from: context.weapon)
            } else {
                let progress = progressedElapsed / swing.duration
                let offset = sin(2 * (0.25 - progress) * .pi) * swing.amplitude * swing.directionSign
//                renderedRotation = swing.baseRotation + offset
                swing.elapsed = progressedElapsed
            }
        }
        return .success
    }
}
