//
//  ApiService.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//

import Foundation

class ApiService {
    static let shared = ApiService()
    
    private let baseURL = "https://localhost:3000"
    
    func register(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let registerURL = URL(string: "\(baseURL)/register")!
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(false, "Failed to serialize JSON")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                // Registration successful
                // You can handle the token received in the response if needed
                completion(true, nil)
            } else {
                // Registration failed
                let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                completion(false, errorMessage?.message ?? "Registration failed")
            }
        }.resume()
    }
    
    func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let loginURL = URL(string: "\(baseURL)/login")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(false, "Failed to serialize JSON")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                    // Handle the token, you may want to store it securely
                    TokenManager.shared.saveToken(tokenResponse.token)
                    completion(true, nil)
                } catch {
                    completion(false, "Failed to decode token data")
                }
            } else {
                // Login failed
                let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                completion(false, errorMessage?.message ?? "Login failed")
            }
        }.resume()
    }
    
    func getBooks(completion: @escaping ([Book]?, String?) -> Void) {
            let booksURL = URL(string: "\(baseURL)/book")!
            
            URLSession.shared.dataTask(with: booksURL) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil, error?.localizedDescription)
                    return
                }
                
                do {
                    let books = try JSONDecoder().decode([Book].self, from: data)
                    completion(books, nil)
                } catch {
                    completion(nil, "Failed to decode books data")
                }
            }.resume()
        }
    
    func fetchBooks(completion: @escaping ([Book]?, String?) -> Void) {
        let booksURL = URL(string: "\(baseURL)/book")!

        URLSession.shared.dataTask(with: booksURL) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // Use snake_case for decoding

                let books = try decoder.decode([Book].self, from: data)
                completion(books, nil)
            } catch {
                completion(nil, "Failed to decode books data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func addBook(book: Book, completion: @escaping (Bool, String?) -> Void) {
        let addBookURL = URL(string: "\(baseURL)/book")!
        var request = URLRequest(url: addBookURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(book)
            request.httpBody = jsonData
        } catch {
            completion(false, "Failed to encode book data")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                completion(true, nil)
            } else {
                let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                completion(false, errorMessage?.message ?? "Failed to add book")
            }
        }.resume()
    }
    
    func updateBook(book: Book, completion: @escaping (Bool, String?) -> Void) {
        guard let bookID = book.id else {
            completion(false, "Book ID is missing")
            return
        }
        
        let updateBookURL = URL(string: "\(baseURL)/book/\(bookID)")!
        var request = URLRequest(url: updateBookURL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(book)
            request.httpBody = jsonData
        } catch {
            completion(false, "Failed to encode book data")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                completion(true, nil)
            } else {
                let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                completion(false, errorMessage?.message ?? "Failed to update book")
            }
        }.resume()
    }
    
    func deleteBook(bookID: String, completion: @escaping (Bool, String?) -> Void) {
        let deleteBookURL = URL(string: "\(baseURL)/book/\(bookID)")!
        var request = URLRequest(url: deleteBookURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                completion(true, nil)
            } else {
                let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                completion(false, errorMessage?.message ?? "Failed to delete book")
            }
        }.resume()
    }
}

struct TokenResponse: Decodable {
    let token: String
}

struct ErrorResponse: Decodable {
    let message: String
}

struct TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "authToken"
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
