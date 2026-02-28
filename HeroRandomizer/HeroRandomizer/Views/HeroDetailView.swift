import SwiftUI

struct HeroDetailView: View {
    let hero: Hero

    private let statColors: [Color] = [.blue, .red, .green, .orange, .purple, .pink]
    private let statLabels = ["Intelligence", "Strength", "Speed", "Durability", "Power", "Combat"]

    var statValues: [Int] {
        let ps = hero.powerstats
        return [ps.intelligence, ps.strength, ps.speed, ps.durability, ps.power, ps.combat]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image
                AsyncImage(url: URL(string: hero.images.lg)) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.2)
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.2)
                            Image(systemName: "person.fill")
                                .font(.system(size: 80))
                                .foregroundStyle(.gray)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 340)
                .clipped()
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.6)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                }
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(hero.name)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                        if !hero.biography.fullName.isEmpty && hero.biography.fullName != hero.name {
                            Text(hero.biography.fullName)
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.85))
                        }
                    }
                    .padding()
                }

                VStack(spacing: 16) {
                    // Powerstats
                    GroupBox {
                        VStack(spacing: 10) {
                            ForEach(Array(zip(statLabels, statValues)), id: \.0) { label, value in
                                PowerstatBar(label: label, value: value, color: statColors[statLabels.firstIndex(of: label)!])
                            }
                        }
                        .padding(.top, 4)
                    } label: {
                        Label("Power Stats", systemImage: "bolt.fill")
                            .font(.headline)
                    }

                    // Appearance
                    GroupBox {
                        VStack(alignment: .leading, spacing: 0) {
                            InfoRow(label: "Gender", value: hero.appearance.gender)
                            Divider()
                            InfoRow(label: "Race", value: hero.appearance.race ?? "Unknown")
                            Divider()
                            InfoRow(label: "Height", value: hero.appearance.height.joined(separator: " / "))
                            Divider()
                            InfoRow(label: "Weight", value: hero.appearance.weight.joined(separator: " / "))
                            Divider()
                            InfoRow(label: "Eye Color", value: hero.appearance.eyeColor)
                            Divider()
                            InfoRow(label: "Hair Color", value: hero.appearance.hairColor)
                        }
                    } label: {
                        Label("Appearance", systemImage: "person.fill")
                            .font(.headline)
                    }

                    // Biography
                    GroupBox {
                        VStack(alignment: .leading, spacing: 0) {
                            InfoRow(label: "Publisher", value: hero.biography.publisher ?? "Unknown")
                            Divider()
                            InfoRow(label: "Alignment", value: hero.biography.alignment.capitalized)
                            Divider()
                            InfoRow(label: "Place of Birth", value: hero.biography.placeOfBirth)
                            Divider()
                            InfoRow(label: "First Appearance", value: hero.biography.firstAppearance)
                        }
                    } label: {
                        Label("Biography", systemImage: "book.fill")
                            .font(.headline)
                    }

                    // Work and Connections
                    GroupBox {
                        VStack(alignment: .leading, spacing: 0) {
                            InfoRow(label: "Occupation", value: hero.work.occupation)
                            Divider()
                            InfoRow(label: "Base", value: hero.work.base)
                            Divider()
                            InfoRow(label: "Group", value: hero.connections.groupAffiliation)
                        }
                    } label: {
                        Label("Work & Connections", systemImage: "briefcase.fill")
                            .font(.headline)
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}
