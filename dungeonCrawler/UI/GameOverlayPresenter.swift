import SpriteKit

/// Builds and manages full-screen overlay nodes inside `uiLayer`.
///
/// `GameScene` owns one instance and delegates all overlay construction here,
/// keeping itself free of SpriteKit UI detail. `GameScene` still decides *when*
/// to show an overlay and handles the game-state changes that follow.
final class GameOverlayPresenter {

    private unowned let uiLayer: SKNode
    private let size: CGSize

    init(uiLayer: SKNode, size: CGSize) {
        self.uiLayer = uiLayer
        self.size    = size
    }

    // MARK: - Game Over

    func showGameOver() {
        let overlay = makeOverlay(name: "gameOverOverlay")
        overlay.addLabel(text:  "GAME OVER",
                         font:  "AvenirNext-Bold",
                         size:  52,
                         color: SKColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1),
                         y:     60)
        overlay.addLabel(text:  "Tap to restart",
                         font:  "AvenirNext-Medium",
                         size:  24,
                         color: .white,
                         y:     -20)
    }

    func removeGameOver() {
        uiLayer.childNode(withName: "gameOverOverlay")?.removeFromParent()
    }

    // MARK: - Level Cleared

    /// Shows the level-clear overlay then calls `completion` after 2 seconds.
    ///
    /// Uses `DispatchQueue` rather than `SKAction` because `isPaused = true`
    /// freezes the SpriteKit action queue.
    func showLevelCleared(then completion: @escaping () -> Void) {
        let overlay = makeOverlay(name: "levelClearOverlay")
        overlay.addLabel(text:  "LEVEL CLEAR",
                         font:  "AvenirNext-Bold",
                         size:  52,
                         color: SKColor(red: 1.0, green: 0.85, blue: 0.2, alpha: 1),
                         y:     40)
        overlay.addLabel(text:  "Returning to dungeon select…",
                         font:  "AvenirNext-Medium",
                         size:  22,
                         color: .white,
                         y:     -20)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { completion() }
    }

    // MARK: - Private

    private func makeOverlay(name: String) -> SKSpriteNode {
        let overlay = SKSpriteNode(color: SKColor(white: 0, alpha: 0.65), size: size)
        overlay.position  = .zero
        overlay.zPosition = 100
        overlay.name      = name
        uiLayer.addChild(overlay)
        return overlay
    }
}

// MARK: - Label helper

private extension SKSpriteNode {

    @discardableResult
    func addLabel(text: String, font: String, size: CGFloat, color: SKColor, y: CGFloat) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: font)
        label.text                  = text
        label.fontSize              = size
        label.fontColor             = color
        label.verticalAlignmentMode = .center
        label.position              = CGPoint(x: 0, y: y)
        label.zPosition             = 101
        addChild(label)
        return label
    }
}
