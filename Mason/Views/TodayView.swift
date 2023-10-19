//
//  TodayView.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI

struct TodayView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.3).ignoresSafeArea()
                
                List {
                    
                }.scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem {
                    TopBarTitleWidget()
                }
            }
            .navigationTitle("Today")
        }
    }
}
