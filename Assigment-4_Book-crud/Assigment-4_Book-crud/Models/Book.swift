//
//  Book.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//

import Foundation

struct Book: Identifiable, Decodable, Encodable {
    var id: String?
      var bookID: Int
      var booksName: String
      var isbn: String
      var author: String
      var rating: Double
      var genre: String
}

