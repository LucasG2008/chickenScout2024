import SwiftUI

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

struct TeamView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State private var selectedTeamID: String?
    @State private var selectedSortOption: SortOption = .teamNumber
    
    @State private var sortByNumber = true
    @State private var sortByName = false
    
    @State private var selectedEvent = "2024mndu2"
    let eventOptions = ["All", "2024mndu2", "2024wila"]

    enum SortOption: String, Codable, CaseIterable {
        case teamNumber = "Team Number"
        case name = "Name"
    }
    
    @State var teams: [BlueAllianceTeam] = []
    @State private var teamsViewModel = TBAManager()
    
    var teamListItems = Team.loadCSV(from: "teams")
    var eventTeams = EventTeams.loadCSV(from: "eventTeams")
    
    // Get data from The Blue Alliance
    func requestTeamsBlueAlliance() async {
        //Update to get based off events
        //create it to get events and then get team data
        //Northern Lights is 2024mndu2
        //Seven Rivers is 2024wila
        
        guard let blueAllianceTeamsURL = URL(string: selectedEvent == "All" ? 
                                             "https://www.thebluealliance.com/api/v3/teams/0" : "https://www.thebluealliance.com/api/v3/event/\(selectedEvent)/teams") else {
            return
        }
        
        var request = URLRequest(url: blueAllianceTeamsURL)
        
        request.httpMethod = "GET"
        request.addValue("OcfTAuwiy7dvQouocBbQFTstVLeDWUeMF5DoZo4catY50cPSWlGjiGHP1VOiH74A", forHTTPHeaderField: "X-TBA-Auth-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
              if let error = error {
                print("Error: \(error.localizedDescription)")
                return
              }
              guard let data = data else {
                print("No data received")
                return
              }
              do {
                let fetchedTeams = try JSONDecoder().decode([BlueAllianceTeam].self, from: data)
                //print(String(data: data, encoding: .utf8))
                DispatchQueue.main.async {
                  teams = fetchedTeams
                  print(teams)
                }
              } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                print(error)
              }
            }.resume()
        print("asfasdfa")
      }
    
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
                            await requestTeamsBlueAlliance()
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
        .task {
            Task {
                await requestTeamsBlueAlliance()
            }
        }
        .task {
            Task {
                await teamsViewModel.requestAllTeamsFromBlueAlliance()
            }
        }
        
        .accentColor(accentColor)
    }
    
    var searchResults: [BlueAllianceTeam] {
        
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
    
    var teamsToDisplay: [BlueAllianceTeam] {
        if selectedEvent == "All" {
            
            var teamsToDisplay = teamsViewModel.teams
            
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
        } else {
            return searchResults
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
    var teamItem: BlueAllianceTeam

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
