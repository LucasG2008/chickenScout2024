//
//  MatchScouting.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/17/24.
//

import SwiftUI
import ConfettiSwiftUI

struct MatchScouting: View {
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showingSuccessAlert = false
    
    @State private var selectedAlliance = "Red"
    let alliances = ["Red", "Blue"]
    
    @State private var isSearching = false
    @State private var selectedTeamName: String?
    
    @State private var leftAuto = false
    
    @State private var autoSequence: [String] = []
    @State private var teleopSequence: [String] = []
    
    var concatenatedAutoElements: String {
        autoSequence.joined(separator: ", ")
        }
    
    var concatenatedTeleopElements: String {
        teleopSequence.joined(separator: ", ")
        }
    
    @State private var teleopDrops = 0
    
    @State private var park = false
    @State private var climbed = false
    @State private var harmony = false
    @State private var trap = "No"
    let trapOutcomes = ["No", "Yes", "Not Attempted"]
    
    @State private var spotlit = false
    @State private var highNoteMisses = 0
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    let extraGenerator = UIImpactFeedbackGenerator(style: .soft)
    let notificationGenerator = UINotificationFeedbackGenerator()
    
    @State private var teleopConfettiCounter: Int = 0
    @State private var autoConfettiCounter: Int = 0
    
    @State private var autoTimesClicked: Int = 0
    @State private var teleopTimesClicked: Int = 0
    
    // TIMES UNTIL CONFETTI
    @State private var timesUntilConfetti: Int = 5
    
    //Score calculation
    
    var autoScore: Int {
        var totalScore = 0

        for element in autoSequence {
            switch element {
            case "Amp":
                totalScore += 2
            case "Speaker":
                totalScore += 5
            case "Left":
                totalScore += 2
            default:
                break
            }
        }

        return totalScore
    }
    
    var teleopScore: Int {
        var totalScore = 0

        for element in teleopSequence {
            switch element {
            case "Amped Speaker":
                totalScore += 5
            case "Amp":
                totalScore += 1
            case "Speaker":
                totalScore += 2
            default:
                break
            }
        }

        return totalScore
    }
    
    var gameScore: Int {
        var totalScore = 0
        
        // Add auto and teleop scores
        totalScore += autoScore
        totalScore += teleopScore
        
        // Additional conditions
        if park {
            totalScore += 2
        }
        
        if harmony && spotlit && climbed {
           totalScore += 7
       } else if harmony && climbed && !spotlit {
           totalScore += 5
       } else if climbed && !spotlit {
            totalScore += 3
        } else if climbed && spotlit {
            totalScore += 4
        }
        
        // Check if trap is "Yes"
        if trap == "Yes" {
            totalScore += 5
        }
        
        return totalScore
    }
    
    var body: some View {
        
        NavigationStack {
            List {
                Section (
                    header: 
                        VStack{
                            HStack {
                                Spacer()
                                Text("Team Info")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(accentColor)
                                Spacer()
                            }
                        }
                ){
                    
                        NavigationLink(
                            destination: TeamSearchView(selectedTeamName: $selectedTeamName),
                            label: {
                                HStack {
                                    Text("Team:")
                                    Spacer()
                                    Text(selectedTeamName ?? "")
                                        .foregroundColor(selectedTeamName != nil ? .primary : .gray)
                                }
                            })
                    
                    
                        Picker("Alliance: ", selection: $selectedAlliance) {
                            ForEach(alliances, id: \.self) {
                                Text($0)
                            }
                        }
   
                }
            
                // MARK: AUTO
                
                Section {
                    VStack {
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text("AUTO")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                    
                    Divider()
                    
                    HStack {
                        Button(action: {
                            autoSequence.append("Speaker")
                            autoTimesClicked += 1
                            
                            if autoTimesClicked % timesUntilConfetti == 0 {
                                autoConfettiCounter += 1
                            }
                            
                            generator.impactOccurred(intensity: 3)
                            
                        }, label : {
                            Text("Speaker")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .contentShape(RoundedRectangle(cornerRadius: 15))
                        })
                        .buttonStyle(GrowingButton())
                        .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(accentColor, lineWidth: 2)
                        )
                    
                        
                        Button(action: {
                            autoSequence.append("Amp")
                            autoTimesClicked += 1
                            
                            if autoTimesClicked % timesUntilConfetti == 0 {
                                autoConfettiCounter += 1
                            }
                            
                            generator.impactOccurred(intensity: 3)
                            
                        }, label : {
                            Text("Amp")
                                .frame(maxWidth: .infinity)
                                .contentShape(RoundedRectangle(cornerRadius: 15))
                        })
                        .buttonStyle(GrowingButton())
                        .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(accentColor, lineWidth: 2)
                        )
                        .contentShape(Rectangle())
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    HStack {
                        if leftAuto {
                            Text("Num Moves: \(autoSequence.count-1)")
                                .font(.headline)
                        } else {
                            Text("Num Moves: \(autoSequence.count)")
                                .font(.headline)
                        }
                        Spacer()
                        
                        Text("Score: \(autoScore)")
                            .font(.headline)
                    }
                    
                    .padding(.bottom, 10)
                    
                    TextEditor(text: .constant(concatenatedAutoElements))
                        .padding(5)
                        .disabled(true)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).stroke())
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        .confettiCannon(counter: $autoConfettiCounter, num: 50, confettis: [.text("🐔"), .text("🐣"), .text("🔥")], confettiSize: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                    
                    Spacer()
                    
                        HStack {
                            
                            Button(action: {
                                autoSequence.removeAll()
                                leftAuto = false
                                extraGenerator.impactOccurred(intensity: 3)
                            }, label : {
                                Text("Clear")
                                    .frame(maxWidth: .infinity)
                            })
                            .buttonStyle(.bordered)
                            
                            Spacer()
                            
                            Button(action: {
                                if !autoSequence.isEmpty {
                                    if autoSequence == ["Left"] {
                                        leftAuto = false
                                    } else {
                                        autoSequence.removeLast()
                                    }
                                }
                                extraGenerator.impactOccurred(intensity: 3)
                            }, label : {
                                Text("Delete")
                                    .frame(maxWidth: .infinity)
                            })
                            .buttonStyle(.bordered)

                        }
                        .padding(.bottom, 10)
                        
                        Divider()
                        
                        
                        Toggle("Left Zone:", isOn: $leftAuto)
                                .onChange(of: leftAuto, initial: false) {
                                    if leftAuto == true {
                                        autoSequence.insert("Left", at: 0)
                                    } else {
                                        if !autoSequence.isEmpty {
                                            autoSequence.removeFirst()
                                        }
                                    }
                                }
                                .padding(.bottom, 10)
                                .padding(.top, 10)
                    }
                }
                
                // MARK: TELE-OPERATIONS
                
                Section {
                    
                    VStack {
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text("TELE-OP")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        Divider()
                        
                        HStack {
                            Button(action: {
                                teleopSequence.append("Speaker")
                                teleopTimesClicked += 1
                                
                                if teleopTimesClicked % timesUntilConfetti == 0 {
                                    teleopConfettiCounter += 1
                                    notificationGenerator.notificationOccurred(.success)
                                }
                                
                                generator.impactOccurred(intensity: 3)
                                
                            }, label : {
                                Text("Speaker")
                                    .frame(maxWidth: .infinity)
                                    .contentShape(RoundedRectangle(cornerRadius: 15))
                            })
                            .buttonStyle(GrowingButton())
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(accentColor, lineWidth: 2)
                            )
                            
                            Button(action: {
                                teleopSequence.append("Amped Speaker")
                                teleopTimesClicked += 1
                                
                                if teleopTimesClicked % timesUntilConfetti == 0 {
                                    teleopConfettiCounter += 1
                                }
                                
                                generator.impactOccurred(intensity: 3)
                                
                            }, label : {
                                Text("Amped Speaker")
                                    .frame(maxWidth: .infinity)
                                    .contentShape(RoundedRectangle(cornerRadius: 15))
                            })
                            
                            .buttonStyle(GrowingButtonShort())
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(accentColor, lineWidth: 2)
                            )
                            
                            Button(action: {
                                teleopSequence.append("Amp")
                                teleopTimesClicked += 1
                                
                                if teleopTimesClicked % timesUntilConfetti == 0 {
                                    teleopConfettiCounter += 1
                                }
                                
                                generator.impactOccurred(intensity: 3)
                                
                            }, label : {
                                Text("Amp")
                                    .frame(maxWidth: .infinity)
                                    .contentShape(RoundedRectangle(cornerRadius: 15))
                            })
                            .buttonStyle(GrowingButton())
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(accentColor, lineWidth: 2)
                                
                            )
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        
                        HStack {
                            Text("Num Moves: \(teleopSequence.count)")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("Score: \(teleopScore)")
                                .font(.headline)
                        }
                        .padding(.bottom, 10)
                        
                        TextEditor(text: .constant(concatenatedTeleopElements))
                            .padding(5)
                            .disabled(true)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).stroke())
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                            .confettiCannon(counter: $teleopConfettiCounter, num: 50, confettis: [.text("🐔"), .text("🐣"), .text("🔥")], confettiSize: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                        
                        Spacer()
                        
                        HStack {
                            
                            
                            Button(action: {
                                teleopSequence.removeAll()
                                extraGenerator.impactOccurred(intensity: 3)
                            }, label : {
                                Text("Clear")
                                    .frame(maxWidth: .infinity)
                            })
                            .buttonStyle(.bordered)
                            
                            Spacer()
                            
                            Button(action: {
                                if !teleopSequence.isEmpty {
                                    teleopSequence.removeLast()
                                }
                                extraGenerator.impactOccurred(intensity: 3)
                            }, label : {
                                Text("Delete")
                                    .frame(maxWidth: .infinity)
                            })
                            .buttonStyle(.bordered)
                            
                            
                        }
                        .padding(.bottom, 10)
                        
                        Divider()
                        
                        Stepper("Drops: \(teleopDrops)", value: $teleopDrops, in: 0...100)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                        
                    }
                }
                // MARK: ENDGAME
                Section{
                    VStack {
                        
                        HStack {
                            Spacer()
                            Text("ENDGAME")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        Divider()
                        
                        Toggle("Park: ", isOn: $park)
                        Toggle("Onstage Climb:", isOn: $climbed)
                        Toggle("Harmony:", isOn: $harmony)
                        
                        Picker("Trap: ", selection: $trap) {
                            
                            ForEach(trapOutcomes, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        Toggle("High Note:", isOn:$spotlit)
                        Stepper("Misses: \(highNoteMisses)", value: $highNoteMisses, in: 0...3)

                    }
                }
                
                Section {
                    VStack {
                        
                        HStack {
                            Spacer()
                            Text("GAME SCORE")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        Divider()
                        
                        Text("Total Points Scored: \(gameScore)")

                    }
                }
                
                Button(action: {
                    generator.impactOccurred(intensity: 1)
                    
                    let matchScoutDataInstance = matchScoutData(
                        teamName: selectedTeamName ?? "",
                        alliance: selectedAlliance,
                        autoSequence: autoSequence,
                        teleopSequence: teleopSequence,
                        drops: teleopDrops,
                        park: park,
                        climbed: climbed,
                        harmony: harmony,
                        trap: trap,
                        highNote: spotlit,
                        highNoteMisses: highNoteMisses,
                        score: gameScore,
                        submissionTime: Date())
                    
                    dataManager.addMatchScoutData(matchScoutDataInstance: matchScoutDataInstance)
                    
                    // Show success alert
                    showingSuccessAlert = true
                    
                    // Reset all values
                    resetValues()
                    
                }, label : {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .contentShape(RoundedRectangle(cornerRadius: 15))

                })
                
                .frame(minWidth: 0, maxWidth: .infinity)
                .buttonStyle(GrowingButton())
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(accentColor, lineWidth: 2)
                    
                )
                
                // debug
                
                //Text("Team Name: \(matchScoutDataInstance.teamName)")
                //Text("Alliance: \(matchScoutDataInstance.alliance)")
                //Text(matchScoutDataInstance.autoSequence.joined(separator: ", "))
                //   .multilineTextAlignment(.trailing)
                //   .padding()
                //Text(matchScoutDataInstance.teleopSequence.joined(separator: ", "))
                //   .multilineTextAlignment(.trailing)
                //   .padding()
                //Text("Climbed: \(matchScoutDataInstance.climbed)" as String)
                //Text("Harmony: \(matchScoutDataInstance.harmony)" as String)
                //Text("Trap: \(matchScoutDataInstance.trap)" as String)
                //Text("High Notes: \(matchScoutDataInstance.highNote)" as String)
                //Text("Misses: \(matchScoutDataInstance.highNoteMisses)")
                //Text("Score: \(matchScoutDataInstance.score)")
                

                    
                }
            
            }
        .alert("Data Saved Successfully!", isPresented: $showingSuccessAlert) {
                    Button("OK", role: .cancel) { }
                }
    }
    
    // get accent color
    var accentColor: Color {
            return colorScheme == .dark ? .white : .black
        }
    
    func resetValues() {
        // Set each variable to its default value
        selectedAlliance = "Red"
        selectedTeamName = ""
        leftAuto = false
        autoSequence = []
        teleopSequence = []
        teleopDrops = 0
        park = false
        climbed = false
        harmony = false
        trap = "No"
        spotlit = false
        highNoteMisses = 0

        }

}

// MARK: DESIGN STRUCTURES

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.top,  20)
            .padding(.bottom,  20)
            //.background(Color(white: 0.8745))
            //.foregroundStyle(.black)
            .fontWeight(.bold)
        
            .cornerRadius(15)
            .frame(minWidth: 0, maxWidth: .infinity)
        
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
        
}

struct GrowingButtonShort: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.top,  10)
            .padding(.bottom,  10)
            .fontWeight(.bold)
            
            .cornerRadius(15)
            .frame(minWidth: 0, maxWidth: .infinity)
        
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct MatchScouting_Previews: PreviewProvider {
    static var previews: some View {
        MatchScouting()
    }
}
