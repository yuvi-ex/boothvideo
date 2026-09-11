import Foundation
import AVFoundation

// Concatenates existing video-only MP4s without altering the source files.
let args=Array(CommandLine.arguments.dropFirst())
guard args.count>=2 else {fatalError("Usage: assemble.swift output.mp4 input1.mp4 input2.mp4 ...")}
let composition=AVMutableComposition()
let track=composition.addMutableTrack(withMediaType:.video,preferredTrackID:kCMPersistentTrackID_Invalid)!
var cursor=CMTime.zero
for path in args.dropFirst() {
 let asset=AVURLAsset(url:URL(fileURLWithPath:path))
 let src=asset.tracks(withMediaType:.video)[0]
 try track.insertTimeRange(CMTimeRange(start:.zero,duration:asset.duration),of:src,at:cursor)
 print("Append",path,"at",CMTimeGetSeconds(cursor))
 cursor=CMTimeAdd(cursor,asset.duration)
}
let exporter=AVAssetExportSession(asset:composition,presetName:AVAssetExportPresetPassthrough)!
exporter.outputURL=URL(fileURLWithPath:args[0]);exporter.outputFileType = .mp4
exporter.shouldOptimizeForNetworkUse=true
let semaphore=DispatchSemaphore(value:0)
exporter.exportAsynchronously {semaphore.signal()};semaphore.wait()
guard exporter.status == .completed else {fatalError("Export failed: \(String(describing:exporter.error))")}
print("DONE",args[0],"Duration",CMTimeGetSeconds(cursor))
