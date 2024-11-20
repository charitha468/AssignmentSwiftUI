import Combine
import Foundation

class ImageSearchViewModel: ObservableObject {
    @Published var searchText: String = "" // Observed by Combine
    @Published var images: [FlickrItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let flickrService: FlickrServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(flickrService: FlickrServiceProtocol) {
        self.flickrService = flickrService
        setupSearchObserver()
    }

    private func setupSearchObserver() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.searchImages(tags: text)
            }
            .store(in: &cancellables)
    }

    func searchImages(tags: String) {
        guard !tags.isEmpty else {
            self.images = []
            return
        }

        isLoading = true
        errorMessage = nil

        flickrService.fetchImages(tags: tags) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let feed):
                    self?.images = feed.items
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
