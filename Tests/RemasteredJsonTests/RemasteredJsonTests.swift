import XCTest
@testable import RemasteredJson

final class RemasteredJsonTests: XCTestCase {
    func testExample() {
        do {
            let test: TestObj = try RemasteredJson<TestObj>().decode(localUrl: Bundle.module.url(forResource: "test", withExtension: "json"))
            print(test.foo)
            print(test.bar)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TestObj: Codable {
    var id: UUID? = UUID()
    let foo: String
    let bar: String
}
