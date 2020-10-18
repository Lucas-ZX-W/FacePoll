//
//  FloatingBar.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct FloatingBar: View {
    let creatingNewSession: Bool
    @ObservedObject var camera = CameraInput()

    var mainView: some View {
        VStack {
            Spacer()
            HStack {
                if creatingNewSession {
                    Text("Your participants' emotions:")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                } else {
                    Text("Your current emotion:")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    Text(camera.emotion.description)
                        .font(.system(size: 60))
                        .onAppear {
                            camera.start()
                        }
                        .onDisappear {
                            camera.stop()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .emotionalWindowOpen)) { _ in
                            camera.start()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .emotionalWindowClose)) { _ in
                            camera.stop()
                        }
                    // if let image = camera.image {
                    //     Image(nsImage: image)
                    // }
                }
            }
            Spacer()
        }
        .padding()
        .frame(idealWidth: 350, idealHeight: 120)
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

struct FloatingBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FloatingBar(creatingNewSession: true)
            FloatingBar(creatingNewSession: false)
        }
    }
}
