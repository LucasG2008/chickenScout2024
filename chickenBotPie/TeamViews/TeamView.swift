import SwiftUI

struct TeamView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State private var selectedTeamID: String?
    @State private var selectedSortOption: SortOption = .teamNumber
    
    @State private var sortByNumber = true
    @State private var sortByName = false
    
    @State private var selectedEvent = "All"
    let eventOptions = ["All", "2024mndu2", "2024wila"]//

    enum SortOption: String, Codable, CaseIterable {
        case teamNumber = "Team Number"
        case name = "Name"
    }
    
    @State var teams: [QuickTeamView] = []
    @State private var teamsViewModel = TBAManager()
    
    var body: some View {
        
        // navigation stack to display all the robotics teams
        NavigationStack {
            
            VStack(spacing: 0) {
                
                HStack {
                    // Number sort
                    Button(action: {
                        sortByNumber.toggle()
                        selectedSortOption = SortOption.teamNumber
                        
                        if sortByName == true {
                            sortByName.toggle()
                        }
                    }) {
                        Capsule()
                            .foregroundColor(sortByNumber ? .blue : .clear)
                            .frame(height: 40)
                            .overlay(Text("Number").foregroundColor(colorScheme == .dark ? .white : .black))
                            .background(Capsule().stroke(lineWidth: 2))
                    }
                    // Name sort
                    Button(action: {
                        sortByName.toggle()
                        selectedSortOption = SortOption.name
                        
                        if sortByNumber == true {
                            sortByNumber.toggle()
                        }
                    }) {
                        Capsule()
                            .foregroundColor(sortByName ? .blue : .clear)
                            .frame(height: 40)
                            .overlay(Text("Name").foregroundColor(colorScheme == .dark ? .white : .black))
                            .background(Capsule().stroke(lineWidth: 2))
                    }
                    // Event Picker
                    Picker("Select Event", selection: $selectedEvent) {
                        ForEach(eventOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .onChange(of: selectedEvent) {
                        Task {
                            await teamsViewModel.fetchTeamsForEvent(eventCode: selectedEvent)
                            
                            switch selectedEvent {
                                case "2024mndu2":
                                    teams = teamsViewModel.mndu2Teams
                                case "2024wila":
                                    teams = teamsViewModel.wilaTeams
                                case "All":
                                    teams = teamsViewModel.allTeams
                                default:
                                    break
                                }
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 160, height: 40)
                    .capsuleButtonStyle()
                }
                .padding([.leading, .trailing])
                .padding([.bottom, .top], 10)
                
                // Display list of teams
                List() {
                    ForEach(teamsToDisplay, id: \.self) {teamItem in
                        Button {
                            selectedTeamID = String(teamItem.team_number ?? 0000)
                        } label: {
                            TeamListRow(teamItem: teamItem)
                        }
                    }
                }
                .navigationDestination(isPresented: Binding(
                    get: { selectedTeamID != nil },
                    set: { _ in selectedTeamID = nil }
                )) {
                    teamDetailsView()
                }
                .searchable(text: $searchText)
                .navigationTitle("Teams")
                .navigationBarHidden(false)
                .scrollContentBackground(.hidden)
            }
            .onAppear {
                Task{
                    await teamsViewModel.fetchTeamsForEvent(eventCode: "All")
                    teams = teamsViewModel.allTeams
                    selectedEvent = "All"
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
    
    var teamsToDisplay: [QuickTeamView] {
            
            var teamsToDisplay = teams
            
            switch selectedSortOption {
                case .teamNumber:
                    teamsToDisplay.sort { $0.team_number ?? 0000 < $1.team_number ?? 0000 }
                case .name:
                    teamsToDisplay.sort { $0.nickname ?? "" < $1.nickname ?? "" }
                }
            
            if searchText.isEmpty {
                return teamsToDisplay
            } else {
                return teamsToDisplay.filter { teamItem in
                    String(teamItem.team_number ?? 0000).localizedCaseInsensitiveContains(searchText) ||
                    String(teamItem.nickname ?? "none").localizedCaseInsensitiveContains(searchText)
                }
            }
    }

    // get accent color
    var accentColor: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    @ViewBuilder
    private func teamDetailsView() -> some View {
        if let teamID = selectedTeamID {
            if let teamItem = teams.first(where: { String($0.team_number ?? 0000) == teamID }) {
                TeamDataView(selectedTeamID: String(teamItem.team_number ?? 0000))
                    .navigationBarTitle("Team Details", displayMode: .inline)
            }
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

struct TeamListRow: View {
    var teamItem: QuickTeamView

    var body: some View {
        HStack {
            Text(String(teamItem.team_number ?? 0000) + ":")
            Text(teamItem.nickname ?? "none")
        }
        .padding(8)
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}
