//
//  WanderBehaviourTests.swift
//  dungeonCrawlerTests
//
//  Created by Wen Kang Yap on 9/4/26.
//

import XCTest
import simd
@testable import dungeonCrawler

@MainActor
final class WanderBehaviourTests: XCTestCase {

    var world: World!

    override func setUp() {
        super.setUp()
        world = World()
    }

    override func tearDown() {
        world = nil
        super.tearDown()
    }

    // MARK: - Helpers

    @discardableResult
    private func makeEnemy(at position: SIMD2<Float>) -> Entity {
        let entity = world.createEntity()
        world.addComponent(component: TransformComponent(position: position), to: entity)
        world.addComponent(component: VelocityComponent(), to: entity)
        return entity
    }

    private func makeContext(entity: Entity, playerPos: SIMD2<Float>) -> BehaviourContext {
        let transform = world.getComponent(type: TransformComponent.self, for: entity)!
        return BehaviourContext(entity: entity, playerPos: playerPos, transform: transform, world: world)
    }

    // MARK: - Default initialisation

    func testDefaultWanderRadius() {
        let behaviour = WanderBehaviour()
        XCTAssertEqual(behaviour.wanderRadius, 100, accuracy: 0.001)
    }

    func testDefaultWanderSpeed() {
        let behaviour = WanderBehaviour()
        XCTAssertEqual(behaviour.wanderSpeed, 40, accuracy: 0.001)
    }

    func testCustomWanderRadius() {
        let behaviour = WanderBehaviour(wanderRadius: 200)
        XCTAssertEqual(behaviour.wanderRadius, 200, accuracy: 0.001)
    }

    func testCustomWanderSpeed() {
        let behaviour = WanderBehaviour(wanderSpeed: 60)
        XCTAssertEqual(behaviour.wanderSpeed, 60, accuracy: 0.001)
    }

    // MARK: - Lazy WanderTargetComponent

    func testWanderTargetComponentAbsentBeforeFirstUpdate() {
        let enemy = makeEnemy(at: SIMD2(0, 0))
        XCTAssertNil(world.getComponent(type: WanderTargetComponent.self, for: enemy),
                     "WanderTargetComponent should not exist before first update")
    }

    func testWanderTargetComponentAddedOnFirstUpdate() {
        let behaviour = WanderBehaviour()
        let enemy = makeEnemy(at: SIMD2(0, 0))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(999, 999)))

        XCTAssertNotNil(world.getComponent(type: WanderTargetComponent.self, for: enemy),
                        "WanderTargetComponent should be added lazily on first update")
    }

    // MARK: - Deactivation cleanup

    func testWanderTargetComponentRemovedOnDeactivate() {
        let behaviour = WanderBehaviour()
        let enemy = makeEnemy(at: SIMD2(0, 0))
        let context = makeContext(entity: enemy, playerPos: SIMD2(999, 999))

        behaviour.update(entity: enemy, context: context)
        XCTAssertNotNil(world.getComponent(type: WanderTargetComponent.self, for: enemy))

        behaviour.onDeactivate(entity: enemy, context: context)
        XCTAssertNil(world.getComponent(type: WanderTargetComponent.self, for: enemy),
                     "WanderTargetComponent should be removed on deactivate")
    }

    // MARK: - Update behaviour

    func testUpdateProducesNonZeroVelocity() {
        let behaviour = WanderBehaviour()
        let enemy = makeEnemy(at: SIMD2(0, 0))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(999, 999)))

        let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
        XCTAssertGreaterThan(simd_length(vel.linear), 0,
                             "WanderBehaviour should produce non-zero velocity on first update")
    }

    func testVelocityMagnitudeEqualsWanderSpeed() {
        let behaviour = WanderBehaviour(wanderSpeed: 50)
        let enemy = makeEnemy(at: SIMD2(0, 0))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(999, 999)))

        let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
        XCTAssertEqual(simd_length(vel.linear), 50, accuracy: 0.01,
                       "Velocity magnitude should equal wanderSpeed")
    }

    func testWanderTargetIsWithinWanderRadius() {
        let behaviour = WanderBehaviour(wanderRadius: 100)
        let enemy = makeEnemy(at: SIMD2(0, 0))

        for _ in 0..<20 {
            behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(999, 999)))
            let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
            XCTAssertGreaterThan(simd_length(vel.linear), 0,
                                 "Should always find a valid wander target within radius")
        }
    }

    func testWanderTargetMinRadiusFloor() {
        let behaviour = WanderBehaviour(wanderRadius: 100)
        let enemy = makeEnemy(at: SIMD2(0, 0))
        let context = makeContext(entity: enemy, playerPos: SIMD2(999, 999))

        behaviour.update(entity: enemy, context: context)

        let target = world.getComponent(type: WanderTargetComponent.self, for: enemy)?.target
        XCTAssertNotNil(target)
        XCTAssertGreaterThan(simd_length(target! - context.transform.position), 0,
                             "Target should be above the minRadius floor")
    }

    // MARK: - Target persistence

    func testWanderTargetPersistedBetweenUpdates() throws {
        let behaviour = WanderBehaviour()
        let enemy = makeEnemy(at: SIMD2(0, 0))
        let context = makeContext(entity: enemy, playerPos: SIMD2(999, 999))

        behaviour.update(entity: enemy, context: context)
        let target1 = world.getComponent(type: WanderTargetComponent.self, for: enemy)!.target

        behaviour.update(entity: enemy, context: context)
        let target2 = world.getComponent(type: WanderTargetComponent.self, for: enemy)!.target

        XCTAssertEqual(target1!.x, target2!.x, accuracy: Float(0.001),
                       "Wander target should persist while enemy hasn't arrived")
        XCTAssertEqual(target1!.y, target2!.y, accuracy: Float(0.001))
    }

    func testVelocityDirectionIsConsistentBeforeArrival() {
        let behaviour = WanderBehaviour(wanderRadius: 100, wanderSpeed: 40)
        let enemy = makeEnemy(at: SIMD2(0, 0))
        let context = makeContext(entity: enemy, playerPos: SIMD2(999, 999))

        behaviour.update(entity: enemy, context: context)
        let vel1 = world.getComponent(type: VelocityComponent.self, for: enemy)!.linear

        behaviour.update(entity: enemy, context: context)
        let vel2 = world.getComponent(type: VelocityComponent.self, for: enemy)!.linear

        XCTAssertEqual(vel1.x, vel2.x, accuracy: 0.001,
                       "Velocity direction should not change before arrival at target")
        XCTAssertEqual(vel1.y, vel2.y, accuracy: 0.001)
    }
}
