//
//  MatchScouting.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/17/24.
//

import CoreImage.CIFilterBuiltins

import SwiftUI
import ConfettiSwiftUI

@available(iOS 17.0, *)
struct MatchScouting: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var UserManager: UserManagement
    @State private var dataManager = DataManager()
    
    @StateObject var networkMonitor = NetworkMonitor.shared
    
    @State var teams: [QuickTeamView] = []
    @State private var teamsViewModel = TBAManager()
    
    @State private var showingSuccessAlert = false
    @State private var showingLocalSaveAlert = false
    
    @State private var isSearching = false
    @State private var selectedTeamNumber: Int?
    @State private var selectedTeamName: String?
    
    @State private var typedTeam = ""
    var textFieldDisplay: String {
        if selectedTeamName != nil {
            return "\(selectedTeamNumber ?? 0): \(selectedTeamName ?? "N/A")"
        } else {
            return ""
        }
    }
    @State private var isEditing = true
    
    @State private var showTeamNumAlert = false
    
    @FocusState private var isTeamFocused: Bool
    @FocusState private var isMatchFocused: Bool
    @State private var activeTextField: TextFieldType?
    
    enum TextFieldType {
        case team, matchNumber
    }
    
    @State private var selectedOptTeam: Int = 0000
    
    @State private var matchNumber: Int?
    
    @State private var selectedAlliance = "Select"
    let alliances = ["Select", "Red", "Blue"]
    
    @State private var leftAuto = false
    
    @State var autoSequence: [String] = []
    @State var teleopSequence: [String] = []
    
    var concatenatedAutoElements: String {
        autoSequence.joined(separator: ", ")
    }
    
    var concatenatedTeleopElements: String {
        teleopSequence.joined(separator: ", ")
    }
    
    @State var offeredCoop = false
    @State var didCoop = false
    
    @State private var drops = 0
    
    @State private var park = false
    @State private var climbed = false
    @State private var harmony = false
    
    let trapOutcomes = ["No", "Yes", "Not Attempted"]
    @State private var trap = "Not Attempted"
    @State private var numTraps = 0
    
    let mikeOutcomes = ["Miss", "Score", "Score w/ harmony"]
    @State private var ampMike = "Miss"
    @State private var sourceMike = "Miss"
    @State private var centerMike = "Miss"
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    let extraGenerator = UIImpactFeedbackGenerator(style: .soft)
    let notificationGenerator = UINotificationFeedbackGenerator()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State private var teleopConfettiCounter: Int = 0
    @State private var autoConfettiCounter: Int = 0
    
    @State private var autoTimesClicked: Int = 0
    @State private var teleopTimesClicked: Int = 0
    
    @State private var notes = ""
    
    // TIMES UNTIL CONFETTI
    @State private var timesUntilConfetti: Int = 5
    
    @State private var stringRep: String = "No data yet"
    
    @State private var popupTagsPresented = false
    
    @State private var qr_string: String = ""
    
    // MARK: Score Calculation
    
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
        
        if harmony && climbed {
            totalScore += 4
        } else if climbed {
            totalScore += 3
        }
        
        // Spotlight data
        if ampMike == "Score" {
            totalScore += 1
        }
        if sourceMike == "Score" {
            totalScore += 1
        }
        if centerMike == "Score" {
            totalScore += 1
        }
        
        
        if ampMike == "Score w/ harmony" {
            totalScore += 2
        }
        if sourceMike == "Score w/ harmony" {
            totalScore += 2
        }
        if centerMike == "Score w/ harmony" {
            totalScore += 2
        }
        
        // Check if trap is "Yes"
        if trap == "Yes" {
            totalScore += (5*numTraps)
        }
        
        return totalScore
    }
    
    var autoAmpPoints: Int {
        var autoAmpPointsScore = 0
        
        for element in autoSequence {
            switch element {
            case "Amp":
                autoAmpPointsScore += 2
            default:
                break
            }
        }
        
        return autoAmpPointsScore
    }
    
    var autoSpeakerPoints: Int {
        var autoSpeakerPointsScore = 0
        
        for element in autoSequence {
            switch element {
            case "Speaker":
                autoSpeakerPointsScore += 5
            default:
                break
            }
        }
        
        return autoSpeakerPointsScore
    }
    
    var teleAmpPoints: Int {
        var teleAmpPointsScore = 0
        
        for element in teleopSequence {
            switch element {
            case "Amp":
                teleAmpPointsScore += 1
            default:
                break
            }
        }
        
        return teleAmpPointsScore
    }
    
    var teleSpeakerPoints: Int {
        var teleSpeakerPointsScore = 0
        
        for element in teleopSequence {
            switch element {
            case "Speaker":
                teleSpeakerPointsScore += 2
            default:
                break
            }
        }
        
        return teleSpeakerPointsScore
    }
    
    var teleSpeakerAmplifiedNotes: Int {
        var teleAmpedSpeakerPointsScore = 0
        
        for element in teleopSequence {
            switch element {
            case "Amped Speaker":
                teleAmpedSpeakerPointsScore += 5
            default:
                break
            }
        }
        
        return teleAmpedSpeakerPointsScore
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
                
//                                    HStack{
//                                        Text("Team: ")
//                                            //.padding(.trailing, 20)
//                
//                                        NavigationLink(
//                                            destination: TeamSearchView(selectedTeamName: $selectedTeamName, selectedTeamNumber: $selectedTeamNumber),
//                                        label: {
//                                            HStack {
//                                                //
//                                            }
//                                        })
//                
//                                        TextField("Enter team", text: $typedTeam)
//                                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                                            .keyboardType(.decimalPad)
//                                            .focused($isTeamFocused)
//                                            .onChange(of: isTeamFocused) {
//                                                activeTextField = .team
//                                            }
//                
//                                            .toolbar {
//                                                ToolbarItemGroup(placement: .keyboard) {
//                                                    if activeTextField == .team {
//                                                    Spacer()
//                                                        Button("Enter") {
//                                                            hideKeyboard()
//                
//                                                            let teamDisplay = teamNameFromNumber
//                
//                                                            if teamDisplay == "none" {
//                                                                typedTeam = ""
//                                                                showTeamNumAlert = true
//                                                            } else {
//                                                                typedTeam = teamDisplay
//                                                                selectedTeamNumber = Int(typedTeam)
//                                                                selectedTeamName = teamDisplay
//                                                            }
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                    }
                
//                                    HStack {
//                                        NavigationLink(
//                                            destination: TeamSearchView(selectedTeamName: $selectedTeamName, selectedTeamNumber: $selectedTeamNumber),
//                                        label: {
//                                            Text("Team: ")
//                                        })
//                                        .frame(width: 70)
//                
//                                        if isEditing {
//                                            Spacer()
//                                            ZStack{
//                                                TextField("Enter team number \u{200c}", text: $typedTeam)
//                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                                                    .multilineTextAlignment(.trailing)
//                                                    .keyboardType(.decimalPad)
//                                                    .focused($isTeamFocused)
//                                                    .onChange(of: isTeamFocused) {
//                                                        activeTextField = .team
//                                                    }
//                                                    .frame(width: 175)
//                                                    .toolbar {
//                                                        ToolbarItemGroup(placement: .keyboard) {
//                                                            if activeTextField == .team {
//                                                                Spacer()
//                                                                Button("Enter") {
//                                                                    hideKeyboard()
//                
//                                                                    let teamDisplay = teamNameFromNumber
//                
//                                                                    if teamDisplay == "none" {
//                                                                        typedTeam = ""
//                                                                        showTeamNumAlert = true
//                                                                    } else {
//                                                                        //typedTeam = teamDisplay
//                                                                        selectedTeamNumber = Int(typedTeam)
//                                                                        selectedTeamName = teamDisplay
//                                                                        isEditing.toggle()
//                                                                    }
//                                                                }
//                                                            }
//                                                        }
//                                                    }
//                                            }
//                                        } else {
//                                            Spacer()
//                                            Text(textFieldDisplay)
//                                                .onTapGesture {
//                                                    isEditing.toggle()
//                                                    typedTeam = ""
//                                                }
//                                        }
//                
//                                    }
                
                                    NavigationLink(
                                        destination: TeamSearchView(selectedTeamName: $selectedTeamName, selectedTeamNumber: $selectedTeamNumber),
                                    label: {
                                        HStack {
                                            Text("Team:")
                                            Spacer()
                                            if selectedTeamName != nil {
                                                Text("\(String(selectedTeamNumber ?? 0)) : \(selectedTeamName ?? "")")
                                                    .foregroundColor(selectedTeamName != nil ? .primary : .gray)
                                            } else {
                                                Text("")
                                                    .foregroundColor(selectedTeamName != nil ? .primary : .gray)
                                            }
                                        }
                                    })
                
                                    HStack {
                                        Text("Match Number: ")
                
                                        Spacer()
                
                                        TextField("Match Number", value: $matchNumber, format: .number)
                                            .textFieldStyle(.roundedBorder)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 80)
                                            .focused($isMatchFocused)
                                            .onChange(of: isMatchFocused) { _ in
                                                activeTextField = .matchNumber
                                            }
                                            .toolbar {
                                                ToolbarItemGroup(placement: .keyboard) {
                                                    if activeTextField == .matchNumber {
                                                        Spacer()
                                                        Button("Done") {
                                                            hideKeyboard()
                                                        }
                                                    }
                                                }
                                            }
                                    }
                
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
                                                .onChange(of: leftAuto, initial: false) { _,_ in
                                                    if leftAuto == true {
                                                        autoSequence.insert("Left", at: 0)
                                                    } else {
                                                        if !autoSequence.isEmpty {
                                                            autoSequence.removeFirst()
                                                        }
                                                    }
                                                }
                                                .padding([.bottom, .top], 10)
                                    }
                                }
                
                                Section {
                
                                    VStack {
                
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Text("CO-OPERTITION")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                
                                        Divider()
                
                                        Toggle("Offered Co-Opertition:", isOn: $offeredCoop)
                                            .padding([.bottom, .top], 10)
                
                                        Toggle("Did Co-Operate:", isOn: $didCoop)
                                            .padding([.bottom, .top], 10)
                
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
                
                                        Stepper("Drops: \(drops)", value: $drops, in: 0...100)
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
                                            .onChange(of: park) { _ in
                                                if park {
                                                    climbed = false
                                                    harmony = false
                                                }
                                            }
                                        Toggle("Onstage Climb:", isOn: $climbed)
                                            .disabled(park == true)
                                        Toggle("Harmony:", isOn: $harmony)
                                            .disabled(park == true)
                
                                    }
                                    VStack {
                
                                        Picker("Trap: ", selection: $trap) {
                                            ForEach(trapOutcomes, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                        .padding(5)
                
                                        Stepper("Traps: \(numTraps)", value: $numTraps, in: 0...3)
                                            .padding(5)
                
                                    }
                                }
                
                                Section{
                                    VStack {
                
                                        HStack {
                                            Spacer()
                                            Text("HUMAN PLAYER")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                
                                        Divider()
                
                                        Picker("Amp Mike: ", selection: $ampMike) {
                                            ForEach(mikeOutcomes, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                        Picker("Source Mike: ", selection: $sourceMike) {
                                            ForEach(mikeOutcomes, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                        Picker("Center Mike: ", selection: $centerMike) {
                                            ForEach(mikeOutcomes, id: \.self) {
                                                Text($0)
                                            }
                                        }
                
                                    }
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
                
                HStack{
                    Spacer()
                    if !qr_string.isEmpty {
                        Image(uiImage: generateQRCode(from: qr_string))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    } else {
                        Image(uiImage: generateQRCode(from: "https://tinyurl.com/mrxpbjk5"))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                    Spacer()
                }
                
                Button(action: {
                    generator.impactOccurred(intensity: 1)
                    
                    let matchScoutDataInstance = matchScoutData(
                        
                        scoutname: UserManager.currentUser?.fullname ?? "anonymous",
                        teamnumber: selectedTeamNumber ?? 0000,
                        matchnumber: matchNumber ?? 0,
                        alliance: selectedAlliance,
                        
                        //autoSequence: autoSequence,
                        //teleopSequence: teleopSequence,
                        
                        autoamppoints: autoAmpPoints,
                        autospeakerpoints: autoSpeakerPoints,
                        autoleftzone: leftAuto,
                        teleamppoints: teleAmpPoints,
                        telespeakerpoints: teleSpeakerPoints,
                        telespeakeramplifiedpoints: teleSpeakerAmplifiedNotes,
                        
                        drops: drops,
                        
                        climbed: climbed,
                        parked: park,
                        
                        harmony: harmony,
                        trap: trap,
                        numtraps: numTraps,
                        offeredcoop: offeredCoop,
                        didcoop: didCoop,
                        
                        ampmike: ampMike,
                        sourcemike: sourceMike,
                        centermike: centerMike,
                        
                        extranotes: notes
                        
                        //score: gameScore
                    )
                    
                    do {
                        let jsonData = try JSONEncoder().encode(matchScoutDataInstance)
                            let jsonString = String(data: jsonData, encoding: .utf8)!
                        qr_string = jsonString
                    } catch {
                        print(error)
                    }
                    
                    if networkMonitor.isConnected {
                        // Upload data
                        Task {
                            await dataManager.uploadMatchData(matchData: matchScoutDataInstance)
                        }
                        
                        // Show success alert
                        showingSuccessAlert = true
                    } else {
                        // Save data locally
                        print("Saving data locally")
                        saveDataLocally(matchData: matchScoutDataInstance)
                        
                        // Show alert indicating data was saved locally
                        showingLocalSaveAlert = true
                    }
                    
                    // Reset all values
                    resetValues()
                    
                }, label : {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                    
                })
                //.disabled(!formIsInvalid)
                .frame(minWidth: 0, maxWidth: .infinity)
                .buttonStyle(GrowingButton())
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(accentColor, lineWidth: 2)
                    
                )
            }
            .scrollContentBackground(.hidden)
            .onAppear {
                Task{
                    await teamsViewModel.fetchTeamsForEvent(eventCode: "All")
                    teams = teamsViewModel.allTeams
                }
            }
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
        .accentColor(accentColor)
        .alert("Data Uploaded Successfully!", isPresented: $showingSuccessAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("Data Locally Saved Successfully!", isPresented: $showingLocalSaveAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert(isPresented: $showTeamNumAlert) {
            Alert(title: Text("Invalid Team"), message: Text("You entered an invalid team. Try again."), dismissButton: .default(Text("OK")))
        }
    }
    
    
    // get accent color
    var accentColor: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var teamNameFromNumber: String {
        let currentNumber = Int(typedTeam)
        if let team = teams.first(where: { $0.team_number == currentNumber }) {
            return "\(team.nickname ?? "N/A")"
        } else {
            return "none"
        }
    }
    
    var formIsInvalid: Bool {
        return selectedTeamNumber == 0 && selectedAlliance == "Select"
    }
    
    func resetValues() {
        // Set each variable to its default value
        selectedAlliance = "Select"
        selectedTeamNumber = 0
        selectedTeamName = nil
        matchNumber = nil
        
        leftAuto = false
        autoSequence = []
        teleopSequence = []
        
        //        autoAmpPoints = 0
        //        autoSpeakerPoints = 0
        //        teleAmpPoints = 0
        //        teleSpeakerPoints = 0
        //        teleSpeakerAmplifiedNotes = 0
        
        offeredCoop = false
        didCoop = false
        
        ampMike = "Miss"
        sourceMike = "Miss"
        centerMike = "Miss"
        
        drops = 0
        park = false
        climbed = false
        harmony = false
        trap = "Not Attempted"
        
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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

@available(iOS 17.0, *)
#Preview {
    MatchScouting(UserManager: UserManagement())
}
