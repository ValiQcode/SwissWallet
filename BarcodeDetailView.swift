import SwiftUI

struct BarcodeDetailView: View {
    let barcode: Barcode
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text(barcode.label ?? "No Label")
                .font(.largeTitle)
                .padding()

            if let codeImage = drawEAN13Barcode(from: barcode.data ?? "") {
                Image(uiImage: codeImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .padding()
            } else {
                Text("Invalid data or type")
                    .foregroundColor(.red)
            }

            Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}
