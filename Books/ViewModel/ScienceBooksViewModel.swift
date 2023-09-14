//
//  ScienceBooksViewModel.swift
//  Books
//
//  Created by İbrahim Ay on 27.08.2023.
//

import Foundation

class ScienceBooksViewModel {
    var books = [BookItem]()
    
    func fetchScience (completion: @escaping () -> Void ) {
        Webservices.shared.fetchScienceFiction { [weak self] fetchedBookItems in
            if let fetchedBookItems = fetchedBookItems {
                self?.books = fetchedBookItems
            }
            completion()
        }
    }
}
