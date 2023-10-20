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
    @Binding var subtitle: String
    @State var bgColor: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Text(subtitle)
                .font(.largeTitle)
                .fontWeight(.black)
                .bold()
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(bgColor)
            
        )
    }
}

struct TaskRow: View {
    @Bindable var task: Task
    @State var showDate = false
    @State var date = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    task.completed = !task.completed
                }label: {
                    Image(systemName: task.completed ? "checkmark.square" : "square")
                }
                
                Text(task.taskName)
                    .bold()
                    .foregroundStyle(task.completed ? .green.opacity(0.8) : .black)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            if showDate {
                Text(date)
                    .font(.subheadline)
                    .foregroundStyle(.gray.opacity(0.75))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear() {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            date = dateFormatter.string(from: task.timestamp)
        }
    }
}
