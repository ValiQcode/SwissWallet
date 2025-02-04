import SwiftUI

struct BarcodeDetailView: View {
    let barcode: Barcode
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    private func deleteBarcode() {
        managedObjectContext.delete(barcode)
        try? managedObjectContext.save()
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        VStack {
            Text(barcode.label ?? "No Label")
                .font(.largeTitle)
                .padding()

            switch barcode.type {
            case "ean13":
                if let barcodeImage = drawEAN13Barcode(from: barcode.data ?? "") {
                    Image(uiImage: barcodeImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding()
                }
            case "code128":
                if let barcodeImage = drawCode128Barcode(from: barcode.data ?? "") {
                    Image(uiImage: barcodeImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding()
                }
            default: // QR Code
                QRCodeGenerator.draw(barcode.data ?? "")
                    .frame(width: 200, height: 200, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
            }

            Button("Delete", role: .destructive) {
                deleteBarcode()
            }
            .padding()

            Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}
