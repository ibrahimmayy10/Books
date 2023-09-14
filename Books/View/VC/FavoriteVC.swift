//
//  FavoriteVC.swift
//  Books
//
//  Created by İbrahim Ay on 28.08.2023.
//

import UIKit
import CoreData

class FavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var titleArray = [String]()
    var dateArray = [String]()
    var imageArray = [String]()
    var idArray = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        
        getData()
        
    }
    
    func didDeleteFavorite(withId id: UUID) {
        if let index = idArray.firstIndex(of: id) {
            titleArray.remove(at: index)
            idArray.remove(at: index)
            dateArray.remove(at: index)
            imageArray.remove(at: index)
        }
    }
    
    @objc func getData () {
        titleArray.removeAll(keepingCapacity: false)
        dateArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favori")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                    }
                    if let date = result.value(forKey: "date") as? String {
                        self.dateArray.append(date)
                    }
                    if let image = result.value(forKey: "image") as? String {
                        self.imageArray.append(image)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    tableView.reloadData()
                }
            }
        } catch {
            print(error.localizedDescription)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        
        let title = titleArray[indexPath.row]
        let date = dateArray[indexPath.row]
        let image = imageArray[indexPath.row]
        
        cell.favoriteTitleLabel.text = title
        cell.favoriteDateLabel.text = date
        
        if var imageUrlComponents = URLComponents(string: image) {
            imageUrlComponents.scheme = "https"
            if let secureImageUrl = imageUrlComponents.url {
                if let imageData = try? Data(contentsOf: secureImageUrl) {
                    let image = UIImage(data: imageData)
                    cell.favoriteImageView.image = image
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(identifier: "toDetailsVC") as! DetailsVC
        detailsVC.chosenTitle = titleArray[indexPath.row]
        detailsVC.chosenTitleID = idArray[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favori")
            fetchRequest.returnsObjectsAsFaults = false
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                titleArray.remove(at: indexPath.row)
                                dateArray.remove(at: indexPath.row)
                                imageArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
