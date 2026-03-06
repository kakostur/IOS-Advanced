import SwiftUI

struct PlayerView: View {

    @State var viewModel: PlayerViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemBackground), Color.accentColor.opacity(0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Artwork
                AsyncImage(url: URL(string: viewModel.currentTrack.hdArtworkUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fit)
                    default:
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                Image(systemName: "music.note")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.secondary)
                            )
                    }
                }
                .frame(width: 280, height: 280)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                .scaleEffect(viewModel.isPlaying ? 1.0 : 0.92)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.isPlaying)
                .id(viewModel.currentTrack.id) // re-render artwork on track change

                Spacer().frame(height: 40)

                // Track Info
                VStack(spacing: 8) {
                    Text(viewModel.currentTrack.name)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 32)
                        .animation(.easeInOut, value: viewModel.currentTrack.id)

                    Text(viewModel.currentTrack.artistName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(viewModel.currentTrack.collectionName)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Spacer().frame(height: 32)

                // Progress Bar
                VStack(spacing: 6) {
                    Slider(value: $viewModel.currentTime, in: 0...viewModel.duration)
                        .tint(.primary)
                        .padding(.horizontal, 32)

                    HStack {
                        Text(formatTime(viewModel.currentTime))
                        Spacer()
                        Text(formatTime(viewModel.duration))
                    }
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 36)
                }

                Spacer().frame(height: 40)

                // Playback Controls
                HStack(spacing: 56) {
                    // Previous
                    Button(action: { viewModel.previousTrack() }) {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 26))
                    }
                    .foregroundStyle(viewModel.hasPrevious ? .primary : .tertiary)
                    .disabled(!viewModel.hasPrevious && viewModel.currentTime <= 3.0)

                    // Play / Pause
                    Button(action: { viewModel.togglePlayPause() }) {
                        Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 72))
                    }
                    .foregroundStyle(.primary)

                    // Next
                    Button(action: { viewModel.nextTrack() }) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 26))
                    }
                    .foregroundStyle(viewModel.hasNext ? .primary : .tertiary)
                    .disabled(!viewModel.hasNext)
                }

                Spacer().frame(height: 16)

                if viewModel.currentTrack.previewUrl != nil {
                    Text("30-second preview")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Spacer()
            }
        }
        .navigationTitle("Now Playing")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.cleanup()
        }
    }

    private func formatTime(_ seconds: Double) -> String {
        let total = Int(seconds)
        let m = total / 60
        let s = total % 60
        return String(format: "%d:%02d", m, s)
    }
}
