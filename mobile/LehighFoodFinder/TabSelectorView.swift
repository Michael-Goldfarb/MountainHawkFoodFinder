//
//  TabSelectorView.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 7/19/23.
//

import SwiftUI

struct TabSelectorView: View {
    @State private var selectedTab: Int = 1 // Set the initial tab index to 1 (Home)

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(0) // Set the tag for the ProfileView

            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1) // Set the tag for the HomeView

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(2) // Set the tag for the SettingsView
        }
        .accentColor(.brown) // Set the active tab color
        .navigationBarHidden(true)
        .onAppear {
            selectedTab = 1 // Set the initial selected tab to 1 (Home)
        }
    }
}

struct TabSelectorView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        TabSelectorView()
    }
}
