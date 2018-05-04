//Kyle Lekkas and Irvin Do
//  MainMenuVCViewController.swift
//  uTanks
//
//  Created by Student on 4/12/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation
import UIKit
import Starscream
import SocketIO

class MainMenuVCViewController: UIViewController {

    var player: Player!
    
    //Queue button, when pressed initiates match making process
    //pressing again removes player from queue
    var isQueued: Bool = false
    @IBOutlet weak var matchmakingLabel: UILabel!
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBAction func queueButtonPressed(_ sender: Any) {
        isQueued = !isQueued
        if (isQueued) {
            matchmakingLabel.text = "Waiting for players..."
        } else {
            matchmakingLabel.text = "   "
        }
    }
    // https://utanks-server.herokuapp.com/
    
    override func viewDidLoad() {
        super.viewDidLoad()

       print("view loaded")

    }
    // send player socket data to GameScene/GameViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameViewController = segue.destination as? GameViewController {
            gameViewController.player = self.player
        }
    }

}
