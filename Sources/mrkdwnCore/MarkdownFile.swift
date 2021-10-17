import Foundation
import Markdown

public struct MarkdownFile {
    public enum Style: String, CaseIterable {
        case none
        case ordered
        case unordered
        
        var syntax: String {
            switch self {
            case .none:
                return ""
            case .ordered:
                return "1. "
            case .unordered:
                return "- "
            }
        }
    }
    
    public let url: URL
    public private(set) var title: String
    
    public init(url: URL) throws {
        self.url = url

        let doc = try Document(parsing: self.url)
        self.title = try Self.extractTitle(document: doc)
    }
    
    public func link(style: Style = .unordered) throws -> String {
        return "\(style.syntax)[\(title)](\(url.relativePath))"
    }
}

struct HeadingLevel1Walker: MarkupWalker {
    var foundFirstH1: Bool = false
    var title: String = ""

    mutating func visitHeading(_ heading: Heading) {
        if heading.level == 1 {
            foundFirstH1 = true
            title = heading.plainText
        }
        descendInto(heading)
    }
}

extension MarkdownFile {
    private static func extractTitle(document: Document) throws -> String {
        var walker = HeadingLevel1Walker()
        walker.visit(document)
        return walker.title
    }
}
