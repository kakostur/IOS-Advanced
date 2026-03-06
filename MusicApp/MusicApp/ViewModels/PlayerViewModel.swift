import Foundation
import AVKit
import Observation

@Observable
final class PlayerViewModel {

    //  State
    var currentTrack: Track
    var isPlaying: Bool = false
    var currentTime: Double = 0.0
    var duration: Double = 30.0

    var hasPrevious: Bool { currentIndex > 0 }
    var hasNext: Bool { currentIndex < tracks.count - 1 }

    // Private
    private let tracks: [Track]
    private var currentIndex: Int
    private var player: AVPlayer?
    private var timeObserver: Any?

    init(track: Track, tracks: [Track]) {
        self.tracks = tracks
        self.currentIndex = tracks.firstIndex(where: { $0.id == track.id }) ?? 0
        self.currentTrack = track
    }

    // Playback Controls

    func togglePlayPause() {
        isPlaying ? pause() : play()
    }

    func play() {
        if player == nil {
            setupPlayer()
        }
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func nextTrack() {
        guard hasNext else { return }
        currentIndex += 1
        switchTrack(to: tracks[currentIndex])
    }

    func previousTrack() {
        if currentTime > 3.0 {
            seekToStart()
        } else if hasPrevious {
            currentIndex -= 1
            switchTrack(to: tracks[currentIndex])
        }
    }

    func cleanup() {
        removeTimeObserver()
        player?.pause()
        player = nil
    }

    //  Private

    private func switchTrack(to track: Track) {
        cleanup()
        currentTrack = track
        currentTime = 0.0
        duration = 30.0
        isPlaying = false
        play()
    }

    private func setupPlayer() {
        guard let urlString = currentTrack.previewUrl,
              let url = URL(string: urlString) else { return }

        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        setupTimeObserver()
    }

    private func seekToStart() {
        player?.seek(to: .zero)
        currentTime = 0.0
    }

    private func setupTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
        }

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            if self.hasNext {
                self.nextTrack()
            } else {
                self.isPlaying = false
                self.currentTime = 0.0
                self.player?.seek(to: .zero)
            }
        }
    }

    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        NotificationCenter.default.removeObserver(self)
    }
}
