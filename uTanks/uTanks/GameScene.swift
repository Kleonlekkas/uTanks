//
//  GameScene.swift
//  uTanks
//
//  Created by Student on 4/9/18.
//  Copyright © 2018 Student. All rights reserved.
//

import SpriteKit
import GameplayKit

////Overload operators to help with some vector math for bull calc
//func + (left: CGPoint, right: CGPoint) -> CGPoint {
//    return CGPoint(x: left.x + right.x, y: left.y + right.y)
//}
//func - (left: CGPoint, right: CGPoint) -> CGPoint {
//    return CGPoint(x: left.x - right.x, y: left.y - right.y)
//}
//
//func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
//    return CGPoint(x: point.x * scalar, y: point.y * scalar)
//}
//
//func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
//    return CGPoint(x: point.x / scalar, y: point.y / scalar)
//}
//
//#if !(arch(x86_64) || arch(arm64))
//    func sqrt(a: CGFloat) -> CGFloat {
//        return CGFloat(sqrtf(Float(a)))
//    }
//#endif
//
//extension CGPoint {
//    func length() -> CGFloat {
//        return sqrt(x*x + y*y)
//    }
//
//    func normalized() -> CGPoint {
//        return self / length()
//    }
//}


class GameScene: SKScene {
    //declare our player and use their image name to make the sprite
    /*
    let player = SKSpriteNode(imageNamed: "tank")
    var isMoving: Bool = false
    var moveSpeed: CGFloat = 3
    var canFire: Bool = true
    
    var initalTouch: CGPoint?
    //Start off facing the right. This depends on the player though.
    var movementDirection: CGPoint = CGPoint(x: 1, y: 0)
    var facingAngle: CGFloat = 0
    */
    
    
    //user count label
    var countLabel: SKLabelNode!
    
    //tank images: 0 - 3
    let myTank = Tank(p_imgNum: 1)
    
    //on join, add the tank
    
    
    override func didMove(to view: SKView) {
        //redraw background
        backgroundColor = SKColor.white
        //Player is pretty big at the moment, scale him down 90%
        myTank.myObj.setScale(CGFloat(0.1))
        //Place player in top left corner
        setInitialPositionAndOrientation(tankObj: myTank)
        //Actually make sprite render on the scene
        addChild(myTank.myObj)
    }
    
    func setInitialPositionAndOrientation(tankObj: Tank) {
        //top right
        if tankObj.imgNum == 1 {
            tankObj.myObj.position =  CGPoint(x: size.width * 0.90, y: size.height * 0.85)
            myTank.myObj.zRotation = 3.14
            myTank.movementDirection = CGPoint(x: -1, y: 0)
            myTank.facingAngle = 3.14
        } else if tankObj.imgNum == 2 {
            //bottom left
            tankObj.myObj.position =  CGPoint(x: size.width * 0.10, y: size.height * 0.15)
        } else if tankObj.imgNum == 3 {
            //bottom right
            tankObj.myObj.position =  CGPoint(x: size.width * 0.90, y: size.height * 0.15)
            myTank.myObj.zRotation = 3.14
            myTank.facingAngle = 3.14
                        myTank.movementDirection = CGPoint(x: -1, y: 0)
        } else {
            //top left, default
            tankObj.myObj.position =  CGPoint(x: size.width * 0.10, y: size.height * 0.85)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        // Begin movement
        print("touched down")
        
        let touchLocation = pos
        
        
        // Move the tank
        if touchLocation.x < size.width * 0.50 {
            myTank.isMoving = true
            myTank.initalTouch = pos
            myTank.movementDirection = CGPoint(x: 0, y: 0)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        // Change movement direction
        
        let touchLocation = pos
        
        if touchLocation.x < size.width * 0.50 {
            let offset = touchLocation - myTank.initalTouch!
            
            let x = myTank.movementDirection.x
            let y = myTank.movementDirection.y
            
            myTank.facingAngle = acos(x / (sqrt((x * x) + (y * y))))
            
            if y < 0 {
                myTank.facingAngle = myTank.facingAngle * -1
            }
            
            myTank.movementDirection = offset.normalized()
            
            myTank.myObj.zRotation = (myTank.facingAngle)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        print("touched up")
        
        let touchLocation = pos
        
        //If its on the right side of the screen, shoot a projectile.
        //if its on the left, move the tank
        
        if touchLocation.x > size.width * 0.50  && myTank.canFire {
            //get initial location of projectile
            let projectile = SKSpriteNode(imageNamed: "bullet")
            projectile.position = myTank.myObj.position
            projectile.setScale(CGFloat(0.1))
            
            
            //add the projectile to the scene
            addChild(projectile)
            
            projectile.zRotation = (myTank.facingAngle)
            
            //shoot until its definitely off screen
            let amountShot = myTank.movementDirection * 1000
            
            //add the amount shot to the current position
            let trueDestination = amountShot + projectile.position
            
            //actually create the actions
            let actionMove = SKAction.move(to: trueDestination, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
            // withTimeInterval is how often we want the players to shoot in seconds
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
                _ in
                self.myTank.canFire = true
            } 
        } else {
            // Cancel movement
            myTank.isMoving = false
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
        if(myTank.isMoving) {
            myTank.myObj.position =  myTank.myObj.position + (myTank.movementDirection * myTank.moveSpeed)
        }

    }
    
    
    
    
}
