import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: String
    let onTabChanged: () -> Void

    var body: some View {
        VStack(spacing: 0) { // ここに spacing: 0 を明示的に追加
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(spacing: 0) {
                        ForEach(tabs) { tab in
                            TabButton(
                                label: tab.label,
                                isSelected: selectedTab == tab.searchKeyword,
                                color: tabColor(for: tab.label),
                                action: {
                                    withAnimation {
                                        selectedTab = tab.searchKeyword
                                        onTabChanged()
                                        proxy.scrollTo(tab.searchKeyword, anchor: .center)
                                    }
                                }
                            )
                            .id(tab.searchKeyword)
                        }
                    }
                    .padding(.horizontal, 0)
                    .onAppear {
                        proxy.scrollTo(selectedTab, anchor: .center)
                    }
                    .onChange(of: selectedTab) { newTab in
                        withAnimation {
                            proxy.scrollTo(newTab, anchor: .center)
                        }
                    }
                }
            }
            .background(Color.white)
            Rectangle()
                .fill(tabColor(for: selectedTab))
                .frame(height: 4)
        }
    }
}
