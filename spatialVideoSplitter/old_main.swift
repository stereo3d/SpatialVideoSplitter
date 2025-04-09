//
//  main.swift
//  spatialVideoSplitter
//
//  Created by alarix on 3/1/24.
//
import Foundation


guard CommandLine.arguments.count > 1 else { fatalError("USAGE: \(CommandLine.arguments[0]) inputVideoPath") }
let inputVideo = URL(fileURLWithPath: CommandLine.arguments[1])

let fileName = inputVideo.deletingPathExtension().lastPathComponent + "_SBS.mov"
let outputVideo = inputVideo.deletingLastPathComponent().appendingPathComponent(fileName)

let converter = VideoConvertor()

if FileManager.default.fileExists(atPath: outputVideo.path(percentEncoded: true)) {
    try FileManager.default.removeItem(at: outputVideo)
}

try await converter.convertVideo(inputFile: inputVideo, outputFile: outputVideo)

print("\n video encoded to \(outputVideo)")
