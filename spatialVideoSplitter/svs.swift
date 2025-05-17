//
//  svs.swift
//  spatialVideoSplitter
//
//  Created by alarix on 3/2/24.
//  updated 10/04/25
//

import Foundation
import ArgumentParser
import AVFoundation

@main
struct svs: AsyncParsableCommand {
    var progress: Float = 0
    static let configuration = CommandConfiguration(abstract: "\n\n Spatial Video Splitter. Convert MVC-H265 files. \n (c) 2024 Alaric Hamacher")
    @Option(name: [.short, .customLong("input")], help: "A mvc-h265 file to read.")
    var inputFile: String
    @Flag(name: [.short, .customLong("verbose")], help: "output additional comments.") var verbose = false
    @Flag(name: [.short, .customLong("downscale")], help: "downscale the video.") var downscale = false
    @Flag(name: [.short, .customLong("limit")], help: "limit to first 100 frames.") var limit = false
    
    enum CodecType: String, CaseIterable, ExpressibleByArgument {
            case h264, hevc, hevcWithAlpha, proRes422, proRes422LT, proRes422HQ, proRes422Proxy, proRes4444
        }
    @Option(name: [.short, .customLong("codec")],help: "The compression type to use.")
    var codec: CodecType =  svs.CodecType.h264
    
    @Option(name: [.short, .customLong("format")], help: "The preferred file format.", completion: .list(["mp4", "mov"]))
    var format: String = "mp4"
    
    @Option(name: [.short, .customLong("suffix")], help: "suffix added to file.", completion: .list(["_SBS"]))
        var suffix: String = "_SBS"
    
    func getCodectype (codec: CodecType) -> AVVideoCodecType {
        switch codec {
        case svs.CodecType.h264:
            return AVVideoCodecType.h264
        case svs.CodecType.hevc:
            return AVVideoCodecType.hevc
        case svs.CodecType.hevcWithAlpha:
            return AVVideoCodecType.hevcWithAlpha
        case svs.CodecType.proRes422:
            return AVVideoCodecType.proRes422
        case svs.CodecType.proRes422LT:
            return AVVideoCodecType.proRes422LT
        case svs.CodecType.proRes422HQ:
            return AVVideoCodecType.proRes422HQ
        case svs.CodecType.proRes422Proxy:
            return AVVideoCodecType.proRes422Proxy
        case svs.CodecType.proRes4444:
            return AVVideoCodecType.proRes4444
            default:
            return AVVideoCodecType.h264
            }
    }
    
    func getFiletypefromString (filetype: String) -> AVFileType {
        switch filetype {
            case "mp4":
            return AVFileType.mp4
            case "mov":
            return AVFileType.mov
            default:
            return AVFileType.mp4
            }
    }
    
    mutating func run() async throws {
        
        let inputVideo = URL(fileURLWithPath: inputFile)
        
        let fileName = inputVideo.deletingPathExtension().lastPathComponent + suffix + "." + format
        let outputVideo = inputVideo.deletingLastPathComponent().appendingPathComponent(fileName)
        
        let converter = VideoConvertor()
        
        if verbose {print("\n\n Spatial Video Splitter. Convert MVC-H265 files. \n (c) 2025 Alaric Hamacher\n")}
        
        if FileManager.default.fileExists(atPath: outputVideo.path(percentEncoded: true)) {
            try FileManager.default.removeItem(at: outputVideo)
        }
        
        try await converter.convertVideo(inputFile: inputVideo, outputFile: outputVideo, codec: getCodectype(codec: codec) , fformat: getFiletypefromString(filetype: format), verbose: verbose, downscale: downscale, cut: limit )
        
        if verbose {print("\n video encoded to \(outputVideo)")}
    }
}
