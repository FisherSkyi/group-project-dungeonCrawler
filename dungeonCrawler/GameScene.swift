//
//  GameScene.swift
//  dungeonCrawler
//
//  Created by Letian on 9/3/26.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // MARK: - ECS core
    private let world         = World()
    private let systemManager = SystemManager()

    // MARK: - Scene layers
    /// worldLayer moves each frame to implement camera tracking.
    private let worldLayer = SKNode()
    /// uiLayer stays fixed — joystick, HUD lives here.
    private let uiLayer    = SKNode()

    // MARK: - Adapters
    private var renderingBackend: SpriteKitRenderingAdapter!
    private var cameraAdapter:    SpriteKitCameraAdapter!
    private var tileAdapter:      SpriteKitTileMapAdapter!
    private var hudBackend:       SpriteKitHUDAdapter!
    private var joystickBackend:  SpriteKitJoystickAdapter!

    // MARK: - Level service (owns the graph and room lifecycle)
    private var levelOrchestrator: LevelOrchestrator!

    // MARK: - Input provider
    private let touchInput = TouchJoystickInputProvider()

    // MARK: - Collision Events
    let collisionEvents  = CollisionEventBuffer()
    let destructionQueue = DestructionQueue()

    private var lastUpdateTime: TimeInterval = 0

    override func sceneDidLoad() {
        self.lastUpdateTime = 0

        let background = SKSpriteNode(color: .darkGray, size: self.size)
        background.position = .zero
        background.zPosition = -1
        addChild(background)

        addChild(worldLayer)
        addChild(uiLayer)

        view?.isMultipleTouchEnabled = true

        setupSystems()
        startLevel(1)
    }

    // MARK: - System wiring

    private func setupSystems() {
        renderingBackend = SpriteKitRenderingAdapter(worldLayer: worldLayer)
        cameraAdapter    = SpriteKitCameraAdapter(worldLayer: worldLayer)
        hudBackend       = SpriteKitHUDAdapter(uiLayer: uiLayer, screenSize: size)
        joystickBackend  = SpriteKitJoystickAdapter(uiLayer: uiLayer, screenSize: size)

        let registryLoader = TileRegistryLoader()
        tileAdapter = SpriteKitTileMapAdapter(worldLayer: worldLayer, registryLoader: registryLoader)

        // Build the dungeon manager.
        var constructionConfig = BoxRoomConstructor.Config()
        constructionConfig.renderVisualSprites = false  // tilemap handles visuals
        levelOrchestrator = LevelOrchestrator(
            layoutStrategy:  LinearDungeonLayout(
                roomCount:  3,
                enemyPool:  [.charger, .mummy, .ranger]
            ),
            roomConstructor: BoxRoomConstructor(config: constructionConfig)
        )
        levelOrchestrator.tileMapRenderer = tileAdapter

        systemManager.register(LevelTransitionSystem(orchestrator: levelOrchestrator))
        systemManager.register(InputSystem(inputProvider: touchInput))
        systemManager.register(EnemyAISystem())
        systemManager.register(HealthSystem())
        systemManager.register(MovementSystem())
        systemManager.register(CollisionSystem(events: collisionEvents, destructionQueue: destructionQueue))
        systemManager.register(WeaponSystem())
        systemManager.register(KnockbackSystem())
        systemManager.register(CameraSystem())
        systemManager.register(HUDSystem(backend: hudBackend, joystickBackend: joystickBackend, inputProvider: touchInput))
        systemManager.register(RenderSystem(backend: renderingBackend))
        systemManager.register(ProjectileSystem(events: collisionEvents, destructionQueue: destructionQueue))
    }

    // MARK: - Level management

    private func startLevel(_ levelNumber: Int) {
        levelOrchestrator.loadLevel(levelNumber, world: world)

        // Camera entity — ViewportComponent holds live camera state.
        if world.entities(with: ViewportComponent.self).isEmpty {
            let cameraEntity = world.createEntity()
            world.addComponent(component: ViewportComponent(), to: cameraEntity)
        }
        if let player = world.entities(with: PlayerTagComponent.self).first {
            world.addComponent(component: CameraFocusComponent(), to: player)
        }
    }

    // MARK: - Touch forwarding

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view else { return }
        touchInput.touchesBegan(touches, in: view)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view else { return }
        touchInput.touchesMoved(touches, in: view)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view else { return }
        touchInput.touchesEnded(touches, in: view)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view else { return }
        touchInput.touchesCancelled(touches, in: view)
    }

    // MARK: - Game loop

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let deltaTime = min(currentTime - lastUpdateTime, 1.0 / 20.0)
        lastUpdateTime = currentTime

        systemManager.update(deltaTime: deltaTime, world: world)

        // Apply camera viewport to worldLayer after ECS update.
        if let cameraEntity = world.entities(with: ViewportComponent.self).first,
           let viewport = world.getComponent(type: ViewportComponent.self, for: cameraEntity) {
            cameraAdapter.apply(viewport: viewport, screenCenter: .zero)
        }
    }
}
