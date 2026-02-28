import Foundation

struct HeroService {
    private let baseURL = "https://akabab.github.io/superhero-api/api"

    func fetchRandomHero() async throws -> Hero {
        let randomID = Int.random(in: 1...731)
        guard let url = URL(string: "\(baseURL)/id/\(randomID).json") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Hero.self, from: data)
    }
}
