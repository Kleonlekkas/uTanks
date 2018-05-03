//
//  Player.swift
//  uTanks
//
//  Created by IrvinTehDo on 5/3/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation
import UIKit
import Starscream
import SocketIO

class Player {
    private var playerModel: PlayerModel
    var socket: SocketIOClient
    
    // Initializer
    init(playerModel: PlayerModel = PlayerModelSocket()) {
        self.playerModel = playerModel
        self.socket = self.playerModel.socket!
    }
    
    // Update player movement
    func updateMovement(data: [String: CGFloat]) {
        playerModel.updateMovement(data: data)
    }
    // Grabs other player's data
    func getPlayerData() -> [String: [String:CGFloat]] {
        return playerModel.players
    }
}
