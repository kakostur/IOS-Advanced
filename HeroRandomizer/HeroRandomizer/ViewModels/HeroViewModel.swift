import Foundation
import Observation

@MainActor
@Observable
class HeroViewModel {
    var hero: Hero?
    var isLoading: Bool = false
    var errorMessage: String?

    private let service = HeroService()

    func loadRandomHero() async {
        isLoading = true
        errorMessage = nil
        do {
            hero = try await service.fetchRandomHero()
        } catch {
            errorMessage = "Failed to load hero. Please check your connection and try again."
        }
        isLoading = false
    }
}
