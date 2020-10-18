//
//  MainTabView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct MainTabView: View {
    var mainView: some View {
        CustomMainTabView(
            tabBarPosition: .top,
            content: [
                (
                    tabText: "Menu",
                    tabIconName: "🌐",
                    view: AnyView(ContentView())
                ),
                (
                    tabText: "Statistics",
                    tabIconName: "📋",
                    view: AnyView(StatisticsView()
                                    .environmentObject(History.shared))
                ),
                (
                    tabText: "Settings",
                    tabIconName: "⚙️",
                    view: AnyView(
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("Third Tab!")
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.yellow.opacity(0.5))
                    )
                )
            ]
        )
    }

    var body: some View {
        if #available(OSX 11.0, *) {
            mainView
                .ignoresSafeArea()
        } else {
            mainView
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
