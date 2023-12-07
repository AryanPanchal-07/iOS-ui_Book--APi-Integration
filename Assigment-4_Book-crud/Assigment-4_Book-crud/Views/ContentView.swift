//
//  ContentView.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var registrationViewModel = RegistrationViewModel()
    var body: some View {
        
                   NavigationView {
                       RegistrationView(viewModel: registrationViewModel)
                           .navigationTitle("Registration") // Optional: set the navigation title
                   }
                   .environmentObject(AuthService()) // Assuming AuthService is needed globally
               }
           
    }
#Preview {
    ContentView()
}
