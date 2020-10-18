//
//  MainTabView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
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
                    view: AnyView(StatisticsView())
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
                        .background(Color.yellow)
                    )
                )
            ]
        )
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
