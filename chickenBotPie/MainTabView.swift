//
//  MainTabView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/21/24.
//

import SwiftUI

@available(iOS 17.0, *)
struct MainTabView: View {
    
    @ObservedObject var UserManager: UserManagement
    
    @State private var presentPopup = false
    @State private var isKeyboardVisible = false
    
    @State private var navigateToMatch = false
    @State private var navigateToPit = false
    
    func dismiss() {
        self.navigateToMatch = false
        self.navigateToPit = false
        self.presentPopup = false
    }
    
    var body: some View {
        
        if navigateToMatch {
            NavigationStack{
                MatchScouting(UserManager: UserManager)
                    .navigationTitle("Match Scouting")
                    .toolbar {
                        
                        ToolbarItem(placement: .topBarLeading) {
                            
                            Button {
                                withAnimation {
                                    dismiss()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.backward")
                                    Text("Back")
                                }
                            }
                        }
                    }
            }
        } else if navigateToPit{
            NavigationStack{
                PitScouting(UserManager: UserManager)
                    .navigationTitle("Pit Scouting")
                    .toolbar {
                        
                        ToolbarItem(placement: .topBarLeading) {
                            
                            Button {
                                withAnimation {
                                    dismiss()
                                }
                            } label: {
                                HStack {
                                    
                                    Image(systemName: "chevron.backward")
                                    Text("Back")
                                }
                            }
                        }
                    }
            }
        } else {
            
            TabView {
                
                Group {
                    HomeView(UserManager: UserManager).tabItem {
                        Text("Home")
                        Image(systemName: "house")
                    }
                    
                    TeamView().tabItem {
                        Text("Teams")
                        Image(systemName: "person.3")
                    }
                    
                    FakeEgg().frame(minWidth: 0)
                    
                    ScoutingView(UserManager: UserManager).tabItem {
                        Text("Scouting")
                        Image(systemName: "list.bullet")
                    }
                    
                    ProfileView(UserManager: UserManager).tabItem {
                        Text("Profile")
                        Image(systemName: "person.circle")
                        
                    }
                }
                .toolbarBackground(.visible, for: .tabBar)
                
            }
            .overlay(alignment: .bottom) {
                if presentPopup == true {
                    PopupView(navigateToMatch: $navigateToMatch, navigateToPit: $navigateToPit)
                        .padding(.bottom, 90)
                }
            }
            .overlay(
                Button {
                    withAnimation {
                        presentPopup.toggle()
                    }
                } label: {
                    VStack {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding()
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            .shadow(color: .white, radius: 3, x: 0, y: 0)
                            
                    }
                    
                    .padding(.bottom)
                }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .opacity(isKeyboardVisible ? 0 : 1)
                
            )
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                        withAnimation {
                            isKeyboardVisible = true
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                        withAnimation {
                            isKeyboardVisible = false
                        }
                    }
        }
        
    }
}

struct PopupView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var navigateToMatch: Bool
    @Binding var navigateToPit: Bool
    
    var body: some View {
        
        VStack(spacing: 10) {
            Text("Select scouting type:")
                .foregroundStyle(.black)
            
            Button {
                withAnimation {
                    navigateToMatch = true
                }
            } label: {
                Text("Match Scouting")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            
            Button {
                withAnimation {
                    navigateToPit = true
                }
            } label: {
                Text("Pit Scouting")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

        }
        .transition(.move(edge: .bottom))
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            Group {
                if colorScheme == .light {
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                        .foregroundStyle(.white)
                } else {
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                }
            }
                
        )
    }
}

@available(iOS 17.0, *)
#Preview {
    MainTabView(UserManager: UserManagement())
}
