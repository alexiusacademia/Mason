//
//  Launchscreen.swift
//  Mason
//
//  Created by Alexius Academia on 10/21/23.
//

import SwiftUI

struct Launchscreen: View {
    @State private var versionNumber = ""
    @State private var buildNumber = ""
    
    var body: some View {
        VStack {
            Image(.bee)
                .resizable()
                .scaledToFit()
            
            Text("Mason ToDo")
                .fontWeight(.black)
                .font(.largeTitle)
            
            Text("Version \(versionNumber) build number \(buildNumber)")
            Text("Copyright 2023. MIT")
        }.onAppear() {
            versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Cannot fetch version number."
            buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Cannot fetch build number."
            
        }
        
    }
}
