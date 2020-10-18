//
//  CamView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-18.
//

import SwiftUI

struct CamView: View {
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
        Text("Yeet")
    }
}

struct CamView_Previews: PreviewProvider {
    static var previews: some View {
        CamView()
    }
}
