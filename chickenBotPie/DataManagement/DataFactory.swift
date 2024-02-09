//
//  DataFactory.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/14/24.
//

import Foundation
import SwiftCSV

protocol CSVLoadable {
    init?(raw: [String])
}

struct Team: Identifiable, CSVLoadable {
    var teamNum: String = ""
    var name: String = ""
    var state: String = ""
    var country: String = ""
    var district: String = ""
    var rookie_year: String = ""
    var active: String = ""
    var norm_epa: String = ""
    var wins: String = ""
    var losses: String = ""
    var ties: String = ""
    var count: String = ""
    var winrate: String = ""
    var id = UUID()
    
    init?(raw: [String]) {
        teamNum = raw[0]
        name = raw[1]
        state = raw[2]
        country = raw[3]
        district = raw[4]
        rookie_year = raw[5]
        active = raw[6]
        norm_epa = raw[7]
        wins = raw[8]
        losses = raw[9]
        ties = raw[10]
        count = raw[11]
        winrate = raw[12]
    }
}

struct TeamListItem: Identifiable, CSVLoadable {
    var teamNum: String
    var name: String
    var id: UUID = UUID()

    init?(raw: [String]) {
        teamNum = raw[0]
        name = raw[1]
    }
}

struct EventTeams: Identifiable, CSVLoadable {
    var index: String = ""
    var teamNum: String = ""
    var name: String = ""
    var event: String = ""
    var winrate: String = ""
    var id: UUID = UUID()
    
    init?(raw: [String]) {
        index = raw[0]
        teamNum = raw[1]
        name = raw[2]
        event = raw[3]
        winrate = raw[4]
    }
}

extension CSVLoadable {
    static func loadCSV(from csvName: String) -> [Self] {
        var csvToStruct = [Self]()
        
        //locate csv file
        guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
            return []
        }
        
        //convert the contents of the file into one very long string
        var data = ""
        do {
            data = try String(contentsOfFile: filePath)
        } catch {
            print(error)
            return []
        }
        
        //split the long string into an array of "rows" of data. each row is a string
        //detect "/n carriage return, then split
        var rows = data.components(separatedBy: "\n")
        
        //remove header row
        //count number of header columns before removing
        let columnCount = rows.first?.components(separatedBy: ",").count
        rows.removeFirst()
        
        //now loop around each row and split into columns
        for row in rows {
            let csvColumns = row.components(separatedBy: ",")
            
            if csvColumns.count == columnCount {
                let genericStruct = Self.init(raw: csvColumns)
                csvToStruct.append(genericStruct!)
            }
            
        }
        
        return csvToStruct
    }
}

// Load historic data
struct TeamHistData: Identifiable, CSVLoadable {
    var year: String
    var teamNum: String
    var name: String
    var state: String
    var country: String
    var wins: String
    var losses: String
    var ties: String
    var count: String
    var winrate: String
    var total_epa_rank: String
    var total_epa_percentile: String
    var total_team_count: String
    var country_epa_rank: String
    var country_epa_percentile: String
    var country_team_count: String
    var state_epa_rank: String
    var state_epa_percentile: String
    var state_team_count: String
    
    var id: UUID = UUID()

    init?(raw: [String]) {
        year = raw[0]
        teamNum = raw[1]
        name = raw[2]
        state = raw[3]
        country = raw[4]
        wins = raw[5]
        losses = raw[6]
        ties = raw[7]
        count = raw[8]
        winrate = raw[9]
        total_epa_rank = raw[10]
        total_epa_percentile = raw[11]
        total_team_count = raw[12]
        country_epa_rank = raw[13]
        country_epa_percentile = raw[14]
        country_team_count = raw[15]
        state_epa_rank = raw[16]
        state_epa_percentile = raw[17]
        state_team_count = raw[18]
    }
}

enum Events: String, Codable, CaseIterable {
    case all = "All"
    case northern_lights = "Northern Lights"
    case seven_rivers = "Seven Rivers"
}
