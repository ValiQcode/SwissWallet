import SwiftUI
import CoreData

struct AddBarcodeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @State private var label: String = ""
    @State private var data: String = ""
    @State private var showingLabelHelp = false
    @State private var showingDataHelp = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        TextField("Label", text: $label)
                        Button {
                            showingLabelHelp.toggle()
                        } label: {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.gray)
                        }
                        .popover(isPresented: $showingLabelHelp) {
                            Text("Enter to label to remember the barcode, such as the store name.")
                                .padding()
                        }
                    }

                    HStack {
                        TextField("Data", text: $data)
                        Button {
                            showingDataHelp.toggle()
                        } label: {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.gray)
                        }
                        .popover(isPresented: $showingDataHelp) {
                            Text("Enter the 13-digit barcode.")
                                .padding()
                        }
                    }
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
