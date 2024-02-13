//
//  DataManager.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/19/24.
//

import Foundation

struct BlueAllianceTeam: Codable, Hashable {
    var city: String?
    var country: String?
    var key: String?
    var name: String?
    var nickname: String?
    var state_prov: String?
    var team_number: Int?
    var rookie_year: Int?
}

struct QuickTeamView: Codable, Hashable {
    var nickname: String?
    var team_number: Int?
}

struct matchScoutData: Identifiable, Hashable {
    var id = UUID()
    var teamName: String
    var alliance: String
    
    //var autoSequence: [String]
    //var teleopSequence: [String]
    
    var autoAmpPoints: Int
    var autoSpeakerPoints: Int
    var teleAmpPoints: Int
    var teleSpeakerPoints: Int
    var teleSpeakerAmplifiedNotes: Int
    var drops: Int
    
    var park: Bool
    var climbed: Bool
    var harmony: Bool
    var trap: String

    var ampMike: String
    var sourceMike: String
    var centerMike: String
    
    var score: Int
    
    var submissionTime: Date
    var scout: String
    
}

struct pitScoutData: Identifiable, Hashable {
    var id = UUID()
    var teamName: String
    
    var driveTrain: String
    var intake: String
    
    var bestAuto: [String]
    
    var defense: String
    
    var speaker: Bool
    var amp: Bool
    var underStage: Bool
    var climb: Bool
    var harmony: Bool
    var trap: Bool
    
    var humanPlayer: String
    
    var submissionTime: Date
    var notes: String
    var scout: String
}


