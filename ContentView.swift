//
//  ContentView.swift
//  Question Of The Day
//
//  Created by Subham Pathak on 12/18/23.
//

import SwiftUI

struct ContentView: View {
    var userName: String

    var body: some View {
        VStack {
            Text("Welcome, \(userName)!")
                .font(.title)
                .padding()
        }
    }
}
