//Kyle Lekkas & Irvin Do
//  GameViewController.swift
//  uTanks
//
//  Created by Student on 4/9/18.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        scene.player = self.player
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
