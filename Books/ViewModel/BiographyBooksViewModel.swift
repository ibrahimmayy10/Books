//
//  BiographyBooksViewModel.swift
//  Books
//
//  Created by İbrahim Ay on 27.08.2023.
//

import Foundation

class BiographyBooksViewModel {
    var books = [BookItem]()
    
    func fetchBiography (completion: @escaping () -> Void ) {
        Webservices.shared.fetchBiography { [weak self] fetchedBookItems in
            if let fetchedBookItems = fetchedBookItems {
                self?.books = fetchedBookItems
            }
            completion()
        }
    }
}
