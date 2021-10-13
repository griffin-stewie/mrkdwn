import Foundation
import Path
import Down

public enum Mrkdwn {
    public static func markdownFileURLs(from dir: Path, level: Int) throws -> [URL] {
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

            let combined = URL(fileURLWithPath: file, relativeTo: dir.url)

            return combined.relativeURL(depthFromBottom: level)
        }

        return files
    }
}


private extension URL {
    func relativeURL(depthFromBottom depth: Int) -> URL {
        let compos = self.pathComponents

        var loopCount = 0
        var partition = loopCount
        for (i, item) in compos.enumerated().reversed() {
            print(loopCount, i, item)
            if loopCount == depth {
                partition = i
                break
            }
            
            loopCount += 1
        }
        
        let head = compos[..<partition]
        let tail = compos[partition...]
        let base = URL.from(pathComponents: Array(head))
        return URL(fileURLWithPath: tail.joined(separator: "/"), relativeTo: base)
    }
    
    static func from(pathComponents: [String]) -> URL {
        let base = URL(fileURLWithPath: pathComponents[0])
        return base.appendingPathComponents(components: Array(pathComponents[1...]))
    }
       
    func appendingPathComponents(components: [String]) -> URL {
        var temp = self
        for c in components {
            temp.appendPathComponent(c)
        }
        return temp
    }
}
