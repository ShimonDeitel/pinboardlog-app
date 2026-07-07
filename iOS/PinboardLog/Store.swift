import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [PinEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier item cap. Always kept well above seed data count so a fresh
    /// install never hits the paywall immediately.
    static let freeLimit = 10

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("PinboardLog", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: PinEntry) {
        guard canAddMore else { return }
        entries.append(entry)
        save()
    }

    func update(_ entry: PinEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: PinEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([PinEntry].self, from: data) {
            entries = decoded
        } else {
            entries = [
        PinEntry(name: "Studio Ghibli S1", setName: "Studio Ghibli S1", boardPosition: "Row 1 - A1", acquiredDate: ""),
        PinEntry(name: "Nat'l Parks", setName: "Nat'l Parks", boardPosition: "Row 1 - A2", acquiredDate: ""),
        PinEntry(name: "Retro Consoles", setName: "Retro Consoles", boardPosition: "Row 2 - B1", acquiredDate: "")
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
