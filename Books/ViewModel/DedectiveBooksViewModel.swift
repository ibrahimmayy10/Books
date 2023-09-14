//
//  DedectiveBooksViewModel.swift
//  Books
//
//  Created by İbrahim Ay on 27.08.2023.
//

import Foundation

class DedectiveBooksViewModel {
    var books = [BookItem]()
    
    func fetchDedective (completion: @escaping () -> Void ) {
        Webservices.shared.fetchDedective { [weak self] fetchedBookItems in
            if let fetchedBookItems = fetchedBookItems {
                self?.books = fetchedBookItems
            }
            completion()
        }
    }
}
