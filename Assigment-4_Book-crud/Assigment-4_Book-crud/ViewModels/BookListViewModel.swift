//
//  BookListViewModel.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//
// Inside BookListViewModel.swift

import Foundation

class BookListViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var bookListError: String?
    
    private var apiService: ApiService
    
    init(apiService: ApiService = ApiService.shared) {
        self.apiService = apiService
        fetchBooks()
    }
    
    func fetchBooks() {
        apiService.fetchBooks { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.books = []
                    self.bookListError = error
                }
            } else if let books = result {
                DispatchQueue.main.async {
                    self.books = books
                    self.bookListError = nil
                }
            }
        }
    }
}



