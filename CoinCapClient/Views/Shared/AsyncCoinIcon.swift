import SwiftUI

struct AsyncCoinIcon: View {
    let url: URL?
    let imageSideLength: CGFloat
    var body: some View {
        AsyncImage(
            url: url,
            content: { image in
                image.resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: imageSideLength, height: imageSideLength)
            },
            placeholder: {
                ProgressView()
            }
        )
    }
}
