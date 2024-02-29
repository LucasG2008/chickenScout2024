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

struct matchScoutData: Codable, Hashable {
    
    var scoutname: String
    var teamnumber: Int
    var matchnumber: Int
    var alliance: String

    var autoamppoints: Int
    var autospeakerpoints: Int
    var autoleftzone: Bool
    var teleamppoints: Int
    var telespeakerpoints: Int
    var telespeakeramplifiedpoints: Int

    var drops: Int

    var climbed: Bool
    var parked: Bool

    var harmony: Bool
    var trap: String
    var numtraps: Int
    var offeredcoop: Bool
    var didcoop: Bool

    var ampmike: String
    var sourcemike: String
    var centermike: String
    
}

struct pitScoutData: Codable, Hashable {
    
    var teamnumber: Int
    var scoutname: String
    
    var drivetype: String
    var intake: String
    
    var bestauto: String
    
    var defense: String
    
    var speaker: Bool
    var amp: Bool
    var understage: Bool
    var climb: Bool
    var harmony: Bool
    var trap: Bool
    
    var humanplayer: String
    
    var extranotes: String

}

struct pastMatchData: Codable, Hashable {
    
    var scoutname: String
    var teamnumber: Int
    var matchnumber: Int
    var alliance: String

    var autoamppoints: Int
    var autospeakerpoints: Int
    var autoleftzone: Bool
    var teleamppoints: Int
    var telespeakerpoints: Int
    var telespeakeramplifiedpoints: Int

    var drops: Int

    var climbed: Bool
    var parked: Bool

    var harmony: Bool
    var trap: String
    var numtraps: Int
    var offeredcoop: Bool
    var didcoop: Bool

    var ampmike: String
    var sourcemike: String
    var centermike: String
    
    var timestamp: String
}

struct teamAvgData: Codable{
    
    var averageAutoAmpPoints: Double
    var averageAutoSpeakerPoints: Double
    var averageAutoLeftZone: Double
    
    var averageTeleAmpPoints: Double
    var averageTeleSpeakerPoints: Double
    var averageTeleSpeakerAmplifiedPoints: Double
    
    var averageDrops: Double
}

struct scoutData: Codable {
    var name: String
    var points: Int
}
