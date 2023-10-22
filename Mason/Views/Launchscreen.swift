//
//  Launchscreen.swift
//  Mason
//
//  Created by Alexius Academia on 10/21/23.
//

import SwiftUI

struct Launchscreen: View {
    var body: some View {
        VStack {
            Image(.bee)
                .resizable()
                .scaledToFit()
            
            Text("Mason ToDo")
                .fontWeight(.black)
                .font(.largeTitle)
            
            Text("Version 1.0.2")
            Text("Copyright 2023. MIT")
        }
        
    }
}
