#!/usr/bin/swift

import Foundation

final class StandardErrorOutputStream: TextOutputStream {
    func write(_ string: String) {
        FileHandle.standardError.write(Data(string.utf8))
    }
}

func arguments() -> [String] {
    let idx = ProcessInfo.processInfo.arguments.firstIndex(of: "--")!
    return Array(ProcessInfo.processInfo.arguments.dropFirst(idx.advanced(by: 1)))
}

func exitAsFailure(_ message: String) -> Never {
    var stderr = StandardErrorOutputStream()
    print("[Error]: \(message)", to: &stderr)
    exit(EXIT_FAILURE)
}

func main(args: [String]) throws -> Void {

    let fs = FileManager.default

    print(args)

    guard args.count == 2 else {
        exitAsFailure("Pass xcsheme file path as first arguments, and command line arguments text file path as second arguments")
    }

    guard let xcshemePath = args.first, xcshemePath.hasSuffix("xcscheme") else {
        exitAsFailure("Pass xcsheme file path as first argument")
    }

    guard let commandLineArgsFilePath = args.last else {
        exitAsFailure("Pass command line arguments text file path as second argument")
    }

    let xcshemeURL = URL(fileURLWithPath: xcshemePath)
    print(xcshemeURL)
    guard fs.fileExists(atPath: xcshemeURL.path) else {
        exitAsFailure("xcsheme file does not exists")
    }

    let commandLineArgsFileURL = URL(fileURLWithPath: commandLineArgsFilePath)
    print(commandLineArgsFileURL)
    guard fs.fileExists(atPath: commandLineArgsFileURL.path) else {
        exitAsFailure("args file does not exists")
    }


    let commandLineArgsString = try String(contentsOf: commandLineArgsFileURL)
    let commandLineArgsElem = try XMLElement.init(xmlString: commandLineArgsString)

    let doc = try XMLDocument(contentsOf: xcshemeURL, options: [.nodePrettyPrint])

    try doc.xmlData(options: [.nodePrettyPrint]).write(to: xcshemeURL)

    if let node = try doc.nodes(forXPath: "/Scheme/LaunchAction/CommandLineArguments").first {
        print(node)
        node.detach()
    }

    if let node = try doc.nodes(forXPath: "/Scheme/LaunchAction").first as? XMLElement {
        print(node)
        node.addChild(commandLineArgsElem)
    }

//    let destination = xcshemeURL.deletingLastPathComponent().appendingPathComponent("hoge.xcsheme")
    let destination = xcshemeURL
    try doc.xmlData(options: [.nodePrettyPrint, .documentTidyXML]).write(to: destination)
}


try main(args: arguments())
