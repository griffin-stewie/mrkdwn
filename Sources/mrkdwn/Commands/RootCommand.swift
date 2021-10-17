import Foundation
import ArgumentParser

struct RootCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "mrkdwn",
        abstract: "Support tool for writing Markdown documents.",
        version: "1.2.0",
        subcommands: [GenTOFCommand.self]
    )
}
