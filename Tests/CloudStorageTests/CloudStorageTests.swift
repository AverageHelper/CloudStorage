import XCTest
@testable import CloudStorage

final class CloudStorageTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CloudStorage().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
