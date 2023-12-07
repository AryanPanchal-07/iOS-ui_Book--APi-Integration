//
//  AddEditBookViewModel.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//

import Foundation

class AddEditBookViewModel: ObservableObject {
    @Published var book: Book
    @Published var isEditing: Bool
    @Published var errorMessage: String?

    private var apiService: ApiService

        init(book: Book? = nil, isEditing: Bool = false, apiService: ApiService = ApiService.shared) {
            if let book = book {
                self.book = book
            } else {
                self.book = Book(id: nil, bookID: 0, booksName: "", isbn: "", author: "", rating: 0.0, genre: "")
            }
            self.isEditing = isEditing
            self.apiService = apiService
        }

    func saveBook() {
        if isEditing {
            updateBook()
        } else {
            addBook()
        }
    }

    func deleteBook() {
        guard let bookID = book.id else {
            self.errorMessage = "Book ID is missing"
            return
        }

        apiService.deleteBook(bookID: String(bookID)) { success, error in
            DispatchQueue.main.async {
                if success {
                    // Book deleted successfully
                    self.errorMessage = nil
                } else {
                    // Handle error
                    self.errorMessage = error ?? "Failed to delete book"
                }
            }
        }
    }


    private func addBook() {
        apiService.addBook(book: book) { success, error in
            DispatchQueue.main.async {
                if success {
                    // Book added successfully
                    self.errorMessage = nil
                } else {
                    // Handle error
                    self.errorMessage = error ?? "Failed to add book"
                }
            }
        }
    }

    private func updateBook() {
        guard let bookID = book.id else {
            self.errorMessage = "Book ID is missing"
            return
        }

        apiService.updateBook(book: book) { success, error in
            DispatchQueue.main.async {
                if success {
                    // Book updated successfully
                    self.errorMessage = nil
                } else {
                    // Handle error
                    self.errorMessage = error ?? "Failed to update book"
                }
            }
        }
    }
}
