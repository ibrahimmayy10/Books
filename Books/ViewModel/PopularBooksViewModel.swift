//
//  BooksViewModel.swift
//  Books
//
//  Created by İbrahim Ay on 6.08.2023.
//

import Foundation

class PopularBooksViewModel {
    var books = [BookItem]()
    
    func fetchPopular (completion: @escaping () -> Void ) {
        Webservices.shared.fetchPopular { [weak self] fetchedBookItems in
            if let fetchedBookItems = fetchedBookItems {
                self?.books = fetchedBookItems
            }
            completion()
        }
    }
}
