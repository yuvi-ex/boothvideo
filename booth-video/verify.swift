import Foundation
import AVFoundation
import AppKit
let asset=AVURLAsset(url:URL(fileURLWithPath:CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "booth-video/exasol-booth-animated.mp4"))
print("Duration:",CMTimeGetSeconds(asset.duration))
let track=asset.tracks(withMediaType:.video)[0]
print("Dimensions:",track.naturalSize,"FPS:",track.nominalFrameRate)
let reader=try AVAssetReader(asset:asset)
let output=AVAssetReaderTrackOutput(track:track,outputSettings:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA])
reader.add(output);reader.startReading()
var count=0
while let sample=output.copyNextSampleBuffer() {
 if count==840,let buffer=CMSampleBufferGetImageBuffer(sample) {
  let ci=CIImage(cvPixelBuffer:buffer);let ctx=CIContext()
  let cg=ctx.createCGImage(ci,from:ci.extent)!
  let rep=NSBitmapImageRep(cgImage:cg)
  let stem=URL(fileURLWithPath:CommandLine.arguments.count>1 ? CommandLine.arguments[1]:"default").deletingPathExtension().lastPathComponent
  try rep.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"booth-video/\(stem)-check.png"))
 }
 count+=1
}
print("Decoded frames:",count,"Reader status:",reader.status.rawValue,"Error:",String(describing:reader.error))
let expectedFrames=CommandLine.arguments.count>2 ? Int(CommandLine.arguments[2])! : 1440
guard reader.status == .completed && count==expectedFrames else {exit(1)}
