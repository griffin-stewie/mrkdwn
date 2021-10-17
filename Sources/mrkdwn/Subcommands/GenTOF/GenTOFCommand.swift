import Foundation
import ArgumentParser
import Markdown
import mrkdwnCore

struct GenTOFCommand: ParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "tof",
        abstract: "Print Table Of Files list to STDIN"
    )

    @OptionGroup()
    var options: GenTOFCommandOptions

    func run() throws {
        try run(options: options)
        throw ExitCode.success
    }
}

extension GenTOFCommand {
    private func run(options: GenTOFCommandOptions) throws {
        let urls = try Mrkdwn.markdownFileURLs(from: options.targetDirectory, level: options.linkDirectoryLevel)

        #if DEBUG
        urls.forEach { url in
            print(url.description)
        }
        #endif
        
        let files = try urls.map(MarkdownFile.init(url:))
            .sorted(by: sort)

        guard let unorderedListMarker = MarkupFormatter.Options.UnorderedListMarker(argument: options.unorderedListMarker) else {
            throw ArgumentParser.ValidationError("The value '\(self.options.unorderedListMarker)' is invalid for '--unordered-list-marker'")
        }

        let orderedListNumerals: MarkupFormatter.Options.OrderedListNumerals
        switch options.orderedListCounting {
        case .allSame:
            orderedListNumerals = .allSame(options.orderedListStartNumeral)
        case .incrementing:
            orderedListNumerals = .incrementing(start: options.orderedListStartNumeral)
        }

        let formatterOptions = MarkupFormatter.Options(unorderedListMarker: unorderedListMarker,
                                                       orderedListNumerals: orderedListNumerals)

        let lists = files.map { $0.listItem() }
        let doc = options.listStyle.document(with: lists)
        let formatted = doc.format(options: formatterOptions)
        print(formatted)
    }
    
    private func sort(lhs: MarkdownFile, rhs: MarkdownFile) -> Bool {
        let lhsSortTarget: String
        let rhsSortTarget: String
        
        switch options.sortBy {
        case .title:
            lhsSortTarget = lhs.title
            rhsSortTarget = rhs.title
        case .filepath:
            lhsSortTarget = lhs.url.relativePath
            rhsSortTarget = rhs.url.relativePath
        }
        
        switch options.sortOrder {
        case .ascending:
            return lhsSortTarget < rhsSortTarget
        case .descending:
            return lhsSortTarget > rhsSortTarget
        }
    }
}

extension MarkupFormatter.Options.UnorderedListMarker: ExpressibleByArgument {}
