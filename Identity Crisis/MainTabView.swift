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
                }.padding()
            
            EmotionalView()
                .tabItem {
                    Text("♥️")
                    Text("Emotions")
                }.padding()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
