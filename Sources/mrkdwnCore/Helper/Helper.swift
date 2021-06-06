import Foundation
import Path
import Down

public enum Mrkdwn {
    public static func markdownFileURLs(from dir: Path) throws -> [URL] {
        let fs = FileManager.default
        guard let dirEnum = fs.enumerator(atPath: dir.string) else {
            throw "The directory does not exist."
        }

        let files = dirEnum.compactMap { (file) -> URL? in
            guard let file = file as? String else {
                return nil
            }

            guard file.hasSuffix(".md") else {
                return nil
            }


            return URL(fileURLWithPath: file, relativeTo: dir.url)
        }

        return files
    }
}
