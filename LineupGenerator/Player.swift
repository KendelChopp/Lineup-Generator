//
//  Player.swift
//  LineupGenerator
//
//  Created by Kendel Chopp on 5/29/17.
//  Copyright © 2017 Kendel Chopp. All rights reserved.
//

import Foundation

class Player : Equatable {
    var name: String!
    var number: Int!
    var positions: [Int]!
    var lineupPositions: [Int]!
    var lineupNumber: Int! = 0
    
    init(playerName: String, playerNumber: Int, playerPositions: [Int]) {
        self.name = playerName
        self.number = playerNumber
        self.positions = playerPositions
        self.lineupPositions = [Int]()
        
    }
    
    func getPosition(inning: Int) -> Int {
        return self.lineupPositions[inning - 1]
    }
    
    func getPreviousSitting(inning: Int) -> Int{
        var sitting = 0
        for index in 0...inning - 1 {
            if (self.lineupPositions[index] == 0) {
                sitting += 1
            }
        }
        return sitting
    }
    
    func getPreviousInfield(inning: Int) -> Int{
        var infield = 0
        for index in 0...inning - 1 {
            if (self.lineupPositions[index] >= 1 && self.lineupPositions[index] <= 6) {
                infield += 1
            }
        }
        return infield
    }
    
    func getSittingInnings() -> Int {
        var sitting = 0
        for position in self.lineupPositions {
            if position == 0 {
                sitting += 1
            }
        }
        return sitting
    }
    
    func getOutfieldInnings() -> Int {
        var outfield = 0
        for position in self.lineupPositions {
            if position >= 7 && position <= 9 {
                outfield += 1
            }
        }
        return outfield
    }
    
    func getInfieldInnings() -> Int {
        var infield = 0
        for position in self.lineupPositions {
            if position >= 1 && position <= 6 {
                infield += 1
            }
        }
        return infield
    }

    static func == (p1: Player, p2: Player) -> Bool {
        return p1.name == p2.name && p1.number == p2.number && p1.lineupNumber == p2.lineupNumber
    }

    
}
