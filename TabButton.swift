import SwiftUI

struct TabButton: View {
    let label: String
    var isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                // 上部の線
                if isSelected {
                    Rectangle()
                        .fill(color)
                        .frame(height: 4)
                } else {
                    Rectangle()
                        .fill(Color.clear) // 非選択時は透明なRectangleで高さを確保
                        .frame(height: 4)
                }

                ZStack(alignment: .center) {
                    Text(label)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .frame(width: label == "LE SSERAFIM" ? 110 : (label == "BLACKPINK" ? 100 : 90), height: 40)
                        .background(color)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
