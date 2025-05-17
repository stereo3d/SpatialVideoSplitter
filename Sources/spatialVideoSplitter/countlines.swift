//
//  main.swift
//  spatialVideoSplitter
//
//  Created by alarix on 3/1/24.
//
import ArgumentParser
import Foundation

// @main
@available(macOS 12, *)
struct CountLines: AsyncParsableCommand {
    @Argument(
        help: "A file to count lines in. If omitted, counts the lines of stdin.",
        completion: .file(), transform: URL.init(fileURLWithPath:))
    var inputFile: URL? = nil
    
    @Argument(
        help: "A file to count lines in. If omitted, counts the lines of stdin.",
        completion: .file(), transform: URL.init(fileURLWithPath:))
    var outputFile: URL? = nil
    
    @Option(help: "Only count lines with this prefix.")
    var prefix: String? = nil
    
    @Flag(help: "Include extra information in the output.")
    var verbose = false
}

@available(macOS 12, *)
extension CountLines {
    var fileHandle: FileHandle {
        get throws {
            guard let inputFile = inputFile else {
                return .standardInput
            }
            return try FileHandle(forReadingFrom: inputFile)
        }
    }
    
    func printCount(_ count: Int) {
        guard verbose else {
            print(count)
            return
        }
        
        if let filename = inputFile?.lastPathComponent {
            print("Lines in '\(filename)'", terminator: "")
        } else {
            print("Lines from stdin", terminator: "")
        }
        
        if let prefix = prefix {
            print(", prefixed by '\(prefix)'", terminator: "")
        }
        
        print(": \(count)")
    }
    
    mutating func run() async throws {
        let countAllLines = prefix == nil
        let lineCount = try await fileHandle.bytes.lines.reduce(0) { count, line in
            if countAllLines || line.starts(with: prefix!) {
                return count + 1
            } else {
                return count
            }
        }
        
        printCount(lineCount)
    }
}
