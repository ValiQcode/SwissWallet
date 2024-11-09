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

            if barcode.type == "ean13" {
                if let barcodeImage = drawEAN13Barcode(from: barcode.data ?? "") {
                    Image(uiImage: barcodeImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding()
                }
            } else {
                QRCodeGenerator.draw(barcode.data ?? "")
                    .frame(width: 200, height: 200)
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
