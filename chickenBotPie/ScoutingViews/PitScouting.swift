//
//  PitScouting.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/17/24.
//

import CoreImage.CIFilterBuiltins

import SwiftUI
import UIKit

struct PitScouting: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var UserManager: UserManagement
    @State private var dataManager = DataManager()
    
    @State private var isSearching = false
    @State private var selectedTeamName: String?
    @State private var selectedTeamNumber: Int?
    
    @State private var showingSuccessAlert = false
    
    @State private var driveTrain = "Swerve"
    let driveTrains = ["Swerve", "Tank", "Omni", "Mecanum", "Other"]
    
    @State private var intake = "Ground"
    let intakeMechanisms = ["Ground", "Source", "Both"]
    
    @State private var bestAuto: [String] = []
    
    var concatenatedAutoElements: String {
        bestAuto.joined(separator: ", ")
        }
    
    @State private var defense = "Yes"
    let defenseStatus = ["Yes", "No"]
    
    @State private var speaker = false
    @State private var amp = false
    @State private var trap = false
    @State private var climb = false
    @State private var harmony = false
    @State private var underStage = false
    
    @State private var humanPlayer = "Med"
    let humanPlayerSkill = ["High", "Med", "Low"]
    
    @State private var notes = ""
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State private var qr_string: String = ""
    
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
                        destination: TeamSearchView(selectedTeamName: $selectedTeamName, selectedTeamNumber: $selectedTeamNumber),
                        label: {
                            HStack {
                                Text("Team:")
                                Spacer()
                                Text(selectedTeamName ?? "")
                                    .foregroundColor(selectedTeamName != nil ? .primary : .gray)
                            }
                        })
                }
                
                // MARK: BUILD INFO
                Section {
                    
                    VStack {
                        HStack{
                            Spacer()
                            Text("Build Info")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            
                        }
                        
                        Divider()
                    }
                        
                    
                    HStack{
                        Picker("Drive Train: ", selection: $driveTrain) {
                            
                            ForEach(driveTrains, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                        
                        Picker("Intake: ", selection: $intake) {
                            
                            ForEach(intakeMechanisms, id: \.self) {
                                Text($0)
                            }
                        }
   
                }
                .listRowSeparator(.hidden)
                
                // MARK: PLAYSTYLE
                Section{
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Playstyle")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Best Auto: ")
                            
                            Button(action: {
                                bestAuto.append("Speaker")
                                
                                generator.impactOccurred(intensity: 1)
                                
                            }, label : {
                                Text("Speaker")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .contentShape(RoundedRectangle(cornerRadius: 15))
                            })
                            .buttonStyle(AnimatedButton())
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(accentColor, lineWidth: 2)
                            )
                            
                            
                            Button(action: {
                                bestAuto.append("Amp")
                                
                                generator.impactOccurred(intensity: 1)
                                
                            }, label : {
                                Text("Amp")
                                    .frame(maxWidth: .infinity)
                                    .contentShape(RoundedRectangle(cornerRadius: 15))
                            })
                            .buttonStyle(AnimatedButton())
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(accentColor, lineWidth: 2)
                            )
                            .contentShape(Rectangle())
                        }
                        .padding(.top, 10)

                        TextEditor(text: .constant(concatenatedAutoElements))
                        
                            .disabled(true)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).stroke())
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                            .padding(.top, 10)
                            
                        
                        HStack {
                            
                            
                            Button(action: {
                                bestAuto.removeAll()
                            }, label : {
                                Text("Clear")
                                    .frame(maxWidth: .infinity)
                            })
                            .buttonStyle(.bordered)
                            
                            Spacer()
                            
                            Button(action: {
                                if !bestAuto.isEmpty {
                                    bestAuto.removeLast()
                                }
                                
                            }, label : {
                                Text("Delete")
                                    .frame(maxWidth: .infinity)
                            })
                            .buttonStyle(.bordered)
                            
                        }
                        .padding(.bottom, 10)
                        
                        
                    }

                        Picker("Defense: ", selection: $defense) {
                            ForEach(defenseStatus, id: \.self) {
                                Text($0)
                            }
                        }
                        .padding(.top, 1)
                        .padding(.bottom, 1)
  
                }
                
                // MARK: Abilities
                Section{
                    VStack {
                        HStack {
                            Spacer()
                            Text("Abilities")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        Divider()
                        
                        HStack (spacing: 20) {
                            VStack {
                                
                                Toggle("Speaker:", isOn: $speaker)
                                Toggle("Amp:", isOn: $amp)
                                Toggle("Under Stage:", isOn: $underStage)
                                
                            }
                            VStack {
                                Toggle("Climb:", isOn: $climb)
                                Toggle("Harmony:", isOn: $harmony)
                                Toggle("Trap:", isOn: $trap)
                            }
                        }
                        
                    }
                        
                        Picker("Human player: ", selection: $humanPlayer) {
                            
                            ForEach(humanPlayerSkill, id: \.self) {
                                Text($0)
                            }
                        }
                        .padding(.top, 1)
                        .padding(.bottom, 1)

                }
                
                // MARK: Notes
                Section{
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Notes")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        Divider()
                        
                        TextEditor(text: $notes)
                        
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).stroke())
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                            .padding(.top, 10)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        hideKeyboard()
                                    }
                                }
                            }
                    }
                }
                
                HStack{
                    Spacer()
                    if !qr_string.isEmpty {
                        Image(uiImage: generateQRCode(from: qr_string))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                    Spacer()
                }
                
                // Submit button 
                Button(action: {
                    generator.impactOccurred(intensity: 1)
                    
                    let pitScoutDataInstance = pitScoutData(
                        teamnumber: selectedTeamNumber ?? 0000,
                        scoutname: UserManager.currentUser?.fullname ?? "anonymous",
                        drivetype: driveTrain,
                        intake: intake,
                        //playstyle: "pretty good",
                        bestauto: concatenatedAutoElements,
                        defense: defense,
                        speaker: speaker,
                        amp: amp,
                        understage: underStage,
                        climb: climb,
                        harmony: harmony,
                        trap: trap,
                        humanplayer: humanPlayer,
                        extranotes: notes
                    )
                    
                    do {
                        let jsonData = try JSONEncoder().encode(pitScoutDataInstance)
                            let jsonString = String(data: jsonData, encoding: .utf8)!
                        qr_string = jsonString
                    } catch {
                        print(error)
                    }
                    
                    // Upload data
                    Task {
                        await dataManager.uploadPitData(pitData: pitScoutDataInstance)
                        
                    }
                    
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
                
            }
            .scrollContentBackground(.hidden)
            .background(
                Group {
                    if colorScheme == .light {
                        LinearGradient(gradient: Gradient(colors: [Color.lightBlueStart, Color.lightBlueEnd]), startPoint: .top, endPoint: .bottom)
                    } else {
                        LinearGradient(gradient: Gradient(colors: [Color.darkBlueStart, Color.darkBlueEnd]), startPoint: .top, endPoint: .bottom)
                    }
                }
                .edgesIgnoringSafeArea(.all))
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
        selectedTeamName = ""
        driveTrain = "Swerve"
        intake = "Ground"
        bestAuto = []
        defense = "Yes"
        speaker = false
        amp = false
        underStage = false
        climb = false
        harmony = false
        trap = false
        humanPlayer = "Med"
        notes = ""

        }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
}

struct AnimatedButton: ButtonStyle {
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

#Preview {
    PitScouting(UserManager: UserManagement())
}
