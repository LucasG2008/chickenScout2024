import SwiftUI

struct TeamView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State private var selectedTeamID: String?
    @State private var selectedSortOption: SortOption = .teamNumber
    
    @State private var sortByNumber = true
    @State private var sortByWinrate = false
    @State private var selectedEvent = "All"
    
    let eventOptions = ["All", "Northern Lights", "Seven Rivers"]

    enum SortOption: String, Codable, CaseIterable {
        case teamNumber = "Team Number"
        case winRate = "Win Rate"
    }
    
    var teamListItems = Team.loadCSV(from: "teams")
    
    var eventTeams = EventTeams.loadCSV(from: "eventTeams")
    
    var body: some View {
        
        // navigation stack to display all the robotics teams
        NavigationStack {
            
            VStack(spacing: 0) {
                
                HStack {
                    // Toggle Button 1
                    Button(action: {
                        
                        sortByNumber.toggle()
                        selectedSortOption = SortOption.teamNumber
                        
                        if sortByWinrate == true {
                            sortByWinrate.toggle()
                        }
                    }) {
                        Capsule()
                            .foregroundColor(sortByNumber ? .blue : .clear)
                            .frame(height: 40)
                            .overlay(Text("Number").foregroundColor(colorScheme == .dark ? .white : .black))
                            .background(Capsule().stroke(lineWidth: 2))
                    }
                    

                    // Toggle Button 2
                    Button(action: {
                        
                        sortByWinrate.toggle()
                        selectedSortOption = SortOption.winRate
                        
                        if sortByNumber == true {
                            sortByNumber.toggle()
                        }
                    }) {
                        Capsule()
                            .foregroundColor(sortByWinrate ? .blue : .clear)
                            .frame(height: 40)
                            .overlay(Text("Winrate").foregroundColor(colorScheme == .dark ? .white : .black))
                            .background(Capsule().stroke(lineWidth: 2))
                    }

                    // Picker
                    Picker("Select Event", selection: $selectedEvent) {
                        ForEach(eventOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 160, height: 40)
                    .capsuleButtonStyle()
                }
                .padding([.leading, .trailing])
                .padding([.bottom, .top], 10)
                
                if selectedEvent == "All" {
                    
                    List(filteredTeams) { teamItem in
                        Button {
                            selectedTeamID = teamItem.teamNum
                        } label: {
                            TeamRow(teamItem: teamItem)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Teams")
                    .navigationBarHidden(false)
                    .searchable(text: $searchText)
                    // open up detailed view when a team is clicked
                    .navigationDestination(isPresented: Binding(
                        get: { selectedTeamID != nil },
                        set: { _ in selectedTeamID = nil }
                    )) {
                        teamDetailsView(withEvent: false)
                    }
                    
                } else {
                    List(filterByEvent) { teamItem in
                        Button {
                            selectedTeamID = teamItem.teamNum
                        } label: {
                            TeamEventDataRow(teamEventItem: teamItem)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Teams")
                    .navigationBarHidden(false)
                    .searchable(text: $searchText)
                    // open up detailed view when a team is clicked
                    .navigationDestination(isPresented: Binding(
                        get: { selectedTeamID != nil },
                        set: { _ in selectedTeamID = nil }
                    )) {
                        teamDetailsView(withEvent: true)
                    }
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
    }

    // filter teams when searching
    var filteredTeams: [Team] {
        var teamsToDisplay = teamListItems

        switch selectedSortOption {
        case .teamNumber:
            teamsToDisplay.sort { Double($0.teamNum)! < Double($1.teamNum)! }
        case .winRate:
            teamsToDisplay.sort { $0.winrate > $1.winrate }
        }

        if searchText.isEmpty {
            return teamsToDisplay
        } else {
            return teamsToDisplay.filter { teamItem in
                teamItem.teamNum.localizedCaseInsensitiveContains(searchText) ||
                teamItem.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var filterByEvent: [EventTeams] {
        var eventTeams = eventTeams
        
        switch selectedSortOption {
        case .teamNumber:
            eventTeams.sort { (Double($0.teamNum) ?? 0000) < (Double($1.teamNum) ?? 0000) }
        case .winRate:
            eventTeams.sort { $0.winrate > $1.winrate }
        }
        
        if selectedEvent == "Northern Lights" {
            eventTeams = eventTeams.filter {teamItem in
                teamItem.event == "2024mndu2"
            }
        } else if selectedEvent == "Seven Rivers" {
            eventTeams = eventTeams.filter {teamItem in
                teamItem.event == "2024wila"
            }
        } else {
            return eventTeams
        }
        
        if searchText.isEmpty {
            return eventTeams
        } else {
            return eventTeams.filter { teamItem in
                teamItem.teamNum.localizedCaseInsensitiveContains(searchText) ||
                teamItem.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // get accent color
    var accentColor: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    @ViewBuilder
    private func teamDetailsView(withEvent event: Bool) -> some View {
        if let teamID = selectedTeamID {
            if event {
                if let teamItem = eventTeams.first(where: { $0.teamNum == teamID }) {
                    TeamDataView(selectedTeamID: teamItem.teamNum)
                        .navigationBarTitle("Team Details", displayMode: .inline)
                }
            } else {
                if let teamItem = teamListItems.first(where: { $0.teamNum == teamID }) {
                    Text(selectedTeamID ?? "none")
                    TeamDataView(selectedTeamID: teamItem.teamNum)
                        .navigationBarTitle("Team Details", displayMode: .inline)
                }
            }
        } else {
            // Handle the case when selectedTeamID is nil (optional)
            // For example, you might present an empty view or some default content.
            Text("No team selected")
        }
    }
}

extension View {
    func capsuleButtonStyle() -> some View {
        self
            .background(Capsule().stroke(lineWidth: 2))
    }
}

struct TeamRow: View {
    var teamItem: Team

    var body: some View {
        HStack {
            Text(teamItem.teamNum + ":")
            Text(teamItem.name)
        }
        .padding(8)
    }
}

struct TeamEventDataRow: View {
    var teamEventItem: EventTeams
    
    var body: some View {
        HStack {
            Text(teamEventItem.teamNum + ":")
            Text(teamEventItem.name)
        }
        .padding(8)
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}
