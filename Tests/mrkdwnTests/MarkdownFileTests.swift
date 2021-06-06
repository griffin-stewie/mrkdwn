import XCTest
import class Foundation.Bundle
import Path
@testable import mrkdwnCore

final class MarkdownFileTests: XCTestCase {

    fileprivate let packageRootURL: URL = {
        let path = URL(fileURLWithPath: #file).pathComponents.prefix(while: { $0 != "Tests" }).joined(separator: "/").dropFirst()
        return URL(fileURLWithPath: String(path))
    }()
    
    var fileURL: URL {
      #if os(macOS)

      let dirURL = URL(fileURLWithPath: "Tests/fixtures/sample_markdown_files", relativeTo: packageRootURL)
      let url = URL(fileURLWithPath: "A/1.md", relativeTo: dirURL)

      return url
      #else
        return Bundle.main.bundleURL
      #endif
    }
    
    lazy var file: MarkdownFile = try! MarkdownFile(url: fileURL)

    func testExtractTitle() throws {
        XCTAssertEqual(file.title, "This is title for A/1.md")
    }
}

