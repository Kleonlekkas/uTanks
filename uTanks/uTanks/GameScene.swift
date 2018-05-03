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

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1
    static let tank: UInt32 = 0b10
    static let bullet: UInt32 = 0b100
}

class GameScene: SKScene, SKPhysicsContactDelegate {
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
    
    var player: Player?
    
    //user count label
    var countLabel: SKLabelNode!
    
    //tank images: 0 - 3
    let myTank = Tank(p_imgNum: 1)
    
    //on join, add the tank
    var tanks: [String: Tank] = [:]
    
    override func didMove(to view: SKView) {
        //redraw background
        backgroundColor = SKColor.white
        //Player is pretty big at the moment, scale him down 90%
        myTank.myObj.setScale(CGFloat(0.1))
        //Place player in top left corner
        setInitialPositionAndOrientation(tankObj: myTank)
        //Actually make sprite render on the scene
        myTank.myObj.physicsBody = SKPhysicsBody(rectangleOf: myTank.myObj.size)
        myTank.myObj.physicsBody?.isDynamic = true
        myTank.myObj.physicsBody?.categoryBitMask = PhysicsCategory.player
        myTank.myObj.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        myTank.myObj.physicsBody?.collisionBitMask = PhysicsCategory.none
        addChild(myTank.myObj)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        // Setup socket events
        setSocketEvents()
    }
    
    func setSocketEvents() {
        player?.socket.on("recieveBullet") { data, ack in
            self.makeBullet(posistion: CGPoint.init(x: data[0] as! CGFloat, y: data[1] as! CGFloat), facingAngle: data[2] as! CGFloat, movementDir: CGPoint.init(x: data[3] as! CGFloat, y: data[4] as! CGFloat))
        }
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
    
    // Run collision code here
    func bulletDidCollideWithTank(projectile: SKSpriteNode, tank: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        
        // Randomization of player location goes here aka game over
        // Only move the player tank then call movement update similar to when player moves
//        myTank.myObj.position.x = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * size.width
//        myTank.myObj.position.y = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * size.height
        
        //Updates the target on users screen, but not the other user's screen
//        player?.updateMovement(data: ["x":myTank.myObj.position.x, "y":myTank.myObj.position.y, "directionX":myTank.preOffsetMovementDirection.x, "directionY":myTank.preOffsetMovementDirection.y])
    }
    
    func bulletDidCollideWithPlayer(projectile: SKSpriteNode, player: SKSpriteNode) {
        print("Player is Hit. Also updating.")
        projectile.removeFromParent()
        
        myTank.myObj.position.x = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * size.width
        myTank.myObj.position.y = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * size.height
        
        playerIsMoved(x: myTank.myObj.position.x, y: myTank.myObj.position.y, directionX: myTank.preOffsetMovementDirection.x, directionY: myTank.preOffsetMovementDirection.y)
        
        self.player?.updateMovement(data: ["x":myTank.myObj.position.x, "y":myTank.myObj.position.y, "directionX":myTank.preOffsetMovementDirection.x, "directionY":myTank.preOffsetMovementDirection.y])
    }
    
    func playerIsMoved(x: CGFloat, y: CGFloat, directionX: CGFloat, directionY: CGFloat) {
        myTank.myObj.position.x = x
        myTank.myObj.position.y = y
        myTank.preOffsetMovementDirection.x = directionX
        myTank.preOffsetMovementDirection.y = directionY
        
    }
    
    // Make other player bullets
    func makeBullet(posistion: CGPoint, facingAngle: CGFloat, movementDir: CGPoint){
        let projectile = SKSpriteNode(imageNamed: "bullet")
        projectile.position = posistion // Add offset here so it's in front of the barrel
        projectile.setScale(CGFloat(0.1))
        
        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.tank
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        //add the projectile to the scene
        addChild(projectile)
        
        projectile.zRotation = (facingAngle)
        
        //shoot until its definitely off screen
        let amountShot = movementDir * 1000
        
        //add the amount shot to the current position
        let trueDestination = amountShot + projectile.position
        
        projectile.position = projectile.position + (movementDir * 90)
        
        //actually create the actions
        let actionMove = SKAction.move(to: trueDestination, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        // Begin movement
        print("touched down")
        
        let touchLocation = pos
        
        
        // Move the tank
        if touchLocation.x < size.width * 0.50 {
            myTank.isMoving = true
            myTank.initalTouch = pos
            print(pos)
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
            
            myTank.preOffsetMovementDirection.x = x
            myTank.preOffsetMovementDirection.y = y
            
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
            projectile.position = myTank.myObj.position // Add offset here so it's in front of the barrel
            projectile.setScale(CGFloat(0.1))
            
            projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.bullet
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.tank
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
            
            //add the projectile to the scene
            addChild(projectile)
            
            projectile.zRotation = (myTank.facingAngle)
            
            //shoot until its definitely off screen
            let amountShot = myTank.movementDirection * 1000
            
            //add the amount shot to the current position
            let trueDestination = amountShot + projectile.position
            
            projectile.position = projectile.position + (myTank.movementDirection * 90)
            
            //actually create the actions
            let actionMove = SKAction.move(to: trueDestination, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
            // withTimeInterval is how often we want the players to shoot in seconds
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
                _ in
                self.myTank.canFire = true
            }
            
            player?.socket.emit("makeBullet", ["x":myTank.myObj.position.x, "y":myTank.myObj.position.y, "facingAngle": myTank.facingAngle, "directionX":myTank.movementDirection.x, "directionY":myTank.movementDirection.y])
            
            
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
    
    func updatePlayerLocation(playerData: [String: [String:CGFloat]]) {
        for i in playerData {
            if tanks[i.key] === nil {
               tanks[i.key] = Tank(p_imgNum: 2)
                
                tanks[i.key]?.myObj.physicsBody = SKPhysicsBody(rectangleOf: myTank.myObj.size)
                tanks[i.key]?.myObj.physicsBody?.isDynamic = true
                tanks[i.key]?.myObj.physicsBody?.categoryBitMask = PhysicsCategory.tank
                tanks[i.key]?.myObj.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
                tanks[i.key]?.myObj.physicsBody?.collisionBitMask = PhysicsCategory.none
                
                addChild((tanks[i.key]?.myObj)!)
                tanks[i.key]?.myObj.setScale(CGFloat(0.1))
                tanks[i.key]?.myObj.position.x = playerData[i.key]!["x"]!
                tanks[i.key]?.myObj.position.y = playerData[i.key]!["y"]!
                tanks[i.key]?.movementDirection.x = playerData[i.key]!["directionX"]!
                tanks[i.key]?.movementDirection.y = playerData[i.key]!["directionY"]!
            
                
                let x = tanks[i.key]?.movementDirection.x
                let y = tanks[i.key]?.movementDirection.y
                
                tanks[i.key]?.facingAngle = acos(x! / (sqrt((x! * x!) + (y! * y!))))
                
                if Float(y!) < 0 {
                    tanks[i.key]?.facingAngle = (tanks[i.key]?.facingAngle)! * -1
                }
                
                tanks[i.key]?.myObj.zRotation = (tanks[i.key]?.facingAngle)!
            } else {
                tanks[i.key]?.myObj.position.x = playerData[i.key]!["x"]!
                tanks[i.key]?.myObj.position.y = playerData[i.key]!["y"]!
                tanks[i.key]?.movementDirection.x = playerData[i.key]!["directionX"]!
                tanks[i.key]?.movementDirection.y = playerData[i.key]!["directionY"]!

                let x = tanks[i.key]?.movementDirection.x
                let y = tanks[i.key]?.movementDirection.y
                
                tanks[i.key]?.facingAngle = acos(x! / (sqrt((x! * x!) + (y! * y!))))
                
                if Float(y!) < 0 {
                    tanks[i.key]?.facingAngle = (tanks[i.key]?.facingAngle)! * -1
                }
                
                tanks[i.key]?.myObj.zRotation = (tanks[i.key]?.facingAngle)!
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        updatePlayerLocation(playerData: (player?.getPlayerData())!)
        // Called before each frame is rendered
        if(myTank.isMoving) {
            myTank.myObj.position =  myTank.myObj.position + (myTank.movementDirection * myTank.moveSpeed)
            //boundary checking
            if myTank.myObj.position.x < 0 {
                myTank.myObj.position.x = 0
            }
            if myTank.myObj.position.x > size.width {
                myTank.myObj.position.x = size.width
            }
            if myTank.myObj.position.y < 0 {
                myTank.myObj.position.y = 0
            }
            if myTank.myObj.position.y > size.height {
                myTank.myObj.position.y = size.height
            }
            player?.updateMovement(data: ["x":myTank.myObj.position.x, "y":myTank.myObj.position.y, "directionX":myTank.preOffsetMovementDirection.x, "directionY":myTank.preOffsetMovementDirection.y])
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.tank != 0) && (secondBody.categoryBitMask & PhysicsCategory.bullet != 0)) {
            if let tank = firstBody.node as? SKSpriteNode,
                let bullet = secondBody.node as? SKSpriteNode {
                bulletDidCollideWithTank(projectile: bullet, tank: tank)
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.player != 0) && (secondBody.categoryBitMask & PhysicsCategory.bullet != 0)) {
            if let playerTank = firstBody.node as? SKSpriteNode,
                let bullet = secondBody.node as? SKSpriteNode {
                bulletDidCollideWithPlayer(projectile: bullet, player: playerTank)
            }
        }
    }

    
    
}
