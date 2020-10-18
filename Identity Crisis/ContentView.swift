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
            HStack {
                Text(camera.emotion.description)
                    .font(.largeTitle)
                if let image = camera.image {
                    Image(nsImage: image)
                }
            }
            if let error = camera.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
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
