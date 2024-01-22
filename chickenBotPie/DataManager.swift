//
//  DataManager.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/19/24.
//

import Foundation
import Firebase

struct matchScoutData: Identifiable, Hashable {
    var id = UUID()
    var teamName: String
    var alliance: String
    
    var autoSequence: [String]
    var teleopSequence: [String]
    var drops: Int
    
    var park: Bool
    var climbed: Bool
    var harmony: Bool
    var trap: String
    var highNote: Bool
    
    var highNoteMisses: Int
    
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

class DataManager: ObservableObject {
    @Published var matches: [matchScoutData] = []
    @Published var pits: [pitScoutData] = []
    
    init() {
        fetchMatchScoutData()
        fetchPitScoutData()
    }
    
    func fetchMatchScoutData() {
        matches.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Matches")
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let teamName = data["teamName"] as? String ?? ""
                    let alliance = data["alliance"] as? String ?? ""
                    let autoSequence = data["autoSequence"] as? [String] ?? [""]
                    let teleopSequence = data["teleopSequence"] as? [String] ?? [""]
                    let drops = data["drops"] as? Int ?? 0
                    let park = data["park"] as? Bool ?? false
                    let climbed = data["climbed"] as? Bool ?? false
                    let harmony = data["harmony"] as? Bool ?? false
                    let trap = data["trap"] as? String ?? ""
                    let highNote = data["highNote"] as? Bool ?? false
                    let highNoteMisses = data["highNoteMisses"] as? Int ?? 0
                    let score = data["score"] as? Int ?? 0
                    let scout = data["scout"] as? String ?? ""
                    
                    // Check if "date" field exists in Firestore data
                    if let dateTimestamp = data["date"] as? Timestamp {
                        let date = dateTimestamp.dateValue()
                        let matchScoutData = matchScoutData(teamName: teamName, alliance: alliance, autoSequence: autoSequence, teleopSequence: teleopSequence, drops: drops, park: park, climbed: climbed, harmony: harmony, trap: trap, highNote: highNote, highNoteMisses: highNoteMisses, score: score, submissionTime: date, scout: scout)
                        self.matches.append(matchScoutData)
                    } else {
                        // Handle the case when "date" is not present in Firestore
                        let matchScoutData = matchScoutData(teamName: teamName, alliance: alliance, autoSequence: autoSequence, teleopSequence: teleopSequence, drops: drops, park: park, climbed: climbed, harmony: harmony, trap: trap, highNote: highNote, highNoteMisses: highNoteMisses, score: score, submissionTime: Date(), scout: scout)
                        self.matches.append(matchScoutData)
                    }
                    
                }
            }
        }
    }
    
    func fetchPitScoutData() {
        pits.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Pits")
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let teamName = data["teamName"] as? String ?? ""
                    let driveTrain = data["driveTrain"] as? String ?? ""
                    let intake = data["intake"] as? String ?? ""
                    let bestAuto = data["bestAuto"] as? [String] ?? [""]
                    let defense = data["defense"] as? String ?? ""
                    let speaker = data["speaker"] as? Bool ?? false
                    let amp = data["amp"] as? Bool ?? false
                    let underStage = data["underStage"] as? Bool ?? false
                    let climb = data["climb"] as? Bool ?? false
                    let harmony = data["harmony"] as? Bool ?? false
                    let trap = data["trap"] as? Bool ?? false
                    let humanPlayer = data["humanPlayer"] as? String ?? ""
                    let notes = data["notes"] as? String ?? ""
                    let scout = data["scout"] as? String ?? ""
                    
                    // Check if "date" field exists in Firestore data
                    if let dateTimestamp = data["date"] as? Timestamp {
                        let date = dateTimestamp.dateValue()
                        let pitScoutData = pitScoutData(teamName: teamName, driveTrain: driveTrain, intake: intake, bestAuto: bestAuto, defense: defense, speaker: speaker, amp: amp, underStage: underStage, climb: climb, harmony: harmony, trap: trap, humanPlayer: humanPlayer, submissionTime: date, notes: notes, scout: scout)
                        self.pits.append(pitScoutData)
                    } else {
                        // Handle the case when "date" is not present in Firestore
                        let pitScoutData = pitScoutData(teamName: teamName, driveTrain: driveTrain, intake: intake, bestAuto: bestAuto, defense: defense, speaker: speaker, amp: amp, underStage: underStage, climb: climb, harmony: harmony, trap: trap, humanPlayer: humanPlayer, submissionTime: Date(), notes: notes, scout: scout)
                        self.pits.append(pitScoutData)
                    }
                    
                }
            }
        }
    }
    
    func addMatchScoutData(matchScoutDataInstance: matchScoutData) {
        let db = Firestore.firestore()
        let _ = db.collection("Matches").addDocument(data: ["teamName": matchScoutDataInstance.teamName,
                                                              "alliance": matchScoutDataInstance.alliance,
                                                              "autoSequence": matchScoutDataInstance.autoSequence,
                                                              "teleopSequence": matchScoutDataInstance.teleopSequence,
                                                              "drops": matchScoutDataInstance.drops,
                                                                "park": matchScoutDataInstance.park,
                                                              "climbed": matchScoutDataInstance.climbed,
                                                              "harmony": matchScoutDataInstance.harmony,
                                                              "trap": matchScoutDataInstance.trap,
                                                              "highNote": matchScoutDataInstance.highNote,
                                                              "highNoteMisses": matchScoutDataInstance.highNoteMisses,
                                                              "score": matchScoutDataInstance.score,
                                                              "date": matchScoutDataInstance.submissionTime,
                                                            "scout": matchScoutDataInstance.scout]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            }
        
        }
    }
    
    func addPitScoutData(pitScoutDataInstance: pitScoutData) {
        let db = Firestore.firestore()
        let _ = db.collection("Pits").addDocument(data: ["teamName": pitScoutDataInstance.teamName,
                                                            "driveTrain": pitScoutDataInstance.driveTrain,
                                                            "intake": pitScoutDataInstance.intake,
                                                            "bestAuto": pitScoutDataInstance.bestAuto,
                                                            "defense": pitScoutDataInstance.defense,
                                                            "speaker": pitScoutDataInstance.speaker,
                                                            "amp": pitScoutDataInstance.amp,
                                                            "underStage": pitScoutDataInstance.underStage,
                                                            "climb": pitScoutDataInstance.climb,
                                                            "harmony": pitScoutDataInstance.harmony,
                                                            "trap": pitScoutDataInstance.trap,
                                                            "humanPlayer": pitScoutDataInstance.humanPlayer,
                                                            "notes": pitScoutDataInstance.notes,
                                                            "date": pitScoutDataInstance.submissionTime,
                                                            "scout": pitScoutDataInstance.scout]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            }
        
        }
    }
}

