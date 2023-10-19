//
//  PreviousDaysView.swift
//  Mason
//
//  Created by Alexius Academia on 10/19/23.
//

import SwiftUI

struct PreviousDaysView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.3).ignoresSafeArea()
                
                List {
                    
                }.scrollContentBackground(.hidden)
            }.toolbar {
                ToolbarItem {
                    TopBarTitleWidget()
                }
            }.navigationTitle("Previous")
        }
    }
}
