//
//  FloatingBar.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import SwiftUI

struct FloatingBar: View {
    let creatingNewSession: Bool
    
    var body: some View {
        HStack {
            if creatingNewSession {
                Text("Your participants' emotions:")
            } else {
                Text("Your current emotion")
            }
//            Text(Emotion(rawValue: ???))
        }
    }
}

//struct FloatingBar_Previews: PreviewProvider {
//    static var previews: some View {
//        FloatingBar()
//    }
//}
