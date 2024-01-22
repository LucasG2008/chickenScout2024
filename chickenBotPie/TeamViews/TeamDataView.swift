//
//  TeamDataView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/15/24.
//

import SwiftUI
import Charts

struct TeamDataView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var forTeamID: String
    
    var teams = Team.loadCSV(from: "teams")
    
    var teamHistData = TeamHistData.loadCSV(from: "teamHistory")

    var body: some View {
        
        // Define line plot colors
        let curColor = Color(hue: 0.65, saturation: 1, brightness: 1)
        let curGradient = LinearGradient(
            gradient: Gradient (
                colors: [
                    curColor.opacity(0.5),
                    curColor.opacity(0.2),
                    curColor.opacity(0.05),
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
        
        let selectedTeam = filterTeam(forTeamID: self.forTeamID)
        
        
        let wins = Double(selectedTeam!.wins) ?? 0
        let losses = Double(selectedTeam!.losses) ?? 0
        let ties = Double(selectedTeam!.ties) ?? 0

        let data: [(Double, Color)] = [
            (wins, Color.blue),
            (losses, Color.red),
            (ties, Color.purple)
        ]
        
        List{
            Section(header:HStack {
                Spacer()
                Text(selectedTeam!.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }) {
                ForEach(teams.filter {$0.teamNum == forTeamID}) {
                    team in
                    Text("Team Num: " + team.teamNum)
                    Text("Location: " + team.state + ", " + team.country)
                    Text("Rookie Year: " + team.rookie_year)
                    Text("Active: " + team.active)
                    HStack {
                        Text("Wins: " + team.wins)
                        Spacer()
                        Text("Losses: " + team.losses)
                        Spacer()
                        Text("Ties: " + team.ties)
                        
                    }
                    Text("Total Games: " + team.count)
                }
            }
            if let latestYearData = teamHistData.filter({ $0.teamNum == forTeamID }).max(by: { $0.year < $1.year }) {
                Section(header: HStack {
                    Spacer()
                    Text("Rankings (\(latestYearData.year))")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }) {
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(height: 80)
                            .overlay(
                                VStack {
                                    Text(latestYearData.total_epa_rank)
                                        .foregroundColor(.white)
                                        .font(.system(size: 24, weight: .bold))
                                    Text("Worldwide")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                    Text("out of \(latestYearData.total_team_count)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                }
                                    .padding(10)
                            )
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(height: 80)
                            .overlay(
                                VStack {
                                    Text(latestYearData.country_epa_rank)
                                        .foregroundColor(.white)
                                        .font(.system(size: 24, weight: .bold))
                                    Text(latestYearData.country)
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                    Text("out of \(latestYearData.country_team_count)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                }
                                    .padding(10)
                            )
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(height: 80)
                            .overlay(
                                VStack {
                                    Text(latestYearData.state_epa_rank)
                                        .foregroundColor(.white)
                                        .font(.system(size: 24, weight: .bold))
                                    Text(latestYearData.state)
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                    Text("out of \(latestYearData.state_team_count)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                    
                                }
                                    .padding(10)
                            )
                    }
                    HStack {
                        Spacer()
                        Text("Percentile")
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(height: 80)
                        .overlay(
                            VStack {
                                HStack {
                                    VStack {
                                        Text(latestYearData.total_epa_percentile + "%")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .bold))
                                        Text("Worldwide")
                                    }
                                    Spacer()
                                    VStack {
                                        Text(latestYearData.country_epa_percentile + "%")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .bold))
                                        Text(latestYearData.country)
                                    }
                                    Spacer()
                                    VStack {
                                        Text(latestYearData.state_epa_percentile + "%")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .bold))
                                        Text(latestYearData.state)
                                    }
                                }
                            }
                            .padding(10)
                        )
                }
            }
            
            Section(header:HStack {
                Spacer()
                Text("Data Visualization")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }) {
                VStack {
                    Text("Win/Loss Ratio")
                        .font(.title2)
                        .padding(.bottom, 10)
                    
                    LegendView(winsValue: selectedTeam!.wins, lossesValue: selectedTeam!.losses, tiesValue: selectedTeam!.ties)
                    
                    PieChartView(data: data)
                        .padding()
                }
            }
            
            Section() {
                VStack {
                    Text("Historic Winrate")
                        .font(.title2)
                        .padding(.bottom, 10)
                    Chart {
                        ForEach(teamHistData.filter {$0.teamNum == forTeamID}) { yearData in
                            LineMark(
                                x: .value("Year", yearData.year),
                                y: .value("Winrate", Double(yearData.winrate)!)
                            )
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            .foregroundStyle(curColor)
                            .symbol() {
                                    Circle()
                                        .fill(curColor)
                                        .frame(width: 10)
                                }
                            AreaMark(
                                    x: .value("Year", yearData.year),
                                    y: .value("Winrate", Double(yearData.winrate)!)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(curGradient)
                        
                        }
                    }
                    .chartXAxis(content: {
                        AxisMarks { value in
                            AxisValueLabel {
                                if let year = value.as(String.self) {
                                    if let yearInt = Int(year), yearInt % 4 == 0 {
                                        Text(year)
                                    }
                                }
                            }
                            AxisTick(centered: true)
                            AxisGridLine(
                                centered: false,
                                stroke: StrokeStyle(
                                    dash: [2]))
                            .foregroundStyle(Color.blue)
                        }
                    })
                    .frame(height: 200)
                    .chartYScale(domain: 0.0...1.0)
                    .chartYAxis {
                        AxisMarks(values: .automatic(desiredCount: 5))
                    }

                }
            }

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
}

// Create function to filter team data based on teamNum
func filterTeam(forTeamID teamID: String)->Team? {
    let teams = Team.loadCSV(from: "teams")
    
    if let teamIndex = teams.firstIndex(where: {$0.teamNum == teamID}) {
        return teams[teamIndex]
    } else {
        return nil
    }
}

// Create legend for win/loss/tie pie chart
struct LegendView: View {
    var winsValue: String
    var lossesValue: String
    var tiesValue: String
    
    init(winsValue: String, lossesValue: String, tiesValue: String) {
            self.winsValue = winsValue
            self.lossesValue = lossesValue
            self.tiesValue = tiesValue
        }
    
    var body: some View {
        
        let intWinsValue = Double(winsValue)!
        let intLossesValue = Double(lossesValue)!
        let intTiesValue = Double(tiesValue)!
        
        let totalGames = intWinsValue + intLossesValue + intTiesValue
        
            HStack {
                LegendItemView(color: Color.blue, label: "Wins", number: winsValue, totalGames: totalGames)
                LegendItemView(color: Color.red, label: "Losses", number: lossesValue, totalGames: totalGames)
                LegendItemView(color: Color.purple, label: "Ties", number: tiesValue, totalGames: totalGames)
            }
    }
}

struct LegendItemView: View {
    var color: Color
    var label: String
    var number: String
    var totalGames: Double

    var body: some View {
        let intNumber = Double(number)!
        
        VStack {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                Text(label + " (\(String(format: "%.2f", (intNumber/totalGames*100)))%) ")
            }
            .padding(.horizontal, 5)
            
        }
    }
}

struct TeamDataView_Previews: PreviewProvider {
    static var previews: some View {
        TeamDataView(forTeamID: "3082")
    }
}

