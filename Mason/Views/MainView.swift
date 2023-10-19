//
//  MainView.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("Test")
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Mason")
                        .font(.title)
                        .bold()
                }
            }
        }
    }
}
