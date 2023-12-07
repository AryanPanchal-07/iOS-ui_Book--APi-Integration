//
//  AuthService.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//

import Foundation

class AuthService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var authError: String?

    private var apiService: ApiService
    private var tokenManager: TokenManager

    init(apiService: ApiService = ApiService.shared, tokenManager: TokenManager = TokenManager.shared) {
        self.apiService = apiService
        self.tokenManager = tokenManager
        checkAuthentication()
    }

    func register(username: String, password: String) {
        apiService.register(username: username, password: password) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                    self.authError = nil
                } else {
                    self.authError = errorMessage
                }
            }
        }
    }

    func login(username: String, password: String) {
        apiService.login(username: username, password: password) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                    self.authError = nil
                } else {
                    self.authError = errorMessage
                }
            }
        }
    }

    func logout() {
        tokenManager.clearToken()
        isAuthenticated = false
    }

    private func checkAuthentication() {
        if let _ = tokenManager.getToken() {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
}

