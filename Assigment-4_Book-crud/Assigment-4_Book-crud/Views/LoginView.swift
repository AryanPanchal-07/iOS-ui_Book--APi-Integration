//
//  LoginView.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var isRegistrationPresented = false
    @EnvironmentObject var authService: AuthService

    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $viewModel.password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = viewModel.loginError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Login") {
                viewModel.login()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)

            // Link to RegistrationView
            NavigationLink(destination: RegistrationView(viewModel: RegistrationViewModel()), isActive: $viewModel.loginSuccess) {
                EmptyView()
            }
            .hidden()

            Button("Don't have an account? Register here.") {
                isRegistrationPresented = true
            }
            .foregroundColor(.blue)
            .sheet(isPresented: $isRegistrationPresented) {
                RegistrationView(viewModel: RegistrationViewModel())
            }
        }
        .padding()
        .navigationBarTitle("Login")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}

