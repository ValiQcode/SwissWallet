import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator {
    static func draw(_ string: String) -> Image {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(string.data(using: .utf8), forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            let scale = CGAffineTransform(scaleX: 5, y: 5)
            let scaledImage = outputImage.transformed(by: scale)
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return Image(cgImage, scale: 1.0, label: Text("QR Code"))
            }
        }
        
        return Image(systemName: "xmark.circle")
    }
} 
