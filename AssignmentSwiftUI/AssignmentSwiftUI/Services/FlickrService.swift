
import Foundation

protocol FlickrServiceProtocol {
    func fetchImages(
        tags: String,
        completion: @escaping (Result<FlickrFeed, Error>) -> Void
    )
}


class FlickrService: FlickrServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"

    // Dependency injection of the network layer
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchImages(
        tags: String,
        completion: @escaping (Result<FlickrFeed, Error>) -> Void
    ) {
        let urlString = "\(baseURL)&tags=\(tags)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.noData))
            return
        }

        networkService.request(url: url, completion: completion)
    }
}
