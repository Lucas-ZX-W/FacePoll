//
//  FloatingBar.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI
import Combine

struct CurrentEmotionView: View {
    let session: String
    private let id = UUID()
    @ObservedObject var camera = CameraInput()

    var mainView: some View {
        VStack {
            Spacer()
            HStack {
                Text("Your current emotion:")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                Text(camera.emotion.description)
                    .font(.system(size: 60))
                    .onAppear {
                        startReporting()
                    }
                    .onDisappear {
                        stopReporting()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .emotionalWindowOpen)) { _ in
                        startReporting()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .emotionalWindowClose)) { _ in
                        stopReporting()
                    }
                // if let image = camera.image {
                //     Image(nsImage: image)
                // }
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

    @State var tokens: [AnyCancellable] = []
    func startReporting() {
        guard tokens.isEmpty else { return }
        camera.start()
        tokens.append(camera.$emotion.collect(10).sink { (output) in
            Dictionary(grouping: output) { $0 }
                .mapValues { $0.count }
                .max { $0.value < $1.value }
                .map {
                    database.child(session).child(id.uuidString)
                        .setValue($0.key.rawValue)
                    History.shared.record($0.key)
                }
        })
    }

    func stopReporting() {
        camera.stop()
        tokens.forEach { $0.cancel() }
        tokens.removeAll()
        database.child(session).child(id.uuidString).removeValue()
    }
}

struct FloatingBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrentEmotionView(session: "test")
            CurrentEmotionView(session: "test")
        }
    }
}
