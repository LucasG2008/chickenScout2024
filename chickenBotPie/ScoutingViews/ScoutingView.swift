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
