//
//  AddEditBookView.swift
//  Assigment-4_Book-crud
//
//  Created by Aryan Panchal on 2023-12-07.
//

import SwiftUI

struct AddEditBookView: View {
    @ObservedObject var viewModel: AddEditBookViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Book Information")) {
                    TextField("Book Name", text: $viewModel.book.booksName)
                    TextField("ISBN", text: $viewModel.book.isbn)
                    TextField("Author", text: $viewModel.book.author)
                    TextField("Rating", value: $viewModel.book.rating, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                    TextField("Genre", text: $viewModel.book.genre)
                }

                Section {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    Button("Save") {
                        viewModel.saveBook()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(viewModel.book.booksName.isEmpty || viewModel.book.isbn.isEmpty || viewModel.book.author.isEmpty || viewModel.book.genre.isEmpty)
                }
            }
            .navigationBarTitle(viewModel.isEditing ? "Edit Book" : "Add Book")
        }
        .onAppear {
            if viewModel.isEditing {
                // Additional setup for editing mode
            }
        }
    }
}

struct AddEditBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditBookView(viewModel: AddEditBookViewModel())
    }
}
