//
//  ScoutingView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/17/24.
//

import SwiftUI

struct ScoutingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var selectedView: String?
    
    @State private var isSignOutAlertPresented = false
    
    @ObservedObject var UserManager: UserManagement
    
    var body: some View {
        
        // navigation stack to navigate options
        NavigationStack {
            List {
                
                
                Section {
                    Button {
                        selectedView = "pitScouting"
                    } label: {
                        Text("Pit Scouting")
                    }
                    
                    Button {
                        selectedView = "standScouting"
                    } label: {
                        Text("Match Scouting")
                    }
                
                } header: {
                    Text("Add Data")
                }
                
                
                
                Section {
                    
                    Button {
                        selectedView = "pastMatchData"
                    } label: {
                        Text("Past Match Data")
                    }
                    
                    Button {
                        selectedView = "pastPitData"
                    } label: {
                        Text("Past Pit Data")
                    }
                    
                    
                } header: {
                    Text("Past Data")
                }
                
                Section {
                    VStack{
                        Image("data-image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .cornerRadius(10)
                            .padding()
                    }
                }
                
                Section {
                    Button  {
                        isSignOutAlertPresented.toggle()
                    } label: {
                        Text("Force Sign Out")
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
            
            
            
            .navigationTitle("Scouting")
            .navigationBarHidden(false)
            // ask for sign out confirmation
            .alert(isPresented: $isSignOutAlertPresented) {
                Alert(
                    title: Text("Sign Out"),
                    message: Text("Are you sure you want to sign out?"),
                    primaryButton: .default(Text("Cancel")),
                    secondaryButton: .destructive(Text("Sign Out")) {
                        UserManager.signOut()
                    }
                )
            }
            // open up detailed view for scouting
            .navigationDestination(isPresented: Binding(
                            get: { selectedView != nil },
                            set: { _ in selectedView = nil }
                        )) {
                            if selectedView == "pitScouting" {
                                PitScouting()
                                    .navigationBarTitle("Pit Scouting", displayMode: .inline)
                            } else if selectedView == "pastMatchData" {
                                PastMatchView()
                                    .navigationBarTitle("Match Data", displayMode: .inline)
                            } else if selectedView == "pastPitData" {
                                PastPitView()
                                    .navigationBarTitle("Past Data", displayMode: .inline)
                            } else {
                                MatchScouting()
                                    .navigationBarTitle("Match Scouting", displayMode: .inline)
                            }
                        }
            
        }
        .accentColor(accentColor)
    }
    
    // get accent color
    var accentColor: Color {
            return colorScheme == .dark ? .white : .black
        }
}

#Preview {
    ScoutingView(UserManager: UserManagement())
}
