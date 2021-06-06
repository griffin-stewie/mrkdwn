import Foundation
import Down

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
        
        let contents = try String(contentsOf: self.url)
        let down = Down(markdownString: contents)
        self.title = try Self.extractTitle(down: down)
    }
    
    public func link(style: Style = .unordered) throws -> String {
        return "\(style.syntax)[\(title)](\(url.relativePath))"
    }
}

extension MarkdownFile {
    private static func extractTitle(down: Down) throws -> String {
        let ast = try down.toAST()
        guard let doc = ast.wrap() as? Document else {
            return ""
        }
        
        return doc.accept(TitleVisitor())
    }
}

final class TitleVisitor: Visitor {
    
    var foundFirstH1: Bool = false

    var title: String = ""
    
    // MARK: - Helpers

    private func report(_ node: Node) -> String {
        return "\(String(reflecting: node))\n"
    }

    private func reportWithChildren(_ node: Node) -> String {
        if foundFirstH1 && !title.isEmpty {
            return title
        }
     
        let children = visitChildren(of: node).joined()
        
        if title.isEmpty {
            title = children
        }

        return title
    }
    // MARK: - Visitor

    public typealias Result = String

    public func visit(document node: Document) -> String {
        return reportWithChildren(node)
    }

    public func visit(blockQuote node: BlockQuote) -> String {
        return reportWithChildren(node)
    }

    public func visit(list node: List) -> String {
        return reportWithChildren(node)
    }

    public func visit(item node: Item) -> String {
        return reportWithChildren(node)
    }

    public func visit(codeBlock node: CodeBlock) -> String {
        return reportWithChildren(node)
    }

    public func visit(htmlBlock node: HtmlBlock) -> String {
        return reportWithChildren(node)
    }

    public func visit(customBlock node: CustomBlock) -> String {
        return reportWithChildren(node)
    }

    public func visit(paragraph node: Paragraph) -> String {
        return reportWithChildren(node)
    }

    public func visit(heading node: Heading) -> String {
        if node.headingLevel == 1 {
            foundFirstH1 = true
        }
        return reportWithChildren(node)
    }

    public func visit(thematicBreak node: ThematicBreak) -> String {
        return report(node)
    }

    public func visit(text node: Text) -> String {
        return node.literal ?? ""
    }

    public func visit(softBreak node: SoftBreak) -> String {
        return report(node)
    }

    public func visit(lineBreak node: LineBreak) -> String {
        return report(node)
    }

    public func visit(code node: Code) -> String {
        return report(node)
    }

    public func visit(htmlInline node: HtmlInline) -> String {
        return report(node)
    }

    public func visit(customInline node: CustomInline) -> String {
        return report(node)
    }

    public func visit(emphasis node: Emphasis) -> String {
        return reportWithChildren(node)
    }

    public func visit(strong node: Strong) -> String {
        return reportWithChildren(node)
    }

    public func visit(link node: Link) -> String {
        return reportWithChildren(node)
    }

    public func visit(image node: Image) -> String {
        return reportWithChildren(node)
    }
}
