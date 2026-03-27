import Foundation
import CoreGraphics

public enum JoystickSide {
    case left
    case right
}

/// Engine-agnostic interface for rendering virtual joysticks on the HUD.
public protocol JoystickBackend: AnyObject {
    /// Sets the position of the joystick base (the outer circle).
    func updateJoystickBase(side: JoystickSide, position: CGPoint?)
    
    /// Sets the position of the joystick handle (the inner nub).
    func updateJoystickHandle(side: JoystickSide, position: CGPoint?)
}
