import Foundation
import Dispatch
import ArgumentParser

let queue = DispatchQueue(label: "command_main", qos: .default)
queue.async {
    RootCommand.main()
}

dispatchMain()