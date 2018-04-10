//
//  GameScene.swift
//  uTanks
//
//  Created by Student on 4/9/18.
//  Copyright © 2018 Student. All rights reserved.
//

import SpriteKit
import GameplayKit

//Overload operators to help with some vector math for bull calc
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {
    //declare our player and use their image name to make the sprite
    let player = SKSpriteNode(imageNamed: "tank")
    
    
    override func didMove(to view: SKView) {
        //redraw background
        backgroundColor = SKColor.white
        //Player is pretty big at the moment, scale him down 90%
        player.setScale(CGFloat(0.1))
        //Place player in top left corner
        player.position = CGPoint(x: size.width * 0.10, y: size.height * 0.85)
        //Actually make sprite render on the scene
        addChild(player)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Choose a touch to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        //If its on the right side of the screen, shoot a projectile.
        //if its on the left, move the tank
        
        if touchLocation.x > size.width * 0.50 {
            //get initial location of projectile
            let projectile = SKSpriteNode(imageNamed: "bullet")
            projectile.position = player.position
            projectile.setScale(CGFloat(0.1))
            
            //determine offset of location to projectile
            let offset = touchLocation - projectile.position
            
            //add the projectile to the scene
            addChild(projectile)
            
            //get the direction to shoot in
            let direction = offset.normalized()
            
            //shoot until its definitely off screen
            let amountShot = direction * 1000
            
            //add the amount shot to the current position
            let trueDestination = amountShot + projectile.position
            
            //actually create the actions
            let actionMove = SKAction.move(to: trueDestination, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        }
        //move our tank
        else {
            //Get a reference to the velocity of the pan from our finger
            let pancake = UIPanGestureRecognizer()
            let velocity = pancake.velocity(in: self.view)
            
            
            //get the x and y components
            let x = velocity.x;
            let y = velocity.y;
            
            //help with bullet rotation, obv this has to be reorganized a tad. will get to it
//            //and find the appropriate direction
//            var angle = atan2(y,x) * 180.0 / 3.14159;
//            if (angle < 0) {
//                 angle = angle + 360.0;
//            }
                                            //x * 10
            player.position.x = player.position.x + 10
            player.position.y = player.position.y - 10
            
        }
        
      
    }
    
    
    
}






//Default

//private var label : SKLabelNode?
//private var spinnyNode : SKShapeNode?
//
//override func didMove(to view: SKView) {
//
//    // Get label node from scene and store it for use later
//    self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//    if let label = self.label {
//        label.alpha = 0.0
//        label.run(SKAction.fadeIn(withDuration: 2.0))
//    }
//
//    // Create shape node to use during mouse interaction
//    let w = (self.size.width + self.size.height) * 0.05
//    self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//    if let spinnyNode = self.spinnyNode {
//        spinnyNode.lineWidth = 2.5
//
//        spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//        spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                          SKAction.fadeOut(withDuration: 0.5),
//                                          SKAction.removeFromParent()]))
//    }
//}
//
//
//func touchDown(atPoint pos : CGPoint) {
//    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//        n.position = pos
//        n.strokeColor = SKColor.green
//        self.addChild(n)
//    }
//}
//
//func touchMoved(toPoint pos : CGPoint) {
//    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//        n.position = pos
//        n.strokeColor = SKColor.blue
//        self.addChild(n)
//    }
//}
//
//func touchUp(atPoint pos : CGPoint) {
//    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//        n.position = pos
//        n.strokeColor = SKColor.red
//        self.addChild(n)
//    }
//}
//
//override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    if let label = self.label {
//        label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//    }
//
//    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//}
//
//override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//}
//
//override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//}
//
//override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//}
//
//
//override func update(_ currentTime: TimeInterval) {
//    // Called before each frame is rendered
//}

