import SwiftUI

struct DetailView: View {
    let image: FlickrItem

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: image.media.m)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)

                Text(image.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text("Author: \(image.author)")
                    .font(.subheadline)

                Text("Published: \(formattedDate(image.published))")
                    .font(.footnote)

                Text(image.description)
                    .font(.body)
                    .padding()
            }
            .padding()
        }
    }

    private func formattedDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}
