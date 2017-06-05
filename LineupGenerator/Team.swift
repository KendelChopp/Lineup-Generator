//
//  Team.swift
//  LineupGenerator
//
//  Created by Kendel Chopp on 5/29/17.
//  Copyright © 2017 Kendel Chopp. All rights reserved.
//

import Foundation

class Team {
    var players: [Player]!

    init(playerList: [Player]) {
        self.players = playerList
        var curr = 0
        for player in self.players {
            player.lineupNumber = curr
            curr += 1
        }
    }
    
    func getPlayer(lineupNumber: Int) -> Player {
        return self.players[lineupNumber]
    }

    

    
    func getPos(position: Int) -> [Player] {
        var posPlayers = [Player]()
        for player in self.players {
            if (player.positions.contains(position)) {
                posPlayers.append(player)
            }
        }
        return posPlayers
    }
    
    
}
