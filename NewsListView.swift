import SwiftUI

struct NewsListView: View {
    let newsItems: [NewsItem]
    var isLoadingMore: Bool
    var loadMoreContent: () -> Void
    let onScroll: (CGFloat) -> Void

    @State private var refreshing = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: -geometry.frame(in: .named("scroll")).origin.y
                )
            }
            .frame(height: 0)

            RefreshControl(refreshing: refreshing) {
                Task { await refresh() }
            }

            LazyVStack(spacing: 0) {
                ForEach(newsItems, id: \.id) { item in
                    NavigationLink(destination: NewsDetailView(url: item.url)) {
                        NewsItemView(item: item)
                            .onAppear {
                                if newsItems.last?.id == item.id {
                                    loadMoreContent()
                                }
                            }
                    }
                    if newsItems.last?.id != item.id {
                        Divider()
                    }
                }
                if isLoadingMore {
                    ProgressView()
                }
            }
            .padding(.top, 0) // LazyVStack の上側の余白を削除
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
            onScroll(offset)
        }
    }

    private func refresh() async {
        refreshing = true
        loadMoreContent()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        refreshing = false
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct RefreshControl: View {
    var refreshing: Bool
    var onRefresh: () async -> Void

    var body: some View {
        ZStack(alignment: .center) {
            if refreshing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(height: 50)
            }
        }
        .frame(height: refreshing ? 50 : 0)
    }
}
