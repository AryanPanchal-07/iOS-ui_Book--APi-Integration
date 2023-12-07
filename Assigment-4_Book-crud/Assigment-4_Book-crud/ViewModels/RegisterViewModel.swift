//
//  RegisterViewModel.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var registrationError: String?
    @Published var registrationSuccess = false

    private var apiService: ApiService

    init(apiService: ApiService = ApiService.shared) {
        self.apiService = apiService
    }

    func register() {
        guard !username.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            registrationError = "All fields are required."
            return
        }

        guard password == confirmPassword else {
            registrationError = "Passwords do not match."
            return
        }

        apiService.register(username: username, password: password) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self.registrationSuccess = true
                    self.registrationError = nil
                } else {
                    self.registrationError = errorMessage
                }
            }
        }
    }
}
