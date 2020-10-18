//
//  ContentView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct ContentView: View {
    let foregroundColor: Color = Color(red: 22/255, green: 67/255, blue: 86/255)
    
    var body: some View {
        VStack(spacing: 50) {
            HStack(spacing: 40) {
                Text("Hi Gladys! It's time to be yourself!")
                    .font(Font.title.weight(.bold))
                    .foregroundColor(foregroundColor)
                Image("testPic")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 7)
                    .overlay(Circle().stroke(Color.orange, lineWidth: 5))
            }
            
            HStack(spacing: 40) {
//                NavigationLink(destination: CamView()) {
//                    Text("Create a session")
//                        .font(.system(size: 20))
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .padding(10)
//                        .background(foregroundColor)
//                        .cornerRadius(10)
//                }
//                .buttonStyle(PlainButtonStyle())
//                .background(foregroundColor)
//                .simultaneousGesture(TapGesture().onEnded{
//                    NSApp.sendAction(#selector(AppDelegate.openEmotionalWindow), to: nil, from:nil)
//                })
                Button(action: {
                    NSApp.sendAction(#selector(AppDelegate.openEmotionalWindow), to: nil, from:nil)
//                    NSApp.sendAction(#selector(AppDelegate.openCamWindow), to: nil, from:nil)
                }) {
                    Text("Create a session")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(foregroundColor)
                        .cornerRadius(10)
                }.buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    NSApp.sendAction(#selector(AppDelegate.openEmotionalWindow), to: nil, from:nil)
//                    NSApp.sendAction(#selector(AppDelegate.openCamWindow), to: nil, from:nil)
                }) {
                    Text("Join a session")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(foregroundColor)
                        .cornerRadius(10)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
