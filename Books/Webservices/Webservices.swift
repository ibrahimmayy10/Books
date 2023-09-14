//
//  Webservices.swift
//  Books
//
//  Created by İbrahim Ay on 26.08.2023.
//

import Foundation

enum BookError: Error {
    case serverError
    case parsingError
}

class Webservices {
    static let shared = Webservices()
    
    func fetchPopular (completion: @escaping ([BookItem]?) -> Void ) {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=popular&printType=books&key=AIzaSyCehkLSItOQw7uxms4ejTk3JE9BSe0fVYs") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BookVolume.self, from: data)
                let popularItems = response.items
                completion(popularItems)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchDedective (completion: @escaping ([BookItem]?) -> Void ) {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=software&printType=books&key=AIzaSyCehkLSItOQw7uxms4ejTk3JE9BSe0fVYs") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BookVolume.self, from: data)
                let dedectiveItems = response.items
                completion(dedectiveItems)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchScienceFiction (completion: @escaping ([BookItem]?) -> Void ) {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=sciencefiction&printType=books&key=AIzaSyCehkLSItOQw7uxms4ejTk3JE9BSe0fVYs") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BookVolume.self, from: data)
                let scienceItems = response.items
                completion(scienceItems)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchFantastic (completion: @escaping ([BookItem]?) -> Void ) {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=fantastic&printType=books&key=AIzaSyCehkLSItOQw7uxms4ejTk3JE9BSe0fVYs") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BookVolume.self, from: data)
                let fantasticItems = response.items
                completion(fantasticItems)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchBiography (completion: @escaping ([BookItem]?) -> Void ) {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=biography&printType=books&key=AIzaSyCehkLSItOQw7uxms4ejTk3JE9BSe0fVYs") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BookVolume.self, from: data)
                let biographyItems = response.items
                completion(biographyItems)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func searchBook(url: URL, completion: @escaping (Result<[BookItem]?, BookError>) -> Void ) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.serverError))
            } else if let data = data {
                let searchBook = try? JSONDecoder().decode(BookVolume.self, from: data)
                let searchItem = searchBook?.items
                completion(.success(searchItem))
            }
        }.resume()
    }
}
