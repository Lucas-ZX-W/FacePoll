//
//  EmotionalView.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct StatisticsView: View {
    let foregroundColor: Color = Color(red: 22/255, green: 67/255, blue: 86/255)
    @ObservedObject var fakeData = Aggregated(session: "hello", debug: true)
    
    var body: some View {
        VStack {
            Spacer()
            Text("Emotions Distribution").font(Font.title.weight(.bold))
            Text("For the last 1 week")
            HStack {
                ForEach(Emotion.allCases) { emo in
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(emo.color)
                            .frame(width: 100, height: CGFloat(fakeData.fakeStats[emo]! * 700))
                        Text(emo.description)
                            .font(.system(size: 35))
                    }
                }
            }
            Spacer(minLength: 30)
        }
    }
}

//struct EmotionalView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmotionalView()
//    }
//}
