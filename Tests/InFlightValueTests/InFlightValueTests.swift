import XCTest
@testable import InFlightValue

final class InFlightValueTests: XCTestCase {

    func testRandomNumbers() async throws {
        let inFlightValue = InFlightValueProvider {
            Int.random(in: 0...1000)
        }

        async let call1 = inFlightValue.get()
        async let call2 = inFlightValue.get()
        async let call3 = inFlightValue.get()

        let value1 = try await call1
        let value2 = try await call2
        let value3 = try await call3

        XCTAssertEqual(value1, value2)
        XCTAssertEqual(value2, value3)

        await Task.sleep(1000000000)

        // after our thread has been suspended, we expect another value from the provider
        let value4 = try await inFlightValue.get()

        XCTAssertNotEqual(value3, value4)
    }

}
