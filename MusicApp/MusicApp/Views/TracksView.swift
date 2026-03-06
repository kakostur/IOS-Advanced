import SwiftUI

struct TracksView: View {

    var viewModel: TracksViewModel
    // Now passes both the selected track AND the full list
    var onTrackSelected: ((Track, [Track]) -> Void)?

    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(message: error)
            } else {
                tracksList
            }
        }
        .navigationTitle(viewModel.album.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.tracks.isEmpty {
                await viewModel.loadTracks()
            }
        }
    }

    // Subviews

    private var tracksList: some View {
        List {
            Section {
                albumHeaderView
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }

            Section {
                ForEach(viewModel.tracks) { track in
                    TrackRowView(track: track)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onTrackSelected?(track, viewModel.tracks)
                        }
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
            } header: {
                Text("Tracks")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .textCase(nil)
            }
        }
        .listStyle(.insetGrouped)
    }

    private var albumHeaderView: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: viewModel.album.hdArtworkUrl)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                default:
                    Color.gray.opacity(0.2)
                        .overlay(Image(systemName: "music.note").font(.system(size: 40)).foregroundStyle(.secondary))
                }
            }
            .frame(width: 200, height: 200)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)

            VStack(spacing: 6) {
                Text(viewModel.album.name)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)

                Text(viewModel.album.artistName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("\(viewModel.album.releaseYear) · \(viewModel.album.trackCount) tracks")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView().scaleEffect(1.5)
            Text("Loading tracks...").foregroundStyle(.secondary)
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.exclamationmark").font(.system(size: 50)).foregroundStyle(.secondary)
            Text("Could not load tracks").font(.headline)
            Text(message).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center).padding(.horizontal)
            Button("Try Again") { Task { await viewModel.loadTracks() } }.buttonStyle(.borderedProminent)
        }
    }
}

// TrackRowView
struct TrackRowView: View {
    let track: Track

    var body: some View {
        HStack(spacing: 12) {
            Text("\(track.trackNumber)")
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .trailing)

            AsyncImage(url: URL(string: track.artworkUrl)) { phase in
                if case .success(let image) = phase {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else {
                    Color.gray.opacity(0.2)
                }
            }
            .frame(width: 44, height: 44)
            .cornerRadius(6)

            VStack(alignment: .leading, spacing: 3) {
                Text(track.name).font(.system(size: 15, weight: .medium)).lineLimit(1)
                Text(track.artistName).font(.system(size: 13)).foregroundStyle(.secondary).lineLimit(1)
            }

            Spacer()

            Text(track.formattedDuration)
                .font(.system(size: 13, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }
}
