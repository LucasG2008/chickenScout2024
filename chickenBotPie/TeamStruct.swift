//
//  TeamStruct.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 2/3/24.
//

import Foundation

struct TeamData: Hashable, Codable, Identifiable {
    
    //Team ID
    var id = UUID()
    
    //Team Info
    var teamNumber: Int
    var matchHistory: [Int]
    var winRate: Double
    var averageAutoPoints: Double
    var averageTelePoints: Double
    var avgDropsPerMatch: Double
    
    //Build Info
    var driveType: String
    var intake: String
    var playstyle: String
    var bestAuto: [String]
    var defense: Bool
    var climb: Bool
    var harmony: Bool
    var underStage: Bool
    var trap: Bool
    var extraNotes: [String]
}
