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

        
        
        
        for inning in 1...self.innings {
            var available = Array(repeating: [Player](), count: 7)
            var toBeFilled = [3,4,5,6,7,8,9]
            for player in self.team.players {
                if (player.getPosition(inning: inning) == 0) {
                    for position in 3...9 {
                        if (player.positions.contains(position)) {
                            available[position - 3].append(player)
                        }
                    }
                }
            }
            
            for position in (3...9).reversed() {
                if (toBeFilled.contains(position)) {
                    //Check to see if any position only has 1 available player
                    if (position > 3) {
                        for positioning in (3...position - 1).reversed() {
                            if (available[positioning-3].count == 1 && toBeFilled.contains(positioning)) {
                                //available[positioning-3][0] will play that position
                                let player = available[positioning-3][0]
                                removePlayerFromAvailable(player: player, available: &available)
                                removeFromFilled(remove: positioning, list: &toBeFilled)
                                lineup[player.lineupNumber][inning - 1] = positioning
                                player.lineupPositions[inning - 1] = positioning
                            }
                        }
                    }
                    
                    
                    //Fill the position

                    let player = selectPlayer(position: position, inning: inning, available: available[position-3])
                    removePlayerFromAvailable(player: player, available: &available)
                    removeFromFilled(remove: position, list: &toBeFilled)
                    lineup[player.lineupNumber][inning - 1] = position
                    player.lineupPositions[inning - 1] = position
                    
                    
                }

            }
        }
            


        return lineup
    }
    
    func selectPlayer(position: Int, inning: Int, available: [Player]) -> Player{
        if (position >= 7) {
            let maxSitting = getMaxSitting(inning: inning, available: available)
            var newList = available.filter({$0.getPreviousSitting(inning: inning) >= maxSitting})
            let minOutfield = getMinOutfield(available: newList)
            newList = newList.filter({$0.getOutfieldInnings() <= minOutfield})
            return newList.randomItem()
        }
        let maxSitting = getMaxSitting(inning: inning, available: available)
        var newList = available.filter({$0.getPreviousSitting(inning: inning) >= maxSitting})
        let minInfield = getMinInfield(inning: inning, available: newList)
        newList = newList.filter({$0.getInfieldInnings() <= minInfield})
        
        return newList.randomItem()
    }
    
    func getMinOutfield(available: [Player]) -> Int {
        if (available.count == 1) {
            return available[0].getOutfieldInnings()
        }
        var outfield = available[0].getOutfieldInnings()
        for index in 1...available.count - 1 {
            if (available[index].getOutfieldInnings() < outfield) {
                outfield = available[index].getOutfieldInnings()
            }
        }
        return outfield
    }
    
    func getMaxInfield(available: [Player]) -> Int {
        var infield = 0
        for player in available {
            if (player.getInfieldInnings() > infield) {
                infield = player.getInfieldInnings()
            }
        }
        return infield
    }
    
    func getMinInfield(inning: Int, available: [Player]) -> Int {
        if (available.count == 1) {
            return available[0].getInfieldInnings()
        }
        var infield = available[0].getInfieldInnings()
        for index in 1...available.count - 1 {
            if (available[index].getInfieldInnings() < infield) {
                infield = available[index].getInfieldInnings()
            }
        }
        return infield
    }
    
    func getMaxSitting(inning: Int, available: [Player]) -> Int {
        var sitting = 0
        for player in available {
            if (player.getPreviousSitting(inning: inning) > sitting) {
                sitting = player.getPreviousSitting(inning: inning)
            }
        }
        
        
        return sitting
    }
    
    
    func removePlayerFromAvailable(player: Player, available: inout [[Player]]) {
        for position in player.positions {
            if (position >= 3 && position <= 9) {
                /*for index in 0...available[position-3].count - 1 {
                    if (available[position-3][index] == player) {
                        available[position-3].remove(at: index)
                       
                    }
                }*/
                available[position-3] = available[position-3].filter({$0 != player})
            }
           
        }
    }
    
  
    func removeFromFilled(remove: Int, list: inout [Int]) {
        for index in 0...list.count - 1 {
            if (remove == list[index]) {
                list.remove(at: index)
                return
            }
        }
    }
    

}

extension Array {
    mutating func randomItemRemove() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        let item = self[index]
        self.remove(at: index)
        return item
    }
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        let item = self[index]
        return item
    }
}
