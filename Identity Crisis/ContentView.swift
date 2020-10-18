//
//  ContentView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    var offsetSign: CGFloat {
        switch colorScheme {
        case .light:
            return 1
        case .dark:
            return -1
        @unknown default:
            return 1
        }
    }

    var body: some View {
        VStack(spacing: 50) {
            HStack(spacing: 40) {
                Text("Hi Gladys! It's time to be yourself!")
                    .font(Font.title.weight(.bold))
                    .foregroundColor(.foregroundColor)
                    .shadow(color: Color.primary.opacity(0.65), radius: 0,
                            x: 0.5 * offsetSign, y: 0.5 * offsetSign)
                Image("testPic")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 7)
                    .overlay(Circle().stroke(Color.orange, lineWidth: 5))
            }
            
            HStack(spacing: 40) {
                // NavigationLink(destination: CamView()) {
                //     Text("Create a session")
                //         .font(.system(size: 20))
                //         .fontWeight(.semibold)
                //         .foregroundColor(.white)
                //         .padding(10)
                //         .background(foregroundColor)
                //         .cornerRadius(10)
                // }
                // .buttonStyle(PlainButtonStyle())
                // .background(foregroundColor)
                // .simultaneousGesture(TapGesture().onEnded {
                //     NSApp.sendAction(#selector(AppDelegate.openEmotionalWindow), to: nil, from:nil)
                // })
                Button(action: {
//                    NSApp.sendAction(#selector(AppDelegate.openEmotionalWindow), to: nil, from: [true, "test"])
                    NSApp.sendAction(#selector(AppDelegate.openAggregateWindow), to: nil, from: nil)
                }) {
                    Text("Create a session")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.foregroundColor)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    NSApp.sendAction(#selector(AppDelegate.openEmotionalWindow), to: nil, from: [false, "test"])
                }) {
                    Text("Join a session")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.foregroundColor)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(idealWidth: 300, idealHeight: 250)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
