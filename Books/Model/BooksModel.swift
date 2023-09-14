//
//  BooksModel.swift
//  Books
//
//  Created by İbrahim Ay on 5.08.2023.
//

import Foundation

struct BookVolume: Codable {
    let kind: String
    let totalItems: Int
    let items: [BookItem]
}

struct BookItem: Codable {
    let kind: String
    let id: String
    let etag: String
    let selfLink: String?
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let printType: String
    let maturityRating: String
    let allowAnonLogging: Bool
    let contentVersion: String
    let description: String?
    let imageLinks: ImageLinks
    let language: String
    let publisher: String?
    let previewLink: String?
    let publishedDate: String?
    let infoLink: String?
    let canonicalVolumeLink: String?
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

