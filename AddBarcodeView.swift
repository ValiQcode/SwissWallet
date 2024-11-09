import SwiftUI
import CoreData

struct AddBarcodeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @State private var label: String = ""
    @State private var data: String = ""
    @State private var showingLabelHelp = false
    @State private var showingDataHelp = false
    @State private var selectedType = "Barcode"
    let codeTypes = ["Barcode", "QR Code"]

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
                            Text("Enter a descriptive name for this barcode")
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
                            Text(selectedType == "QR Code" ? 
                                "Enter the text or URL for your QR code" :
                                "Enter the 13 digits for your barcode")
                                .padding()
                        }
                    }

                    Picker("Type", selection: $selectedType) {
                        ForEach(codeTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 8)
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
        newBarcode.type = selectedType == "Barcode" ? "ean13" : "qrcode"
        do {
            try viewContext.save()
        } catch {
            print("Error saving barcode: \(error.localizedDescription)")
        }
    }
}
