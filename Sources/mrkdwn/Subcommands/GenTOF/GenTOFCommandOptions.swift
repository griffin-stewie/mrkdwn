import Foundation
import ArgumentParser
import Path
import mrkdwnCore

struct GenTOFCommandOptions: ParsableArguments {
        
    @Option(name: .customLong("sort"), help: ArgumentHelp("Sort order", valueName: SortOrder.allCasesDescription))
    var sortOrder: SortOrder = .ascending
    
    @Option(name: .customLong("sort-by"), help: ArgumentHelp("Sort by", valueName: SortBy.allCasesDescription))
    var sortBy: SortBy = .filepath

    @Option(name: .customLong("list-style"), help: ArgumentHelp("Sort by", valueName: MarkdownFile.Style.allCasesDescription))
    var listStyle: MarkdownFile.Style = .unordered
    
    @Option(name: .customLong("target-dir"), help: ArgumentHelp("The directory containing markdown files. Only markdown files with the `md` file extension will be processed.", valueName: "Directory Path"))
    var targetDirectory: Path
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
