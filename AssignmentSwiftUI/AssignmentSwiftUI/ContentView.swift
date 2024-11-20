import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ImageSearchViewModel(
        flickrService: FlickrService(networkService: NetworkService())
    )

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search tags (e.g., forest, bird)", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
                else if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                }
                else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                            ForEach(viewModel.images, id: \.link) { item in
                                NavigationLink(destination: DetailView(image: item)) {
                                    AsyncImage(url: URL(string: item.media.m)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}
