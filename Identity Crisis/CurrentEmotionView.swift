//
//  FloatingBar.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI
import Combine

extension CurrentEmotionView {
    init(isHost: Bool, session: String) {
        self.init(isHost: isHost, session: session, aggregate: Aggregated(session: session))
    }
}

struct CurrentEmotionView: View {
    let isHost: Bool
    let session: String
    private let id = UUID()
    @ObservedObject var aggregate: Aggregated
    @ObservedObject var camera = CameraInput()

    var mainView: some View {
        VStack {
            Spacer()
            HStack {
                if isHost {
                    if let key = aggregate.reactions.max(by: { $0.value < $1.value })?.key {
                        HStack {
                            Text("Your participants' emotion:")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                            Text(key.description)
                                .font(.system(size: 60))
                        }
                    } else {
                        Text("Ready for today?")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                } else {
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

    @State var token: AnyCancellable? = nil
    func startReporting() {
        guard token == nil else { return }
        camera.start()
        token = camera.$emotion.collect(10).sink { (output) in
            Dictionary(grouping: output) { $0 }
                .mapValues { $0.count }
                .max { $0.value < $1.value }
                .map {
                    database.child(session).child(id.uuidString)
                        .setValue($0.key.rawValue)
                }
        }
    }

    func stopReporting() {
        camera.stop()
        token?.cancel()
        token = nil
        database.child(session).child(id.uuidString).removeValue()
    }
}

struct FloatingBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrentEmotionView(isHost: true, session: "test")
            CurrentEmotionView(isHost: false, session: "test")
        }
    }
}
