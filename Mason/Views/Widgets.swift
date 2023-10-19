//
//  Widgets.swift
//  Mason
//
//  Created by Alexius Academia on 10/19/23.
//

import SwiftUI

struct TopBarTitleWidget: View {
    var body: some View {
        HStack {
            Image(.bee)
                .resizable()
                .scaledToFit()
            Text("Mason")
                .font(.title)
                .bold()
        }
    }
}
