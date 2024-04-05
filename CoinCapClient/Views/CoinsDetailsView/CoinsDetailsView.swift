import Core
import SwiftUI

struct CoinsDetailsView: View {
    @EnvironmentObject var viewModel: CoinsViewModel
    let asset: Asset

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 24) {
                captionValueView(caption: "Price", value: asset.price)
                captionValueView(
                    caption: "Change (24 hr)",
                    value: asset.percentage,
                    valueColor: asset.isPercentageChangePositive ? .positiveAccent : .negativeAccent
                )
                Divider()
                    .frame(height: 1)
                    .overlay(Color.dividerColor)
                captionValueView(caption: "Market Cap", value: asset.marketCap)
                captionValueView(caption: "Volume (24hr)", value: asset.volume)
                captionValueView(caption: "Supply", value: asset.readableSupply)
            }
            Spacer()
        }
        .padding(24)
        .overlay {
            if viewModel.isUpdatingAsset {
                ZStack {
                    Color.white.opacity(0.7)
                    ProgressView()
                }
            }
        }
        .background(Color.white.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Text(asset.name.uppercased())
                        .font(.poppinsBold(size: 32))
                        .foregroundStyle(Color.primaryText)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                AsyncCoinIcon(url: asset.symbolURL, imageSideLength: 40)
            }
        }
        .toolbarRole(.editor) // removes "Back" text from the left bar button
        .gradientBackground()
        .task {
            await viewModel.updateAsset(asset)
        }
        .onDisappear {
            viewModel.cancelAssetUpdate()
        }
        .alert(isPresented: $viewModel.showUpdateError) {
            Alert(title: Text("Something went wrong. We are working on better error handling..."))
        }
    }

    private func captionValueView(caption: String, value: String, valueColor: Color = .primaryText) -> some View {
        HStack {
            Text(caption)
                .foregroundStyle(Color.primaryText)
                .font(.poppinsRegular(size: 16))
            Spacer()
            Text(value)
                .foregroundStyle(valueColor)
                .font(.poppinsBold(size: 16))
        }
    }
}

#Preview {
    NavigationStack {
        CoinsDetailsView(asset: Asset.fake(
            symbol: "ETH",
            name: "Etherium",
            priceUsd: "80000000.800000",
            changePercent24Hr: "+42.42"
        ))
        .environmentObject(CoinsViewModel(assetsService: AssetsServiceMock()))
    }
}
