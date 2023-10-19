//
//  MainView.swift
//  Mason
//
//  Created by Alexius Academia on 10/18/23.
//

import SwiftUI

struct MainView: View {
    @Binding var selectedTab: Tag
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Button {
                        selectedTab = Tag.today
                    }label: {
                        SummaryTile(title: "Today", subtitle: "10", bgColor: Color.orange.opacity(0.5))
                            .padding()
                    }
                    
                    Button {
                        selectedTab = Tag.previous
                    }label: {
                        SummaryTile(title: "Previous", subtitle: "14", bgColor: Color.blue.opacity(0.5))
                            .padding()
                    }
                    
                    Button {
                        selectedTab = Tag.weekly
                    }label: {
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
