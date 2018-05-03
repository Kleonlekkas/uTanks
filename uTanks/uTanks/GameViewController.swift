//
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
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}







//Default
//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    if let view = self.view as! SKView? {
//        // Load the SKScene from 'GameScene.sks'
//        if let scene = SKScene(fileNamed: "GameScene") {
//            // Set the scale mode to scale to fit the window
//            scene.scaleMode = .aspectFill
//
//            // Present the scene
//            view.presentScene(scene)
//        }
//
//        view.ignoresSiblingOrder = true
//
//        view.showsFPS = true
//        view.showsNodeCount = true
//    }
//}
//
//override var shouldAutorotate: Bool {
//    return true
//}
//
//override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//    if UIDevice.current.userInterfaceIdiom == .phone {
//        return .allButUpsideDown
//    } else {
//        return .all
//    }
//}
//
//override func didReceiveMemoryWarning() {
//    super.didReceiveMemoryWarning()
//    // Release any cached data, images, etc that aren't in use.
//}
//
//override var prefersStatusBarHidden: Bool {
//    return true
//}

