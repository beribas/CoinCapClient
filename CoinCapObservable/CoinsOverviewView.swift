import Core
import SwiftUI

struct CoinsOverviewView: View {
    @Environment(CoinsViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.assets) { asset in
                                NavigationLink {
                                    CoinsDetailsView(asset: asset)
                                } label: {
                                    CoinCardView(asset: asset)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.init(top: 8, leading: 16, bottom: 24, trailing: 16))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.gradientTop, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Text("COINS")
                            .font(.poppinsBold(size: 32))
                            .foregroundStyle(Color.primaryText)
                    }
                }
            }
            .gradientBackground()
        }
        .task {
            await viewModel.fetchAssets()
        }
        .alert(isPresented: $viewModel.showFetchError) {
            Alert(title: Text("Something went wrong. We are working on better error handling..."))
        }
    }
}

#Preview {
    let fakeAssets = (0 ... 20)
        .map(String.init)
        .map { Asset.fake(id: $0) }
    let serviceMock = AssetsServiceMock()
    serviceMock.assetsResult = .success(fakeAssets)
    return CoinsOverviewView()
        .environment(CoinsViewModel(assetsService: serviceMock))
}
