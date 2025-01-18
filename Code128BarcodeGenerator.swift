import UIKit
import CoreImage

func drawCode128Barcode(from code: String) -> UIImage? {
    guard let data = code.data(using: .ascii) else { return nil }
    
    let filter = CIFilter(name: "CICode128BarcodeGenerator")
    filter?.setValue(data, forKey: "inputMessage")
    filter?.setValue(10.0, forKey: "inputQuietSpace")
    
    guard let outputImage = filter?.outputImage else { return nil }
    
    // Increase the horizontal scaling to 45
    let transform = CGAffineTransform(scaleX: 80, y: 100)
    let scaledImage = outputImage.transformed(by: transform)
    
    // Convert CIImage to UIImage
    let context = CIContext()
    guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
    
    return UIImage(cgImage: cgImage)
} 