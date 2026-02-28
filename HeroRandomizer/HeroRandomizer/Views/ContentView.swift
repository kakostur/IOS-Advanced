import SwiftUI

struct ContentView: View {
    @State private var viewModel = HeroViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                if viewModel.isLoading {
                    //  Loading State
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Finding a hero...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else if let error = viewModel.errorMessage {
                    //  Error State
                    VStack(spacing: 16) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundStyle(.red.opacity(0.7))
                        Text(error)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 40)
                        RandomizeButton {
                            Task { await viewModel.loadRandomHero() }
                        }
                    }
                } else if let hero = viewModel.hero {
                    // Hero Content
                    HeroDetailView(hero: hero)
                        .transition(.opacity.combined(with: .scale(scale: 0.97)))
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "bolt.shield.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.yellow)
                        Text("HeroRandomizer")
                            .font(.largeTitle.bold())
                        Text("Tap the button to discover a random superhero")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        RandomizeButton {
                            Task { await viewModel.loadRandomHero() }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.hero != nil && !viewModel.isLoading ? "" : "HeroRandomizer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if viewModel.hero != nil {
                    ToolbarItem(placement: .bottomBar) {
                        RandomizeButton {
                            Task { await viewModel.loadRandomHero() }
                        }
                        .padding(.bottom, 8)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.hero?.id)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
        }
        .task {
            await viewModel.loadRandomHero()
        }
    }
}

// Randomize Button
struct RandomizeButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Randomize Hero", systemImage: "shuffle")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [.red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .blue.opacity(0.4), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
