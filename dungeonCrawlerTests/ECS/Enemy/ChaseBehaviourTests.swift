//
//  ChaseBehaviourTests.swift
//  dungeonCrawlerTests
//
//  Created by Wen Kang Yap on 9/4/26.
//

import XCTest
import simd
@testable import dungeonCrawler

@MainActor
final class ChaseBehaviourTests: XCTestCase {

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

    func testDefaultChaseSpeed() {
        let behaviour = ChaseBehaviour()
        XCTAssertEqual(behaviour.speed, 70, accuracy: 0.001)
    }

    func testCustomChaseSpeed() {
        let behaviour = ChaseBehaviour(speed: 120)
        XCTAssertEqual(behaviour.speed, 120, accuracy: 0.001)
    }

    // MARK: - Update behaviour

    func testVelocityPointsTowardPlayer() {
        let behaviour = ChaseBehaviour()
        let enemy = makeEnemy(at: SIMD2(0, 0))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(100, 0)))

        let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
        XCTAssertGreaterThan(vel.linear.x, 0, "Velocity x should be positive when player is to the right")
        XCTAssertEqual(vel.linear.y, 0, accuracy: 0.001, "Velocity y should be zero when player is on same horizontal")
    }

    func testVelocityMagnitudeEqualsChaseSpeed() {
        let behaviour = ChaseBehaviour(speed: 90)
        let enemy = makeEnemy(at: SIMD2(0, 0))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(100, 50)))

        let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
        XCTAssertEqual(simd_length(vel.linear), 90, accuracy: 0.01,
                       "Velocity magnitude should always equal speed regardless of direction")
    }

    func testVelocityPointsTowardPlayerWhenBehind() {
        let behaviour = ChaseBehaviour()
        let enemy = makeEnemy(at: SIMD2(100, 0))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(0, 0)))

        let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
        XCTAssertLessThan(vel.linear.x, 0, "Velocity x should be negative when player is to the left")
    }

    // MARK: - Edge case: enemy at same position as player

    func testNoVelocityChangeWhenAtPlayerPosition() {
        let behaviour = ChaseBehaviour()
        let enemy = makeEnemy(at: SIMD2(50, 50))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(50, 50)))

        let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
        XCTAssertEqual(vel.linear.x, 0, accuracy: 0.001,
                       "Velocity should not change when enemy is already at player position")
        XCTAssertEqual(vel.linear.y, 0, accuracy: 0.001)
    }
}
