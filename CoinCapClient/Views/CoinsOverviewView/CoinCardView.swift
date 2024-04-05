import SwiftUI

struct CoinCardView: View {
    let asset: Asset
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncCoinIcon(url: asset.symbolURL, imageSideLength: 56)
            VStack(spacing: 16) {
                VStack(spacing: 0) {
                    HStack {
                        Text(asset.name)
                            .font(.poppinsBold(size: 20))
                        Spacer()
                        Text(asset.price)
                            .font(.poppinsBold(size: 20))
                    }
                    HStack {
                        Text(asset.symbol)
                            .font(.poppinsRegular(size: 16))
                        Spacer()
                        Text(asset.percentage)
                            .font(.poppinsBold(size: 16))
                            .foregroundStyle(asset.isPercentageChangePositive ? Color.positiveAccent : Color.negativeAccent)
                    }
                }
                HStack {
                    Spacer()
                    Image("Arrow")
                }
            }
        }
        .foregroundStyle(Color.primaryText)
        .padding(.init(top: 16, leading: 16, bottom: 16, trailing: 12))
        .background(Color.white.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

import Core

#Preview {
    VStack {
        Spacer()
        CoinCardView(asset: Asset.fake())
        Spacer()
    }
    .gradientBackground()
}
