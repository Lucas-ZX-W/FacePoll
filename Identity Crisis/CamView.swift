//
//  CamView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-18.
//

import SwiftUI

struct CamView: View {
    @ObservedObject var fakeData = Aggregated(session: "hello", debug: true)

    var mainView: some View {
        GeometryReader { geo in
            if fakeData.reactions.isEmpty {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Waiting for participants...")
                            .font(.largeTitle)
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                HStack(spacing: 0) {
                    ForEach(Emotion.allCases) { key in
                        Text(key.description)
                            .font(.system(size: 30))
                            .frame(width: CGFloat(fakeData.reactions[key] ?? 0) * geo.size.width,
                                   height: geo.size.height)
                            .background(key.color)
                    }
                    .animation(.easeInOut)
                    .transition(.slide)
                }
            }
        }
        .frame(idealWidth: 600, idealHeight: 80)
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
