import XCTest
@testable import PinboardLog

@MainActor
final class PinboardLogTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.entries = []
    }

    func testAddEntry() {
        let entry = PinEntry(name: "Test", setName: "A", boardPosition: "B", acquiredDate: "")
        store.add(entry)
        XCTAssertEqual(store.entries.count, 1)
    }

    func testDeleteEntry() {
        let entry = PinEntry(name: "Test", setName: "A", boardPosition: "B", acquiredDate: "")
        store.add(entry)
        store.delete(entry)
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testUpdateEntry() {
        var entry = PinEntry(name: "Test", setName: "A", boardPosition: "B", acquiredDate: "")
        store.add(entry)
        entry.name = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first?.name, "Updated")
    }

    func testFreeLimitEnforced() {
        for i in 0..<Store.freeLimit {
            store.add(PinEntry(name: "Item \(i)", setName: "", boardPosition: "", acquiredDate: ""))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
        store.add(PinEntry(name: "Overflow", setName: "", boardPosition: "", acquiredDate: ""))
        XCTAssertEqual(store.entries.count, Store.freeLimit)
    }

    func testProUnlocksUnlimited() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(PinEntry(name: "Item \(i)", setName: "", boardPosition: "", acquiredDate: ""))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit + 5)
    }

    func testSeedDataBelowFreeLimit() {
        let fresh = Store()
        XCTAssertLessThan(fresh.entries.count, Store.freeLimit)
    }

    func testDeleteAtOffsets() {
        store.add(PinEntry(name: "A", setName: "", boardPosition: "", acquiredDate: ""))
        store.add(PinEntry(name: "B", setName: "", boardPosition: "", acquiredDate: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
        XCTAssertEqual(store.entries.first?.name, "B")
    }

    func testCanAddMoreInitiallyTrue() {
        XCTAssertTrue(store.canAddMore)
    }
}
