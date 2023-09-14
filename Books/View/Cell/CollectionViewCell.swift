//
//  CollectionViewCell.swift
//  Books
//
//  Created by İbrahim Ay on 27.08.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionViewImageView: UIImageView!
    
    override func prepareForReuse() {
        collectionViewImageView.image = nil
    }
}
