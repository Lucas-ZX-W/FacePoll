//
//  EmotionalView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct StatisticsView: View {
    @ObservedObject var fakeData = Aggregated(session: "hello", debug: true)
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                Text("Emotions Distribution").font(Font.title.weight(.bold))
                Text("For the last 1 week")
                HStack(alignment: .bottom, spacing: 16) {
                    ForEach(Emotion.allCases) { emo in
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 5)
                                .fill(emo.color)
                                .frame(height: CGFloat(fakeData.fakeStats[emo]!) * geo.size.height)
                            Text(emo.description)
                                .font(.system(size: 35))
                        }
                    }
                    .animation(.easeOut)
                    .transition(.slide)
                }
                Spacer(minLength: 30)
            }
        }
        .padding()
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
