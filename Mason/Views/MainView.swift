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
            ScrollView {
                VStack {
                    NavigationLink(destination: TodayView()) {
                        SummaryTile(title: "Today", subtitle: "10", bgColor: Color.orange.opacity(0.5))
                            .padding()
                    }
                    
                    NavigationLink(destination: PreviousDaysView()) {
                        SummaryTile(title: "Previous", subtitle: "14", bgColor: Color.blue.opacity(0.5))
                            .padding()
                    }
                    
                    NavigationLink(destination: WeeklyView()) {
                        SummaryTile(title: "Weekly", subtitle: "35", bgColor: Color.green.opacity(0.5))
                            .padding()
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    TopBarTitleWidget()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
