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
    
    let manager = SocketManager(socketURL: URL(string: "https://utanks-server.herokuapp.com/")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       print("view loaded")
        
        socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
            self.socket.emit("getPlayerCount")
        }
        
        socket.on("recievePlayerCount") { data, ack in
            print("Players: \(data)")
            self.playerCountLabel.text = "Player Count: \(data[0])"
        
        }
        
        socket.connect()
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
