import Foundation

// iTunes API Response
struct iTunesResponse: Codable {
    let resultCount: Int
    let results: [iTunesResult]
}

struct iTunesResult: Codable {
    let wrapperType: String?
    let collectionId: Int?
    let collectionName: String?
    let artistName: String?
    let artworkUrl100: String?
    let trackCount: Int?
    let releaseDate: String?
    let trackId: Int?
    let trackName: String?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let previewUrl: String?
    let collectionArtistName: String?
}

// Album Model
struct Album: Identifiable, Hashable {
    let id: Int
    let name: String
    let artistName: String
    let artworkUrl: String
    let trackCount: Int
    let releaseDate: String

    var hdArtworkUrl: String {
        artworkUrl.replacingOccurrences(of: "100x100bb", with: "600x600bb")
    }

    var releaseYear: String {
        String(releaseDate.prefix(4))
    }

    init(from result: iTunesResult) {
        self.id = result.collectionId ?? 0
        self.name = result.collectionName ?? "Unknown Album"
        self.artistName = result.artistName ?? "Unknown Artist"
        self.artworkUrl = result.artworkUrl100 ?? ""
        self.trackCount = result.trackCount ?? 0
        self.releaseDate = result.releaseDate ?? ""
    }
}
