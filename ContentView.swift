import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    let label: String
    let searchKeyword: String
}

let tabs = [
    TabItem(label: "BTS", searchKeyword: "BTS"),
    TabItem(label: "BLACKPINK", searchKeyword: "BLACKPINK"),
    TabItem(label: "NewJeans", searchKeyword: "NewJeans"),
    TabItem(label: "LE SSERAFIM", searchKeyword: "LE SSERAFIM"),
    TabItem(label: "aespa", searchKeyword: "aespa"),
    TabItem(label: "IVE", searchKeyword: "IVE"),
    TabItem(label: "Twice", searchKeyword: "Twice"),
    TabItem(label: "ITZY", searchKeyword: "ITZY")
]

func tabColor(for label: String) -> Color {
    switch label {
    case "BTS": return Color(red: 1.00, green: 0.29, blue: 0.29) // #FF4B4B
    case "BLACKPINK": return Color(red: 1.00, green: 0.58, blue: 0.00) // #FF9500
    case "NewJeans": return Color(red: 0.21, green: 0.78, blue: 0.35) // #34C759
    case "LE SSERAFIM": return Color(red: 1.00, green: 0.84, blue: 0.04) // #FFD60A
    case "aespa": return Color(red: 0.20, green: 0.68, blue: 0.90) // #32ADE6
    case "IVE": return Color(red: 0.69, green: 0.32, blue: 0.87) // #AF52DE
    case "Twice": return Color(red: 1.00, green: 0.39, blue: 0.51) // #FF6482
    case "ITZY": return Color(red: 1.00, green: 0.62, blue: 0.04) // #FF9F0A
    default: return .gray
    }
}

struct ContentView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var searchText = ""
    @State private var isHeaderVisible = true
    @State private var lastScrollPosition: CGFloat = 0
    @State private var selectedTabIndex = 0

    private let headerHeight: CGFloat = 50

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // ヘッダー
                if isHeaderVisible {
                    VStack(spacing: 8) {
                        HStack {
                            Button(action: {
                                viewModel.fetchNews(reset: true)
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                            }
                            SearchBar(text: $searchText)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .frame(height: headerHeight)
                }

                // タブメニュー
                TabBarView(
                    selectedTab: $viewModel.selectedArtist,
                    onTabChanged: {
                        viewModel.fetchNews(reset: true)
                    }
                )

                // ニュースリスト
                TabView(selection: $viewModel.selectedArtist) {
                    ForEach(tabs, id: \.searchKeyword) { tab in
                        NewsListView(
                            newsItems: viewModel.newsItems.filter { $0.artist == tab.searchKeyword },
                            isLoadingMore: viewModel.isLoadingMore,
                            loadMoreContent: { viewModel.loadMoreNews() },
                            onScroll: { offset in
                                withAnimation {
                                    if offset <= 0 {
                                        isHeaderVisible = true
                                    } else if offset > 50 {
                                        isHeaderVisible = false
                                    }
                                }
                            }
                        )
                        .tag(tab.searchKeyword)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .padding(.bottom, 0) //  TabView の下の余白を削除
                .onChange(of: viewModel.selectedArtist) { newTab in
                    viewModel.fetchNews(reset: true)
                    selectedTabIndex = tabs.firstIndex(where: { $0.searchKeyword == newTab }) ?? 0
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchNews(reset: true)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("ニュースを検索", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
