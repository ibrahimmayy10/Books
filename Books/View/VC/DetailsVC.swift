//
//  DetailsVC.swift
//  Books
//
//  Created by İbrahim Ay on 27.08.2023.
//

import UIKit
import CoreData
import SafariServices

class DetailsVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!

    @IBOutlet weak var likeBtn: UIButton!
    
    var volumeInfo: BookItem?
    
    var chosenTitle = ""
    var chosenTitleID: UUID?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationController?.navigationBar.isHidden = false
        
        write()
        getCoreData()
        
    }
    
    func getCoreData () {
        if !chosenTitle.isEmpty {
            likeBtn.setImage(UIImage(named: "favoridolu"), for: .normal)
            likeBtn.tag = 1
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favori")
            let idString = chosenTitleID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let title = result.value(forKey: "title") as? String {
                            titleLabel.text = title
                        }
                        if let date = result.value(forKey: "date") as? String {
                            dateLabel.text = date
                        }
                        if let publisher = result.value(forKey: "publisher") as? String {
                            publisherLabel.text = publisher
                        }
                        if let description = result.value(forKey: "overview") as? String {
                            descriptionLabel.text = description
                        }
                        if let imageUrlString = result.value(forKey: "image") as? String {
                            if var imageUrlComponents = URLComponents(string: imageUrlString) {
                                imageUrlComponents.scheme = "https"
                                if let secureImageUrl = imageUrlComponents.url {
                                    if let imageData = try? Data(contentsOf: secureImageUrl) {
                                        let image = UIImage(data: imageData)
                                        imageView.image = image
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                printContent(error.localizedDescription)
            }
        }
    }
    
    func write() {
        titleLabel.text = volumeInfo?.volumeInfo.title
        dateLabel.text = volumeInfo?.volumeInfo.publishedDate
        publisherLabel.text = volumeInfo?.volumeInfo.publisher
        descriptionLabel.text = volumeInfo?.volumeInfo.description
        
        if var imageURLComponents = URLComponents(string: (volumeInfo?.volumeInfo.imageLinks.thumbnail ?? "")) {
            imageURLComponents.scheme = "https"
            if let secureImageURL = imageURLComponents.url {
                if let imageData = try? Data(contentsOf: secureImageURL) {
                    let image = UIImage(data: imageData)
                    imageView.image = image
                }
            }
        }
    }
    
    @IBAction func goToHomePageButton(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(identifier: "toViewController") as! ViewController
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func goToSearchButton(_ sender: Any) {
        let searchVC = storyboard?.instantiateViewController(identifier: "toSearchVC") as! SearchVC
        navigationController?.pushViewController(searchVC, animated: false)
    }
    
    @IBAction func goToFavoriteButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }

    @IBAction func likeButton(_ sender: Any) {
        if likeBtn.tag == 0 {
            likeBtn.setImage(UIImage(named: "favoridolu"), for: .normal)
            likeBtn.tag = 1
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newFavoriBooks = NSEntityDescription.insertNewObject(forEntityName: "Favori", into: context)
            
            newFavoriBooks.setValue(volumeInfo?.volumeInfo.title, forKey: "title")
            newFavoriBooks.setValue(volumeInfo?.volumeInfo.publishedDate, forKey: "date")
            newFavoriBooks.setValue(volumeInfo?.volumeInfo.description, forKey: "overview")
            newFavoriBooks.setValue(volumeInfo?.volumeInfo.imageLinks.thumbnail, forKey: "image")
            newFavoriBooks.setValue(volumeInfo?.volumeInfo.publisher, forKey: "publisher")
            newFavoriBooks.setValue(UUID(), forKey: "id")
            
            do {
                try context.save()
                print("veritabanına başarıyla kaydedildi")
            } catch {
                print(error.localizedDescription)
            }
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        } else {
            likeBtn.setImage(UIImage(named: "favoribos"), for: .normal)
            likeBtn.tag = 0

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favori")
            if let selectedID = chosenTitleID {
                fetchRequest.predicate = NSPredicate(format: "id = %@", selectedID as CVarArg)
            }
            do {
                let results = try context.fetch(fetchRequest)
                if let objectToDelete = results.first {
                    context.delete(objectToDelete as! NSManagedObject)
                    try context.save()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func buyBookButton(_ sender: Any) {
        guard let url = URL(string: volumeInfo?.volumeInfo.previewLink ?? "") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }    
    
    @IBAction func sameTypeBooksButton(_ sender: Any) {
        guard let url = URL(string: volumeInfo?.volumeInfo.infoLink ?? "") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}
