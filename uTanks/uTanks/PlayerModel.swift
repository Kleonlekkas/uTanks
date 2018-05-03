//
//  PlayerModel.swift
//  uTanks
//
//  Created by IrvinTehDo on 5/3/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation
import Starscream
import SocketIO

protocol PlayerModel{
    var manager: SocketManager { get set }
    var socket: SocketIOClient? { get set }
    var players: [String: [String:CGFloat]] { get set }
    var hash: String? { get set }
    func setUser(data: [Any])
    func updateMovement(data: [String: CGFloat])
}

class PlayerModelSocket: PlayerModel {
    var manager: SocketManager = SocketManager(socketURL: URL(string: "https://utanks-server.herokuapp.com/")!, config: [.log(false), .compress, .forceNew(true)])
    
    var socket: SocketIOClient?
    
    var hash: String?
    
    var players: [String: [String:CGFloat]] = [:]
    
    init() {
        socket = manager.defaultSocket
        socket?.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
            // self.socket?.emit("getPlayerCount")
        }
        socket?.on("joined") { data, ack in
            self.setUser(data: data)
        }
        socket?.on("updatedMovement") { data, ack in
            //print(data)
            self.players[data[0] as! String] = ["x": data[1] as! CGFloat, "y": data[2] as! CGFloat, "directionX":data[3] as! CGFloat, "directionY": data[4] as! CGFloat]
            //print("Players data \(self.players[data[0] as! String])")
        }
        socket?.connect()
    }
    
    // Give user their hash
    func setUser(data: [Any]) {
        hash = data[2] as? String
    }

    // Send to server this player's movement data
    func updateMovement(data: [String: CGFloat]) {
        socket?.emit("movementUpdate", data)
    }
    
    
    
}
