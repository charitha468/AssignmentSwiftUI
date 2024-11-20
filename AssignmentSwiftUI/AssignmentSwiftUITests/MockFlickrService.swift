import Foundation
@testable import AssignmentSwiftUI

class MockFlickrService: FlickrServiceProtocol {
    var fetchImagesCalled = false
    var tagsPassed: String?
    var resultToReturn: Result<FlickrFeed, Error>?

    func fetchImages(tags: String, completion: @escaping (Result<FlickrFeed, Error>) -> Void) {
        fetchImagesCalled = true
        tagsPassed = tags
        if let result = resultToReturn {
            completion(result)
        }
    }
}
