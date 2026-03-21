//
//  ProjectileSystemTests.swift
//  dungeonCrawlerTests
//
//  Created by Letian on 20/3/26.
//

import Foundation
import XCTest
import simd
@testable import dungeonCrawler

@MainActor
final class ProjectileSystemTests: XCTestCase {
    
    var world: World!
    
    override func setUp() {
        super.setUp()
        world = World()
    }
    
    override func tearDown() {
        world = nil
        super.tearDown()
    }

//    func test
}
