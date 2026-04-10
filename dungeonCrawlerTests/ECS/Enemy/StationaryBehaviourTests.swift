//
//  StationaryBehaviourTests.swift
//  dungeonCrawlerTests
//
//  Created by Wen Kang Yap on 9/4/26.
//

import XCTest
import simd
@testable import dungeonCrawler

@MainActor
final class StationaryBehaviourTests: XCTestCase {

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
    private func makeEnemy(at position: SIMD2<Float>,
                           velocity: SIMD2<Float> = .zero) -> Entity {
        let entity = world.createEntity()
        world.addComponent(component: TransformComponent(position: position), to: entity)
        world.addComponent(component: VelocityComponent(linear: velocity), to: entity)
        return entity
    }

    private func makeContext(entity: Entity, playerPos: SIMD2<Float>) -> BehaviourContext {
        let transform = world.getComponent(type: TransformComponent.self, for: entity)!
        return BehaviourContext(entity: entity, playerPos: playerPos, transform: transform, world: world)
    }

    // MARK: - Tests

    func testVelocityUnchangedWhenAlreadyZero() {
        let behaviour = StationaryBehaviour()
        let enemy = makeEnemy(at: SIMD2(0, 0))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(100, 0)))

        let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
        XCTAssertEqual(vel.linear.x, 0, accuracy: 0.001)
        XCTAssertEqual(vel.linear.y, 0, accuracy: 0.001)
    }

    func testVelocityUnchangedWhenNonZero() {
        let behaviour = StationaryBehaviour()
        let enemy = makeEnemy(at: SIMD2(0, 0), velocity: SIMD2(50, 30))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(100, 0)))

        let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
        XCTAssertEqual(vel.linear.x, 50, accuracy: 0.001,
                       "StationaryBehaviour should not modify existing velocity")
        XCTAssertEqual(vel.linear.y, 30, accuracy: 0.001)
    }

    func testPositionUnchangedAfterUpdate() {
        let behaviour = StationaryBehaviour()
        let enemy = makeEnemy(at: SIMD2(42, 99))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(0, 0)))

        let updatedTransform = world.getComponent(type: TransformComponent.self, for: enemy)!
        XCTAssertEqual(updatedTransform.position.x, 42, accuracy: 0.001)
        XCTAssertEqual(updatedTransform.position.y, 99, accuracy: 0.001)
    }

    func testPlayerPositionHasNoEffect() {
        let behaviour = StationaryBehaviour()
        let enemy = makeEnemy(at: SIMD2(0, 0))

        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(0, 0)))
        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(500, 500)))
        behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(-999, 0)))

        let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
        XCTAssertEqual(vel.linear.x, 0, accuracy: 0.001)
        XCTAssertEqual(vel.linear.y, 0, accuracy: 0.001)
    }

    func testMultipleUpdatesHaveNoEffect() {
        let behaviour = StationaryBehaviour()
        let enemy = makeEnemy(at: SIMD2(10, 20))

        for _ in 0..<10 {
            behaviour.update(entity: enemy, context: makeContext(entity: enemy, playerPos: SIMD2(100, 100)))
        }

        let vel = world.getComponent(type: VelocityComponent.self, for: enemy)!
        XCTAssertEqual(vel.linear.x, 0, accuracy: 0.001)
        XCTAssertEqual(vel.linear.y, 0, accuracy: 0.001)
    }
}
