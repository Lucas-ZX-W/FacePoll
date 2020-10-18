//
//  CamView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-18.
//

import SwiftUI

struct CamView: View {
//    @ObservedObject var camera = CameraInput()
    @ObservedObject var fakeData = Aggregated(session: "hello", debug: true)
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Emotion.allCases) { key in
                Text(key.description)
                    .font(.system(size: 30))
                    .frame(width: (CGFloat((fakeData.reactions[key] ?? 0)) * 600), height: 80)
                    .background(key.color)
            }
            .animation(.easeInOut)
            .transition(.slide)
        }.frame(idealWidth: 600, idealHeight: 80)
//        VStack {
//            List(Emotion.allCases) { key in
//                VStack {
//                    Text(key.description)
//                    Text("\((fakeData.reactions[key] ?? 0) * 100)%")
//                }
//            }
//
//        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CamView_Previews: PreviewProvider {
    static var previews: some View {
        CamView()
    }
}


//            HStack {
//                Text(camera.emotion.description)
//                if let image = camera.image {
//                    Image(nsImage: image)
//                }
//            }
//            if let error = camera.error {
//                Text(error.localizedDescription)
//            }


//        .onAppear {
//            camera.start()
//        }
//        .onDisappear {
//            camera.stop()
//        }
