//
//  SearchVC.swift
//  Books
//
//  Created by İbrahim Ay on 28.08.2023.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var searchBook = String()
    
    var bookItem = [BookItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func goToHomePageButton(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(identifier: "toViewController") as! ViewController
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    
    @IBAction func goToFavoriteButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchBook = searchTextField.text!
        
        let url = "https://www.googleapis.com/books/v1/volumes?q=\(searchBook)&printType=books&key=AIzaSyCehkLSItOQw7uxms4ejTk3JE9BSe0fVYs"
        guard let url = URL(string: url) else { return }
        Webservices().searchBook(url: url) { result in
            switch result {
            case .success(let books):
                if let books = books {
                    self.bookItem = books
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        let book = bookItem[indexPath.row]
        cell.searchTitleLabel.text = book.volumeInfo.title
        cell.searchDateLabel.text = book.volumeInfo.publishedDate
        if var imageUrlComponents = URLComponents(string: book.volumeInfo.imageLinks.thumbnail!) {
            imageUrlComponents.scheme = "https"
            if let secureImageUrl = imageUrlComponents.url {
                if let data = try? Data(contentsOf: secureImageUrl) {
                    let image = UIImage(data: data)
                    cell.searchImageView.image = image
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(identifier: "toDetailsVC") as! DetailsVC
        detailsVC.volumeInfo = bookItem[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
