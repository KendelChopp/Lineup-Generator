//
//  LineupViewController.swift
//  LineupGenerator
//
//  Created by Kendel Chopp on 6/4/17.
//  Copyright © 2017 Kendel Chopp. All rights reserved.
//

import Foundation
import Cocoa

class LineupViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet var tableHeader: NSTableHeaderView!
    @IBOutlet var tableView: NSTableView!
    var team: Team!
    static let positionList = ["X","P","C","1B","2B","3B","SS","LF","CF","RF"]
    
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
       
        
        
    }
    
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.team.players.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let column = Int(self.tableView.tableColumns.index(of: tableColumn!)!)
        
        let cell = tableView.make(withIdentifier: "myCell", owner: self) as! NSTableCellView
        if (column == 0) {
            let player = self.team.players[row]
            cell.textField?.stringValue = player.name + " (" + String(player.number) + ")"
        } else {
            
            cell.textField?.stringValue = LineupViewController.positionList[self.team.lineup[row][column - 1]]
        }
        return cell
    }
    
}
