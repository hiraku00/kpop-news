import SwiftUI
import FirebaseFirestore

struct NewsItem: Identifiable, Codable {
    var id: String?
    let author: String?
    let source: String
    let title: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    let content: String?
    let artist: String
    let year: Int
    let month: Int
    let day: Int
    let time: String
}

