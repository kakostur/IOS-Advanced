//
//  ContentView.swift
//  RandomCardGenerator
//
//  Created by Karakat Tursynbayeva on 13.02.2026.

import SwiftUI

struct ContentView: View {
    // Data Arrays - Movies Theme
    let itemNames = [
        "Avengers",
        "Avatar",
        "Zootopia",
        "How to Train Your Dragon",
        "Titanic"
    ]
    
    let itemIcons = [
        "bolt.shield.fill",
        "leaf.circle.fill",
        "hare.fill",
        "cloud.fill",
        "ferry.fill"
    ]
    
    let itemDescriptions = [
        "Earth's mightiest heroes unite to fight threats no single hero could face alone.",
        "A paraplegic marine discovers a new world on Pandora and must choose between duty and conscience.",
        "A rookie bunny cop and a cynical con artist fox must work together to uncover a conspiracy.",
        "A young Viking befriends a dragon and changes his entire village's perspective on the creatures.",
        "An epic romance and disaster film about the ill-fated maiden voyage of the RMS Titanic."
    ]
    
    let itemRatings = [5, 4, 3, 5, 4]
    
    // State Variables
    @State private var currentIndex = 0
    @State private var tapCount = 0
    
    var body: some View {
        ZStack {
            // Background gradient based on difficulty
            backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                // Item Icon
                Image(systemName: itemIcons[currentIndex])
                    .font(.system(size: 80))
                    .foregroundStyle(.pink)
                    .padding(.top, 20)
                
                // Item Name
                Text(itemNames[currentIndex])
                    .font(.system(.title, design: .rounded))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Divider
                Divider()
                    .padding(.horizontal, 40)
                
                // Description
                Text(itemDescriptions[currentIndex])
                    .font(.system(.body, design: .serif))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .frame(minHeight: 60)
                
                // Rating
                VStack(spacing: 8) {
                    Text("Excitement:")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundStyle(.secondary)
                    
                    if itemRatings[currentIndex] == 0 {
                        Text("Not rated yet")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(String(repeating: "🍿", count: itemRatings[currentIndex]))
                            .font(.title2)
                    }
                }
                .padding(.vertical, 10)
                
                // Surprise Me Button
                Button(action: {
                    generateNewCard()
                }) {
                    HStack {
                        Image(systemName: "shuffle")
                        Text("Surprise Me!")
                    }
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.red)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .padding(.top, 10)
                
                // Tap Counter
                Text("Cards explored: \(tapCount)")
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 30)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 10)
            )
            .padding(30)
        }
    }
    
    // Computed property for background gradient
    private var backgroundGradient: LinearGradient {
        let rating = itemRatings[currentIndex]
        
        switch rating {
        case 0...2:
            return LinearGradient(
                colors: [
                    Color(red: 0.9, green: 0.95, blue: 1.0),
                    Color(red: 0.95, green: 0.9, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 3:
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.95, blue: 0.9),
                    Color(red: 1.0, green: 0.9, blue: 0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 4...5:
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.9, blue: 0.9),
                    Color(red: 0.95, green: 0.95, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.95, blue: 0.95),
                    Color(red: 0.9, green: 0.9, blue: 0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // Random Selection Logic
    private func generateNewCard() {
        var newIndex: Int
        repeat {
            newIndex = Int.random(in: 0..<itemNames.count)
        } while newIndex == currentIndex
        
        currentIndex = newIndex
        tapCount += 1
    }
}

#Preview {
    ContentView()
}
