//
//  EmotionalView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct EmotionalView: View {
    var body: some View {
        VStack {
            Text("How am I feeling?")
            Button(action: {
                NSApp.sendAction(#selector(AppDelegate.openEmotionalWindow), to: nil, from:nil)
            }) {
                Text("Open floaty emotions")
            }
        }
    }
}

struct EmotionalView_Previews: PreviewProvider {
    static var previews: some View {
        EmotionalView()
    }
}
