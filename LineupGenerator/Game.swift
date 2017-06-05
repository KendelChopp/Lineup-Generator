//
//  Game.swift
//  LineupGenerator
//
//  Created by Kendel Chopp on 5/29/17.
//  Copyright © 2017 Kendel Chopp. All rights reserved.
//

import Foundation

class Game {
    var team: Team!
    var innings: Int!
    var opponent: String!
    var pitching = [Player]()
    var pitchingInnings = 2
  
    
    
    init(team: Team, innings: Int, opponent: String) {
        self.team = team
        self.innings = innings
        self.opponent = opponent
        for player in self.team.players {
            player.lineupPositions = [Int](repeating: 0, count: self.innings)
        }
        
    }
    
    func generateLineup() -> [[Int]]{
        var lineup = Array(repeating: Array(repeating: 0, count: self.innings), count: self.team.players.count)
        
        var currentInning = 1
        //First assign pitchers/catchers for every inning
        var availablePitchers = self.team.getPos(position: 1)
        var availableCatchers = self.team.getPos(position: 2)
        let numberOfPitchers = Int((self.innings + 1) / self.pitchingInnings)
        
        for _ in 0...numberOfPitchers - 1 {
            let pitcher = availablePitchers.randomItemRemove()
            var catcher = availableCatchers.randomItemRemove()
            if (catcher == pitcher) {
                catcher = availableCatchers.randomItemRemove()
                availableCatchers.append(pitcher)
            }
            for _ in 1...self.pitchingInnings {
                if currentInning <= self.innings {
                    //Set pitcher
                    lineup[pitcher.lineupNumber][currentInning-1] = 1
                    pitcher.lineupPositions[currentInning - 1] = 1
                    
                    //Set catcher
                    lineup[catcher.lineupNumber][currentInning-1] = 2
                    catcher.lineupPositions[currentInning-1] = 2
                }
                currentInning += 1
            }
        }
        currentInning = 1
        
      
        
        
        
        return lineup
    }
    
    
    
    

}

extension Array {
    mutating func randomItemRemove() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        let item = self[index]
        self.remove(at: index)
        return item
    }
}
