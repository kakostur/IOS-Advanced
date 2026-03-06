import Foundation

// Track Model
struct Track: Identifiable, Hashable {
    let id: Int
    let name: String
    let artistName: String
    let collectionName: String
    let trackNumber: Int
    let durationMillis: Int
    let previewUrl: String?
    let artworkUrl: String

    var formattedDuration: String {
        let totalSeconds = durationMillis / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var hdArtworkUrl: String {
        artworkUrl.replacingOccurrences(of: "100x100bb", with: "600x600bb")
    }

    init(from result: iTunesResult) {
        self.id = result.trackId ?? 0
        self.name = result.trackName ?? "Unknown Track"
        self.artistName = result.artistName ?? "Unknown Artist"
        self.collectionName = result.collectionName ?? ""
        self.trackNumber = result.trackNumber ?? 0
        self.durationMillis = result.trackTimeMillis ?? 0
        self.previewUrl = result.previewUrl
        self.artworkUrl = result.artworkUrl100 ?? ""
    }
}
