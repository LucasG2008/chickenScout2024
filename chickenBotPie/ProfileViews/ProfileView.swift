//
//  ProfileView.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 1/20/24.
//

import SwiftUI

struct ProfileView: View {

    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var UserManager: UserManagement
    
    @State private var isDeleteAccountAlertPresented = false
    @State private var isSignOutAlertPresented = false
    
    var body: some View {
        if let user = UserManager.currentUser {
            NavigationStack {
                List {
                    
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            
                            VStack (alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                
                            }
                        }
                    }
                    
                    Section ("General"){
                        HStack {
                            SettingsRowView(imageName: "gear",
                                            title: "Version",
                                            tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        HStack {
                            SettingsRowView(imageName: "chart.bar",
                                            title: "Matches Scouted",
                                            tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            Text("\(UserManager.matchesScouted)")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Section ("Account"){
                        Button {
                            isSignOutAlertPresented.toggle()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill",
                                            title: "Sign Out",
                                            tintColor: .red)
                        }
                        .alert(isPresented: $isSignOutAlertPresented) {
                            Alert(
                                title: Text("Sign Out"),
                                message: Text("Are you sure you want to sign out?"),
                                primaryButton: .default(Text("Cancel")),
                                secondaryButton: .destructive(Text("Sign Out")) {
                                    withAnimation {
                                        UserManager.signOut()
                                    }
                                }
                            )
                        }
                        
                        Button {
                            isDeleteAccountAlertPresented.toggle()
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill",
                                            title: "Delete Account",
                                            tintColor: .red)
                        }
                        .alert(isPresented: $isDeleteAccountAlertPresented) {
                            Alert(
                                title: Text("Delete Account"),
                                message: Text("Are you sure you want to permanently delete your account?"),
                                primaryButton: .default(Text("Cancel")),
                                secondaryButton: .destructive(Text("Delete")) {
                                    // delete account
                                }
                            )
                        }
                    }
                }
                .navigationTitle("Profile")
                .navigationBarHidden(false)
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
            .task {
                Task {
                    await UserManager.getMatchesScouted(name: UserManager.currentUser?.fullname ?? "none")
                }
            }
        }
    }
}

#Preview {
    ProfileView(UserManager: UserManagement())
}
