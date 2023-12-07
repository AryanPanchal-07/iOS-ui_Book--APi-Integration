//
//  LoginViewModel.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var loginError: String?
    @Published var loginSuccess = false

    private var apiService: ApiService

    init(apiService: ApiService = ApiService.shared) {
        self.apiService = apiService
    }

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            loginError = "Username and password are required."
            return
        }

        apiService.login(username: username, password: password) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self.loginSuccess = true
                    self.loginError = nil
                } else {
                    self.loginError = errorMessage
                }
            }
        }
    }
}
