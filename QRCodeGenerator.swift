import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator {
    static func draw(_ string: String) -> some View {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(string.data(using: .utf8), forKey: "inputMessage")
        
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return Image(cgImage, scale: 1.0, label: Text("QR Code"))
                .interpolation(.none)
        }
        
        return Image(systemName: "xmark.circle") // Fallback for error cases
            .foregroundColor(.red)
    }
} 