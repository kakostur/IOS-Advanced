//
//  ContentView.swift
//  Favorite List
//
//  Created by Karakat Tursynbayeva on 21.02.2026.
//
import SwiftUI


struct FavoriteItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let emoji: String
    var isFavorite: Bool = false
}


struct FavoriteRow: View {
    let item: FavoriteItem
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(item.emoji)
                .font(.title2)
                .frame(width: 36, height: 36)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onToggleFavorite) {
                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(item.isFavorite ? .red : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}


struct SectionHeaderView: View {
    let title: String
    let emoji: String

    var body: some View {
        HStack(spacing: 6) {
            Text(emoji)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
        }
        .foregroundColor(.primary)
    }
}


struct ContentView: View {

    @State private var musicItems: [FavoriteItem] = [
        FavoriteItem(title: "Dynamite", subtitle: "BTS · K-Pop · 2020", emoji: "💜"),
        FavoriteItem(title: "LALISA", subtitle: "LISA · K-Pop · 2021", emoji: "👑"),
        FavoriteItem(title: "Fancy", subtitle: "TWICE · K-Pop · 2019", emoji: "🌸"),
        FavoriteItem(title: "Pink Venom", subtitle: "BLACKPINK · K-Pop · 2022", emoji: "🖤"),
        FavoriteItem(title: "Lose Yourself", subtitle: "Eminem · Rap · 2002", emoji: "🎤"),
        FavoriteItem(title: "Without Me", subtitle: "Eminem · Rap · 2002", emoji: "🔥"),
        FavoriteItem(title: "Rap God", subtitle: "Eminem · Rap · 2013", emoji: "⚡"),
        FavoriteItem(title: "As It Was", subtitle: "Harry Styles · Pop · 2022", emoji: "🌊"),
        FavoriteItem(title: "Flowers", subtitle: "Miley Cyrus · Pop · 2023", emoji: "🌺"),
        FavoriteItem(title: "Cruel Summer", subtitle: "Taylor Swift · Pop · 2019", emoji: "☀️"),
    ]

    // Movies — Marvel & Netflix
    @State private var movieItems: [FavoriteItem] = [
        FavoriteItem(title: "Avengers: Endgame", subtitle: "Marvel · Action · 2019", emoji: "🦸"),
        FavoriteItem(title: "Spider-Man: No Way Home", subtitle: "Marvel · Action · 2021", emoji: "🕷️"),
        FavoriteItem(title: "Iron Man", subtitle: "Marvel · Sci-Fi · 2008", emoji: "🤖"),
        FavoriteItem(title: "Black Panther", subtitle: "Marvel · Action · 2018", emoji: "🐾"),
        FavoriteItem(title: "Doctor Strange", subtitle: "Marvel · Fantasy · 2016", emoji: "🔮"),
        FavoriteItem(title: "Extraction", subtitle: "Netflix · Thriller · 2020", emoji: "💥"),
        FavoriteItem(title: "The Gray Man", subtitle: "Netflix · Action · 2022", emoji: "🕵️"),
        FavoriteItem(title: "Bird Box", subtitle: "Netflix · Horror · 2018", emoji: "👁️"),
        FavoriteItem(title: "Knives Out", subtitle: "Netflix · Mystery · 2019", emoji: "🔪"),
        FavoriteItem(title: "Glass Onion", subtitle: "Netflix · Mystery · 2022", emoji: "🧅"),
    ]

    // Travel — Europe
    @State private var travelItems: [FavoriteItem] = [
        FavoriteItem(title: "Paris, France", subtitle: "City of Light & Love", emoji: "🗼"),
        FavoriteItem(title: "Rome, Italy", subtitle: "The Eternal City", emoji: "🏛️"),
        FavoriteItem(title: "Santorini, Greece", subtitle: "White Houses & Blue Domes", emoji: "🌅"),
        FavoriteItem(title: "Barcelona, Spain", subtitle: "Gaudí & Beach Life", emoji: "🎨"),
        FavoriteItem(title: "Prague, Czech Republic", subtitle: "Fairytale Old Town", emoji: "🏰"),
        FavoriteItem(title: "Amsterdam, Netherlands", subtitle: "Canals & Tulips", emoji: "🌷"),
        FavoriteItem(title: "Vienna, Austria", subtitle: "Classical Music & Coffee", emoji: "🎻"),
        FavoriteItem(title: "Amalfi Coast, Italy", subtitle: "Cliffs & Crystal Waters", emoji: "🚢"),
        FavoriteItem(title: "Reykjavik, Iceland", subtitle: "Northern Lights & Geysers", emoji: "🌌"),
        FavoriteItem(title: "Dubrovnik, Croatia", subtitle: "Pearl of the Adriatic", emoji: "🌊"),
    ]

    // Books
    @State private var bookItems: [FavoriteItem] = [
        FavoriteItem(title: "Murder on the Orient Express", subtitle: "Agatha Christie · Mystery · 1934", emoji: "🚂"),
        FavoriteItem(title: "And Then There Were None", subtitle: "Agatha Christie · Mystery · 1939", emoji: "🏝️"),
        FavoriteItem(title: "Death on the Nile", subtitle: "Agatha Christie · Mystery · 1937", emoji: "🐊"),
        FavoriteItem(title: "The ABC Murders", subtitle: "Agatha Christie · Mystery · 1936", emoji: "🔍"),
        FavoriteItem(title: "Little Women", subtitle: "Louisa May Alcott · Classic · 1868", emoji: "🎀"),
        FavoriteItem(title: "Good Wives", subtitle: "Louisa May Alcott · Classic · 1869", emoji: "💌"),
        FavoriteItem(title: "Pride and Prejudice", subtitle: "Jane Austen · Fiction · 1813", emoji: "🌹"),
        FavoriteItem(title: "The Great Gatsby", subtitle: "F. Scott Fitzgerald · Fiction · 1925", emoji: "🥂"),
        FavoriteItem(title: "Jane Eyre", subtitle: "Charlotte Brontë · Fiction · 1847", emoji: "🕯️"),
        FavoriteItem(title: "The Secret Garden", subtitle: "Frances H. Burnett · Fiction · 1911", emoji: "🌿"),
    ]

    // Computed total count
    private var totalCount: Int {
        musicItems.count + movieItems.count + travelItems.count + bookItems.count
    }

    var body: some View {
        NavigationStack {
            List {
                // Music Section
                Section(header: SectionHeaderView(title: "Music", emoji: "🎵")) {
                    ForEach($musicItems) { $item in
                        FavoriteRow(item: item) {
                            item.isFavorite.toggle()
                        }
                    }
                }

                // Movies Section
                Section(header: SectionHeaderView(title: "Movies", emoji: "🎬")) {
                    ForEach($movieItems) { $item in
                        FavoriteRow(item: item) {
                            item.isFavorite.toggle()
                        }
                    }
                }

                // Travel Section
                Section(header: SectionHeaderView(title: "Travel · Europe", emoji: "✈️")) {
                    ForEach($travelItems) { $item in
                        FavoriteRow(item: item) {
                            item.isFavorite.toggle()
                        }
                    }
                }

                //  Books Section
                Section(header: SectionHeaderView(title: "Books", emoji: "📚")) {
                    ForEach($bookItems) { $item in
                        FavoriteRow(item: item) {
                            item.isFavorite.toggle()
                        }
                    }
                }

                // Footer with item count
                Section {
                    HStack {
                        Spacer()
                        Text("\(totalCount) favorites in your list")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            .navigationTitle("My Favorites ✨")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


#Preview {
    ContentView()
}
