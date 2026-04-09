//
//  TimidStrategy.swift
//  dungeonCrawler
//
//  Created by Wen Kang Yap on 9/4/26.
//

import Foundation

/// A timid enemy strategy: wanders when idle, attacks when the player is close,
/// but flees when HP drops below fleeThreshold — regardless of player distance.
///
/// Priority order: flee > attack > wander.
public struct TimidStrategy: EnemyStrategy {

    public var detectionRadius: Float
    public var loseRadius: Float?
    public var fleeThreshold: Float
    public var wanderBehaviour: any EnemyBehaviour
    public var attackBehaviour: any EnemyBehaviour
    public var fleeBehaviour: any EnemyBehaviour

    public init(
        detectionRadius: Float = 150,
        loseRadius: Float? = 225,
        fleeThreshold: Float = 0.2,
        wanderBehaviour: any EnemyBehaviour = WanderBehaviour(),
        attackBehaviour: any EnemyBehaviour = ChaseBehaviour(),
        fleeBehaviour: any EnemyBehaviour = FleeBehaviour()
    ) {
        self.detectionRadius = detectionRadius
        self.loseRadius = loseRadius
        self.fleeThreshold = fleeThreshold
        self.wanderBehaviour = wanderBehaviour
        self.attackBehaviour = attackBehaviour
        self.fleeBehaviour = fleeBehaviour
    }

    public func update(entity: Entity, context: BehaviourContext) {
        let allBehaviours: [any EnemyBehaviour] = [wanderBehaviour, attackBehaviour, fleeBehaviour]

        // Flee is highest priority — overrides everything else
        if let hp = context.healthFraction, hp < fleeThreshold {
            activate(fleeBehaviour, from: allBehaviours, for: entity, context: context)
            return
        }

        let currentID = context.world.getComponent(type: ActiveBehaviourComponent.self, for: entity)?.behaviourID
        let isAttacking = currentID == attackBehaviour.id

        let shouldAttack: Bool
        if isAttacking {
            shouldAttack = loseRadius.map { context.distToPlayer <= $0 } ?? true
        } else {
            shouldAttack = context.distToPlayer <= detectionRadius
        }

        let chosen: any EnemyBehaviour = shouldAttack ? attackBehaviour : wanderBehaviour
        activate(chosen, from: allBehaviours, for: entity, context: context)
    }
}
