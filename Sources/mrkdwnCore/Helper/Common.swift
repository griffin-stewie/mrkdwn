import Foundation
import ArgumentParser

extension Foundation.URL: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(string: argument)
    }
}

public extension String {
    /// NSString へのキャストを簡潔に書くためのショートハンド
    var ns: NSString {
        return self as NSString
    }
}

public struct StandardError: TextOutputStream {
    public mutating func write(_ string: String) {
        for byte in string.utf8 { putc(numericCast(byte), stderr) }
    }
}
