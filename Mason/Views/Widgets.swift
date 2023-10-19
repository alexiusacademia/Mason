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

struct SummaryTile: View {
    @State var title: String
    @State var subtitle: String
    @State var bgColor: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Text(subtitle)
                .font(.title)
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(bgColor)
            
        )
        .overlay (
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(lineWidth: 2.0)
        )
    }
}
