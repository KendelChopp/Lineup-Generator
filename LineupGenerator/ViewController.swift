//
//  ViewController.swift
//  LineupGenerator
//
//  Created by Kendel Chopp on 5/29/17.
//  Copyright © 2017 Kendel Chopp. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var team: Team!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.team = readFile()
            
    }
    
    @IBOutlet var opponentTextField: NSTextField!
    @IBOutlet var inningTextField: NSTextField!
    @IBOutlet var pitcherInningTextField: NSTextField!
    
    func readFile() -> Team {
        var players = [Player]()
        do {
            let location = "/Users/kendelchopp/Desktop/11uteam.csv"
            let fileUrl = URL(fileURLWithPath: location)
            let file = try String(contentsOf: fileUrl)
            let rows = file.components(separatedBy: .newlines)
            for row in rows {
                let fields = row.replacingOccurrences(of: "\"", with: "").components(separatedBy: ",")
                var positions = [Int]()
                for pos in 2...fields.count - 1 {
                    positions.append(Int(fields[pos])!)
                }
                let player = Player(playerName: fields[0], playerNumber: Int(fields[1])!, playerPositions: positions)
                players.append(player)
                // print(fields)
            }
        } catch {
            print(error)
        }
        return Team(playerList: players)
    }

    @IBAction func generatePress(_ sender: Any) {
        let innings = Int(inningTextField.stringValue)
        //let pitcherInnings = Int(pitcherInningTextField.stringValue)
        let opponent = opponentTextField.stringValue
        let game = Game(team: self.team, innings: innings!, opponent: opponent)
        let lineup = game.generateLineup()
        print(lineup)
        self.team.lineup = lineup
        self.performSegue(withIdentifier: "generateToTable", sender: self)
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if (segue.identifier == "generateToTable") {
            
            let tableController = segue.destinationController as! LineupViewController
            tableController.team = self.team
        }
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

