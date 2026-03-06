import SwiftUI

// MARK: - AlbumsView
struct AlbumsView: View {

    var viewModel: AlbumsViewModel
    var onAlbumSelected: ((Album) -> Void)?

    @State private var searchText: String = ""

    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(message: error)
            } else {
                albumsList
            }
        }
        .navigationTitle("Albums")
        .searchable(text: $searchText, prompt: "Search albums...")
        .onSubmit(of: .search) {
            Task { await viewModel.search(query: searchText) }
        }
        .task {
            if viewModel.albums.isEmpty {
                await viewModel.loadAlbums()
            }
        }
    }

    // MARK: - Subviews

    private var albumsList: some View {
        List(viewModel.albums) { album in
            AlbumRowView(album: album)
                .contentShape(Rectangle())
                .onTapGesture {
                    onAlbumSelected?(album)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(.plain)
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading albums...")
                .foregroundStyle(.secondary)
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            Text("Something went wrong")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Try Again") {
                Task { await viewModel.loadAlbums() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - AlbumRowView
struct AlbumRowView: View {
    let album: Album

    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: album.artworkUrl)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    placeholderArt
                default:
                    placeholderArt.overlay(ProgressView())
                }
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(album.name)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(2)

                Text(album.artistName)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text("\(album.trackCount) tracks · \(album.releaseYear)")
                    .font(.system(size: 12))
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 2)
    }

    private var placeholderArt: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .overlay(
                Image(systemName: "music.note")
                    .foregroundStyle(.secondary)
            )
    }
}
