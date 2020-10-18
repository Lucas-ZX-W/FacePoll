//
//  MainTabView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Text("🌐")
                    Text("Menu")
                }
            
            EmotionalView()
                .tabItem {
                    Text("♥️")
                    Text("Emotions")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
