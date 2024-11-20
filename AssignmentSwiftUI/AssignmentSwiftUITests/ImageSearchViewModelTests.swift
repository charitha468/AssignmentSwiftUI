import XCTest
import Combine
@testable import AssignmentSwiftUI

class ImageSearchViewModelTests: XCTestCase {
    var viewModel: ImageSearchViewModel!
    var mockFlickrService: MockFlickrService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockFlickrService = MockFlickrService()
        viewModel = ImageSearchViewModel(flickrService: mockFlickrService)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockFlickrService = nil
        cancellables = nil
        super.tearDown()
    }

    func testDebouncedSearch() {
        let expectation = XCTestExpectation(description: "Debounced search should trigger fetchImages")
        mockFlickrService.resultToReturn = .success(FlickrFeed(items: [
            FlickrItem(title: "Test", link: "https://example.com", media: Media(m: "https://example.com/image.jpg"), description: "Description", author: "Author", published: "2024-11-19T00:00:00Z")
        ]))

        viewModel.$images
            .dropFirst() 
            .sink { images in
                XCTAssertEqual(images.count, 1)
                XCTAssertEqual(images.first?.title, "Test")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.searchText = "forest"

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockFlickrService.fetchImagesCalled)
        XCTAssertEqual(mockFlickrService.tagsPassed, "forest")
    }
}
