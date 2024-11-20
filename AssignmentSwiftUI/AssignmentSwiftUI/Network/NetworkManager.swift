import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case noData
    case decodingError
}
