import Foundation

protocol PageDataProvider: Sendable {
    func loadPages() async throws -> [Page]
}
