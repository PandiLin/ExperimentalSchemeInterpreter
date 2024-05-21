////
////  FFTCalculations.swift
////  Toe
////
////  Created by apple on 2023/8/5.
////
//
//import Foundation
//import Accelerate
//import AVFoundation
//
//
//
//func fft(audioBuffer: AVAudioPCMBuffer) -> [Float] {
//    let frameCount = audioBuffer.frameLength
//    let log2n = UInt(round(log2(Double(frameCount))))
//    let bufferSizePadded = Int(1 << log2n)
//    
//    guard let floatData = audioBuffer.floatChannelData else {
//        fatalError("Failed to get float data from buffer")
//    }
//    
//    let realp = UnsafeMutablePointer<Float>.allocate(capacity: bufferSizePadded/2)
//    let imagp = UnsafeMutablePointer<Float>.allocate(capacity: bufferSizePadded/2)
//    var output = DSPSplitComplex(realp: realp, imagp: imagp)
//
//    floatData[0].withMemoryRebound(to: DSPComplex.self, capacity: Int(frameCount)) { (x: UnsafeMutablePointer<DSPComplex>) -> Void in
//        vDSP_ctoz(x, 2, &output, 1, vDSP_Length(bufferSizePadded/2))
//    }
//
//    let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(FFT_RADIX2))
//    vDSP_fft_zip(fftSetup!, &output, 1, log2n, FFTDirection(FFT_FORWARD))
//    
//    var magnitudes = [Float](repeating: 0.0, count: Int(frameCount/2))
//    vDSP_zvmags(&output, 1, &magnitudes, 1, vDSP_Length(frameCount/2))
//
//    var normalizedMagnitudes = [Float](repeating: 0.0, count: Int(frameCount/2))
//    let sqrtMagnitudes = magnitudes.map { sqrt($0) }
//    vDSP_vsmul(sqrtMagnitudes, 1, [2.0], &normalizedMagnitudes, 1, vDSP_Length(sqrtMagnitudes.count))
//    
//    vDSP_destroy_fftsetup(fftSetup)
//    
//    realp.deallocate()
//    imagp.deallocate()
//    
//    return normalizedMagnitudes
//}
//
//struct FFTSetupForBinCount {
//    /// Initialize FFTSetupForBinCount with a valid number of fft bins
//    ///
//    /// - Parameters:
//    ///   - binCount: enum representing a valid 2^n result where n is an integer
//    init(binCount: FFTValidBinCount) {
//        log2n = UInt(log2(binCount.rawValue))
//        self.binCount = Int(binCount.rawValue)
//    }
//
//    /// used to set log2n in fft
//    let log2n: UInt
//
//    /// number of returned fft bins
//    var binCount: Int
//}
//
// func determineLog2n(frameCount: UInt32, fftSetupForBinCount: FFTSetupForBinCount?) -> UInt {
//    if let setup = fftSetupForBinCount {
//        if frameCount >= setup.binCount { // guard against more bins than buffer size
//            return UInt(setup.log2n + 1) // +1 because we divide bufferSizePOT by two
//        }
//    }
//    // default to frameCount (for bad input or no bin count argument)
//    return UInt(round(log2(Double(frameCount))))
//}
//
//
//
// func performFFT(buffer: AVAudioPCMBuffer,
//                       isNormalized: Bool = true,
//                       zeroPaddingFactor: UInt32 = 0,
//                       fftSetupForBinCount: FFTSetupForBinCount? = nil) -> [Float] {
//    let frameCount = buffer.frameLength + buffer.frameLength * zeroPaddingFactor
//    let log2n = determineLog2n(frameCount: frameCount, fftSetupForBinCount: fftSetupForBinCount)
//    let bufferSizePOT = Int(1 << log2n) // 1 << n = 2^n
//    let binCount = bufferSizePOT / 2
//
//    let fftSetup = vDSP_create_fftsetup(log2n, Int32(kFFTRadix2))
//
//    var output = DSPSplitComplex(repeating: 0, count: binCount)
//    defer {
//        output.deallocate()
//    }
//
//    let windowSize = Int(buffer.frameLength)
//    var transferBuffer = [Float](repeating: 0, count: bufferSizePOT)
//    var window = [Float](repeating: 0, count: windowSize)
//
//    // Hann windowing to reduce the frequency leakage
//    vDSP_hann_window(&window, vDSP_Length(windowSize), Int32(vDSP_HANN_NORM))
//    vDSP_vmul((buffer.floatChannelData?.pointee)!, 1, window,
//              1, &transferBuffer, 1, vDSP_Length(windowSize))
//
//    // Transforming the [Float] buffer into a UnsafePointer<Float> object for the vDSP_ctoz method
//    // And then pack the input into the complex buffer (output)
//    transferBuffer.withUnsafeBufferPointer { pointer in
//        pointer.baseAddress!.withMemoryRebound(to: DSPComplex.self,
//                                               capacity: transferBuffer.count) {
//            vDSP_ctoz($0, 2, &output, 1, vDSP_Length(binCount))
//        }
//    }
//
//    // Perform the FFT
//    vDSP_fft_zrip(fftSetup!, &output, 1, log2n, FFTDirection(FFT_FORWARD))
//
//    // Parseval's theorem - Scale with respect to the number of bins
//    var scaledOutput = DSPSplitComplex(repeating: 0, count: binCount)
//    var scaleMultiplier = DSPSplitComplex(repeatingReal: 1.0 / Float(binCount), repeatingImag: 0, count: 1)
//    defer {
//        scaledOutput.deallocate()
//        scaleMultiplier.deallocate()
//    }
//    vDSP_zvzsml(&output,
//                1,
//                &scaleMultiplier,
//                &scaledOutput,
//                1,
//                vDSP_Length(binCount))
//
//    var magnitudes = [Float](repeating: 0.0, count: binCount)
//    vDSP_zvmags(&scaledOutput, 1, &magnitudes, 1, vDSP_Length(binCount))
//    vDSP_destroy_fftsetup(fftSetup)
//
//    if !isNormalized {
//        return magnitudes
//    }
//
//    // normalize according to the momentary maximum value of the fft output bins
//    var normalizationMultiplier: [Float] = [1.0 / (magnitudes.max() ?? 1.0)]
//    var normalizedMagnitudes = [Float](repeating: 0.0, count: binCount)
//    vDSP_vsmul(&magnitudes,
//               1,
//               &normalizationMultiplier,
//               &normalizedMagnitudes,
//               1,
//               vDSP_Length(binCount))
//    return normalizedMagnitudes
//}
