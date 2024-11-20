import Foundation

struct FlickrFeed: Codable {
    let items: [FlickrItem]
}

struct FlickrItem: Codable {
    let title: String
    let link: String
    let media: Media
    let description: String
    let author: String
    let published: String
}

struct Media: Codable {
    let m: String
}
