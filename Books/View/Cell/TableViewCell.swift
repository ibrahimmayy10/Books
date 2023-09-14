//
//  TableViewCell.swift
//  Books
//
//  Created by İbrahim Ay on 12.08.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var popularViewModel = PopularBooksViewModel()
    var dedectiveViewModel = DedectiveBooksViewModel()
    var biographyViewModel = BiographyBooksViewModel()
    var scienceViewModel = ScienceBooksViewModel()
    var fantasticViewModel = FantasticBooksViewModel()
    
    var type = [HeaderTypes(sectionType: "Popular"), HeaderTypes(sectionType: "Software"), HeaderTypes(sectionType: "Science Fiction"), HeaderTypes(sectionType: "Fantastic"), HeaderTypes(sectionType: "Biography")]
    
    var didSelectItem: ((BookItem) -> Void)?
        
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.dataSource = self
        collectionView.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
            self.popularViewModel.books = []
            self.dedectiveViewModel.books = []
            self.scienceViewModel.books = []
            self.fantasticViewModel.books = []
            self.biographyViewModel.books = []
            self.collectionView.reloadData()
        }
        
    func configurePopular(with popular: PopularBooksViewModel) {
        self.popularViewModel = popular
        popular.fetchPopular {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureDedective(with dedective: DedectiveBooksViewModel) {
        self.dedectiveViewModel = dedective
        dedective.fetchDedective {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureScience(with science: ScienceBooksViewModel) {
        self.scienceViewModel = science
        science.fetchScience {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureClassical(with classical: FantasticBooksViewModel) {
        self.fantasticViewModel = classical
        classical.fetchFantastic {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureBiography(with biography: BiographyBooksViewModel) {
        self.biographyViewModel = biography
        biography.fetchBiography {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let currentViewModel = type[collectionView.tag].sectionType
        
        if currentViewModel == "Popular" {
            return popularViewModel.books.count
        } else if currentViewModel == "Software" {
            return dedectiveViewModel.books.count
        } else if currentViewModel == "Science Fiction" {
            return scienceViewModel.books.count
        } else if currentViewModel == "Fantastic" {
            return fantasticViewModel.books.count
        } else if currentViewModel == "Biography" {
            return biographyViewModel.books.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if collectionView.tag == 0, !popularViewModel.books.isEmpty {
            let popular = popularViewModel.books[indexPath.item]
            if var imageURLComponents = URLComponents(string: (popular.volumeInfo.imageLinks.thumbnail)!) {
                imageURLComponents.scheme = "https"
                if let secureImageURL = imageURLComponents.url {
                    cell.collectionViewImageView.load(url: secureImageURL)
                }
            }
        } else if collectionView.tag == 1, !dedectiveViewModel.books.isEmpty {
            let dedective = dedectiveViewModel.books[indexPath.item]
            if var imageURLComponents = URLComponents(string: (dedective.volumeInfo.imageLinks.thumbnail)!) {
                imageURLComponents.scheme = "https"
                if let secureImageUrl = imageURLComponents.url {
                    cell.collectionViewImageView.load(url: secureImageUrl)
                }
            }
        } else if collectionView.tag == 2, !scienceViewModel.books.isEmpty {
            let science = scienceViewModel.books[indexPath.item]
            if var imageURLComponents = URLComponents(string: (science.volumeInfo.imageLinks.thumbnail)!) {
                imageURLComponents.scheme = "https"
                if let secureImageUrl = imageURLComponents.url {
                    cell.collectionViewImageView.load(url: secureImageUrl)
                }
            }
        } else if collectionView.tag == 3, !fantasticViewModel.books.isEmpty {
            let classical = fantasticViewModel.books[indexPath.item]
            if var imageURLComponents = URLComponents(string: (classical.volumeInfo.imageLinks.thumbnail)!) {
                imageURLComponents.scheme = "https"
                if let secureImageUrl = imageURLComponents.url {
                    cell.collectionViewImageView.load(url: secureImageUrl)
                }
            }
        } else if collectionView.tag == 4, !biographyViewModel.books.isEmpty {
            let biography = biographyViewModel.books[indexPath.item]
            if var imageURLComponents = URLComponents(string: (biography.volumeInfo.imageLinks.thumbnail)!) {
                imageURLComponents.scheme = "https"
                if let secureImageUrl = imageURLComponents.url {
                    cell.collectionViewImageView.load(url: secureImageUrl)
                }
            }
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook: BookItem
        
        let currentViewModel = type[collectionView.tag].sectionType
        switch currentViewModel {
        case "Popular":
            selectedBook = popularViewModel.books[indexPath.item]
        case "Software":
            selectedBook = dedectiveViewModel.books[indexPath.item]
        case "Science Fiction":
            selectedBook = scienceViewModel.books[indexPath.item]
        case "Fantastic":
            selectedBook = fantasticViewModel.books[indexPath.item]
        case "Biography":
            selectedBook = biographyViewModel.books[indexPath.item]
        default:
            return
        }
        
        didSelectItem?(selectedBook)
    }
    
}
