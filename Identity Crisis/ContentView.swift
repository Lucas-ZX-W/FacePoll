//
//  ContentView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var camera = CameraInput()
    var body: some View {
        VStack {
            Text(camera.emotion.description)
            if let error = camera.error {
                Text(error.localizedDescription)
            }
        }
        .onAppear {
            camera.start()
        }
        .onDisappear {
            camera.stop()
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
