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
    var isMoving: Bool = false
    var moveSpeed: CGFloat = 3
    
    var initalTouch: CGPoint?
    var movementDirection: CGPoint?
    
    
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
    
    func touchDown(atPoint pos : CGPoint) {
        // Begin movement
        print("touched down")
        
        let touchLocation = pos
        
        
        // Move the tank
        if touchLocation.x < size.width * 0.50 {
            isMoving = true
            initalTouch = pos
            movementDirection = CGPoint(x: 0, y: 0)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        // Change movement direction
        
        let touchLocation = pos
        
        if touchLocation.x < size.width * 0.50 {
            let offset = touchLocation - initalTouch!
            
            var x = movementDirection!.x
            var y = movementDirection!.y
            
            var angle = acos(x / (sqrt((x * x) + (y * y))))
            
            print("Angle: \(angle)")
            
            movementDirection = offset.normalized()
            
           // var angle = atan2(movementDirection!.y,movementDirection!.x) * 180.0 / 3.14159;
//            if (angle < 0) {
//                angle = angle + 360.0;
//            }
//
            
            self.player.zRotation = (angle)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        print("touched up")
        
        let touchLocation = pos
        
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
        } else {
            // Cancel movement
            isMoving = false
        }
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if(isMoving) {
            self.player.position =  self.player.position + (movementDirection! * moveSpeed)
        }
    }
    
    
    
    
}
