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

        public func document(with lists: [ListItem]) -> Document {
            var doc = Document()
            switch self {
            case .none:
                doc.setBlockChildren(lists)
            case .ordered:
                doc.setBlockChildren([OrderedList(lists)])
            case .unordered:
                doc.setBlockChildren([UnorderedList(lists)])
            }

            return doc
        }

        public func formatterOptions() -> MarkupFormatter.Options {
            MarkupFormatter.Options(unorderedListMarker: .dash,
                                    orderedListNumerals: .allSame(1))
        }
    }
    
    public let url: URL
    public private(set) var title: String
    
    public init(url: URL) throws {
        self.url = url

        let doc = try Document(parsing: self.url)
        self.title = try Self.extractTitle(document: doc)
    }
    
    public func link(style: Style = .unordered) -> String {
        return "\(style.syntax)[\(title)](\(url.relativePath))"
    }

    public func listItem() -> ListItem {
        return ListItem(
            Paragraph(
                Link(destination: url.relativePath, Text(title))
            )
        )
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
