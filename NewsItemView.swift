import SwiftUI

struct NewsItemView: View {
    let item: NewsItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // 画像部分
            AsyncImage(url: URL(string: item.urlToImage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 120, height: 120)
            .clipped()
            
            // テキスト部分
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .regular))
                    .lineLimit(3)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(item.source)
                        .font(.system(size: 12))
                    Text("・")
                    Text(timeAgoString(from: item.publishedAt))
                        .font(.system(size: 12))
                }
                .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
            
            Spacer()
        }
        .padding(8)
        .background(Color.white)
    }
    
    private func timeAgoString(from date: Date) -> String {
        let now = Date()
        let diffInHours = Int(now.timeIntervalSince(date) / 3600)
        
        if diffInHours < 24 {
            return "\(diffInHours)時間前"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter.string(from: date)
        }
    }
}

