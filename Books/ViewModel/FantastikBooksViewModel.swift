//
//  ClassicalBooksViewModel.swift
//  Books
//
//  Created by İbrahim Ay on 27.08.2023.
//

import Foundation

class FantasticBooksViewModel {
    var books = [BookItem]()
    
    func fetchFantastic (completion: @escaping () -> Void ) {
        Webservices.shared.fetchFantastic { [weak self] fetchedBookItems in
            if let fetchedBookItems = fetchedBookItems {
                self?.books = fetchedBookItems
            }
            completion()
        }
    }
}
