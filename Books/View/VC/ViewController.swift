//
//  ViewController.swift
//  Books
//
//  Created by İbrahim Ay on 5.08.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var popularViewModel = PopularBooksViewModel()
    var dedectiveViewModel = DedectiveBooksViewModel()
    var biographyViewModel = BiographyBooksViewModel()
    var scienceViewModel = ScienceBooksViewModel()
    var fantasticViewModel = FantasticBooksViewModel()
    
    var type = [HeaderTypes(sectionType: "Popular"), HeaderTypes(sectionType: "Software"), HeaderTypes(sectionType: "Science Fiction"), HeaderTypes(sectionType: "Fantastic"), HeaderTypes(sectionType: "Biography")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getData()

    }
    
    
    @IBAction func goToSearchButton(_ sender: Any) {
        let searchVC = storyboard?.instantiateViewController(identifier: "toSearchVC") as! SearchVC
        navigationController?.pushViewController(searchVC, animated: false)
    }
    
    @IBAction func goToFavoriteButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    func getData () {
        popularViewModel.fetchPopular {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        dedectiveViewModel.fetchDedective {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        scienceViewModel.fetchScience {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        fantasticViewModel.fetchFantastic {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return type.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return type[section].sectionType
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.collectionView.tag = indexPath.section
        
        let currentViewModel = type[indexPath.section].sectionType
        
        if currentViewModel == "Popular" {
            cell.configurePopular(with: popularViewModel)
        } else if currentViewModel == "Software" {
            cell.configureDedective(with: dedectiveViewModel)
        } else if currentViewModel == "Science Fiction" {
            cell.configureScience(with: scienceViewModel)
        } else if currentViewModel == "Fantastic" {
            cell.configureClassical(with: fantasticViewModel)
        } else if currentViewModel == "Biography" {
            cell.configureBiography(with: biographyViewModel)
        }
        
        cell.didSelectItem = { [weak self] selectedBook in
            if let detailsVC = self?.storyboard?.instantiateViewController(identifier: "toDetailsVC") as? DetailsVC {
                detailsVC.volumeInfo = selectedBook
                self?.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
