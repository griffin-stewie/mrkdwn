import Foundation
import ArgumentParser
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
        
        try files.forEach { file in
            let str = try file.link(style: options.listStyle)
            print(str)
        }
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
