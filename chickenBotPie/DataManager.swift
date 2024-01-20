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
    
}

class DataManager: ObservableObject {
    @Published var matches: [matchScoutData] = []
    
    init() {
        fetchMatchScoutData()
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
                    
                    // Check if "date" field exists in Firestore data
                    if let dateTimestamp = data["date"] as? Timestamp {
                        let date = dateTimestamp.dateValue()
                        let matchScoutData = matchScoutData(teamName: teamName, alliance: alliance, autoSequence: autoSequence, teleopSequence: teleopSequence, drops: drops, park: park, climbed: climbed, harmony: harmony, trap: trap, highNote: highNote, highNoteMisses: highNoteMisses, score: score, submissionTime: date)
                        self.matches.append(matchScoutData)
                    } else {
                        // Handle the case when "date" is not present in Firestore
                        let matchScoutData = matchScoutData(teamName: teamName, alliance: alliance, autoSequence: autoSequence, teleopSequence: teleopSequence, drops: drops, park: park, climbed: climbed, harmony: harmony, trap: trap, highNote: highNote, highNoteMisses: highNoteMisses, score: score, submissionTime: Date())
                        self.matches.append(matchScoutData)
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
                                                              "date": matchScoutDataInstance.submissionTime]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            }
        
        }
    }
}

