// NewsViewModel.swift

import SwiftUI
import FirebaseFirestore

class NewsViewModel: ObservableObject {
    @Published var newsItems: [NewsItem] = []
    @Published var selectedArtist: String = "BTS"
    @Published var isLoadingMore = false
    private var db = Firestore.firestore()
    private let pageSize = 30
    private var lastDocument: DocumentSnapshot? = nil

    func fetchNews(reset: Bool) {
        if reset {
            newsItems = []
            lastDocument = nil
            fetchDataFromFirestore()
        } else {
            fetchDataFromFirestore()
        }
    }

    func loadMoreNews() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        fetchDataFromFirestore()
    }

    private func fetchDataFromFirestore() {
        var query: Query = db.collection("news")
            .whereField("artist", isEqualTo: selectedArtist)
            .order(by: "publishedAt", descending: true)
            .limit(to: pageSize)

        if let lastDocument = lastDocument {
            query = query.start(afterDocument: lastDocument)
        }

        query.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            self.isLoadingMore = false
            if let error = error {
                print("Error fetching news: \(error)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }

            let newItems = documents.compactMap { document -> NewsItem? in
                var item = try? document.data(as: NewsItem.self)
                item?.id = document.documentID
                return item
            }

            if self.lastDocument == nil {
                self.newsItems = newItems
            } else {
                self.newsItems.append(contentsOf: newItems)
            }
            self.lastDocument = documents.last
        }
    }
}
