//
//  ScoutingView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/17/24.
//

import SwiftUI

struct ScoutingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var UserManager: UserManagement
    @State private var dataManager = DataManager()
    
    @State private var selectedView: String?
    
    @State private var isSignOutAlertPresented = false
    
    var body: some View {
        
        // navigation stack to navigate options
        NavigationStack {
            List {
                
                Section {
                    
                    Button {
                        selectedView = "pastMatchData"
                    } label: {
                        HStack{
                            Text("Past Match Data")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    
                    Button {
                        selectedView = "scoutedPits"
                    } label: {
                        HStack{
                            Text("Scouted Pits")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    
//                    Button {
//                        selectedView = "pastPits"
//                    } label: {
//                        HStack{
//                            Text("Past Pit Data")
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                        }
//                    }
                    
                } header: {
                    Text("Past Data")
                }
                
//                Section {
//                    
//                    HStack {
//                        Button{
//                            //check in
//                            Task {
//                                await dataManager.fetchSchedule(fullname: UserManager.currentUser?.fullname ?? "anonymous")
//                            }
//                        } label: {
//                            HStack {
//                                Text("Check In")
//                                    .fontWeight(.semibold)
//                                Image(systemName: "arrow.right")
//                            }
//                            .foregroundStyle(.white)
//                            .frame(width: UIScreen.main.bounds.width/2 - 32, height: 48)
//                        }
//                        .background(
//                            LinearGradient(gradient: colorScheme == .dark ? Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]) : Gradient(colors: [Color(hex: "#0047AB").opacity(1), Color(hex: "#0047AB").opacity(0.8)]), startPoint: .top, endPoint: .bottom)
//                        )
//                        .cornerRadius(5)
//                        
//                        Spacer()
//                        
//                        Button{
//                            //check out
//                        } label: {
//                            HStack {
//                                Text("Check Out")
//                                    .fontWeight(.semibold)
//                                Image(systemName: "arrow.right")
//                            }
//                            .foregroundStyle(.white)
//                            .frame(width: UIScreen.main.bounds.width/2 - 32, height: 48)
//                        }
//                        .background(
//                            LinearGradient(gradient: colorScheme == .dark ? Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]) : Gradient(colors: [Color(hex: "#0047AB").opacity(1), Color(hex: "#0047AB").opacity(0.8)]), startPoint: .top, endPoint: .bottom)
//                        )
//                        .cornerRadius(5)
//                    }
//                    
//                } header: {
//                    Text("Scheduler")
//                }
                
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
                
//                Section {
//                    Button  {
//                        isSignOutAlertPresented.toggle()
//                    } label: {
//                        Text("Force Sign Out")
//                    }
//                }
                
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

                if selectedView == "pastMatchData" {
                    PastMatchView()
                        .navigationBarTitle("Match Data", displayMode: .inline)
                } else if selectedView == "scoutedPits" {
                    ScoutedPitsView()
                        .navigationBarTitle("Scouted Pits", displayMode: .inline)
                } else {
                    // nothing
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
