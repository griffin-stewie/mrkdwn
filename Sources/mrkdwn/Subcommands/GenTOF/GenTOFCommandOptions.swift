import Foundation
import ArgumentParser
import Path
import mrkdwnCore
import Markdown

struct GenTOFCommandOptions: ParsableArguments {
        
    @Option(name: .customLong("sort"), help: ArgumentHelp("Sort order", valueName: SortOrder.allCasesDescription))
    var sortOrder: SortOrder = .ascending
    
    @Option(name: .customLong("sort-by"), help: ArgumentHelp("Sort by", valueName: SortBy.allCasesDescription))
    var sortBy: SortBy = .filepath

    @Option(name: .customLong("list-style"), help: ArgumentHelp("Sort by", valueName: MarkdownFile.Style.allCasesDescription))
    var listStyle: MarkdownFile.Style = .unordered

    @Option(help: "Ordered list start numeral")
    var orderedListStartNumeral: UInt = 1

    @Option(help: "Ordered list counting; choices: \(OrderedListCountingBehavior.allCases.map { $0.rawValue }.joined(separator: ", "))")
    var orderedListCounting: OrderedListCountingBehavior = .allSame

    @Option(help: "Unordered list marker; choices: \(MarkupFormatter.Options.UnorderedListMarker.allCases.map { $0.rawValue }.joined(separator: ", "))")
    var unorderedListMarker: String = "-"
    
    @Option(name: .customLong("target-dir"), help: ArgumentHelp("The directory containing markdown files. Only markdown files with the `md` file extension will be processed.", valueName: "Directory Path"))
    var targetDirectory: Path
    
    @Option(name: .customLong("link-dir-level"), help: ArgumentHelp("TOF relative URL depth level. 0 means no directory.", valueName: "level"))
    var linkDirectoryLevel: Int = 0
}

extension GenTOFCommandOptions {
    enum SortOrder: String, ExpressibleByArgument, CaseIterable {
        case ascending = "asc"
        case descending = "desc"
    }
}

extension GenTOFCommandOptions {
    enum SortBy: String, ExpressibleByArgument, CaseIterable {
        case title
        case filepath
    }
}

enum OrderedListCountingBehavior: String, ExpressibleByArgument, CaseIterable {
    /// Use the same numeral for all ordered list items, inferring order.
    case allSame = "all-same"

    /// Literally increment the numeral for each list item in a list.
    case incrementing
}
