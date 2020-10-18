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

    var body: some View {
        HStack() {
            if creatingNewSession {
                Text(" Your participants' emotions:")
                    .font(.system(size: 10))
                    .fontWeight(.semibold)
            } else {
                Text(" Your current emotion:")
                    .font(.system(size: 10))
                    .fontWeight(.semibold)
            }
            VStack {
                Text(camera.emotion.description)
                    .font(.system(size: 30))
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
        }.frame(idealWidth: .infinity, idealHeight: .infinity)
    }
}

//struct FloatingBar_Previews: PreviewProvider {
//    static var previews: some View {
//        FloatingBar()
//    }
//}
