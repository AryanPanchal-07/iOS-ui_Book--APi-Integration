//
//  BookList.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//

import SwiftUI

struct BookListView: View {
    @ObservedObject var viewModel: BookListViewModel

    var body: some View {
        List(viewModel.books) { book in
            VStack(alignment: .leading) {
                Text(book.booksName)
                    .font(.headline)
                Text("Author: \(book.author)")
                    .font(.subheadline)
                Text("Rating: \(book.rating)")
                    .font(.subheadline)
            }
        }
        .onAppear {
            viewModel.fetchBooks()
        }
        .navigationBarTitle("Book List")
        .navigationBarItems(trailing: NavigationLink(destination: AddEditBookView(viewModel: AddEditBookViewModel())) {
            Text("Add Book")
        })
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(viewModel: BookListViewModel())
    }
}
