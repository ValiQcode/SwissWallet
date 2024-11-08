import SwiftUI
import CoreData

struct AddBarcodeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @State private var label: String = ""
    @State private var data: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Label")) {
                    TextField("Enter label", text: $label)
                }
                Section(header: Text("Data")) {
                    TextField("Enter 12-digit barcode data", text: $data)
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle("Add Barcode")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                addBarcode()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func addBarcode() {
        let newBarcode = Barcode(context: viewContext)
        newBarcode.id = UUID()
        newBarcode.label = label
        newBarcode.data = data
        do {
            try viewContext.save()
        } catch {
            print("Error saving barcode: \(error.localizedDescription)")
        }
    }
}
