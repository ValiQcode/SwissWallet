import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator {
    static func draw(_ string: String) -> some View {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(string.data(using: .utf8), forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            let scale = CGAffineTransform(scaleX: 6, y: 6)
            let scaledImage = outputImage.transformed(by: scale)
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return Image(cgImage, scale: 1.0, label: Text("QR Code"))
                    .interpolation(.none)
                    .fixedSize()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        
        return Image(systemName: "xmark.circle")
            .foregroundColor(.red)
    }
} 