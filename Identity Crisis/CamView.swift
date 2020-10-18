//
//  CamView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-18.
//

import SwiftUI

struct CamView: View {
    @ObservedObject var camera = CameraInput()
    @ObservedObject var fakeData = Aggregated(session: "hello", debug: true)
    var body: some View {
        VStack {
            HStack {
                Text(camera.emotion.description)
                if let image = camera.image {
                    Image(nsImage: image)
                }
            }
            if let error = camera.error {
                Text(error.localizedDescription)
            }
            List(Emotion.allCases) { key in
                VStack {
                    Text(key.description)
                    Text("\((fakeData.reactions[key] ?? 0) * 100)%")
                }
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
