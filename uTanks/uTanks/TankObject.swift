//Kyle Lekkas & Irvin Do
//  TankObject.swift
//  uTanks
//
//  Created by Student on 5/2/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

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


class Tank {
    let possibleTanks = ["tank", "tank2", "tank3", "tank4"]
    
    //lerp
    //var pos:CGPoint = CGPoint(x: 0, y: 0)
    //our object already has a position property
    var prevPos:CGPoint = CGPoint(x: 0, y: 0)
    var destPos:CGPoint = CGPoint(x: 0, y: 0)
    var alpha:Float
    
    //set image filename depending on the numberGiven
    //number given is determined by the order the users join the room
    //here we can also set postions and rotations in corner
    var imgNum:Int
    
    //actual sprite we see
    var myObj:SKSpriteNode
    
    //from game scene
    //declare our player and use their image name to make the sprite
    var isMoving: Bool = false
    var canFire: Bool = true
    var moveSpeed: CGFloat = 5
    
    var initalTouch: CGPoint?
    //Start off facing the right. This depends on the player though.
    var preOffsetMovementDirection: CGPoint = CGPoint(x: 1, y: 0)
    var movementDirection: CGPoint = CGPoint(x: 1, y: 0)
    var facingAngle: CGFloat = 0

    
    
    init(p_imgNum:Int) {
        self.imgNum = p_imgNum
        self.alpha = 0.05
        self.myObj = SKSpriteNode(imageNamed: possibleTanks[p_imgNum])
    }
    

    
}
