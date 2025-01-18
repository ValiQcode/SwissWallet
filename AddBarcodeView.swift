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
    let codeTypes = ["Barcode", "QR Code", "Code 128"]

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
                            Text(getHelpText(for: selectedType))
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

    private func getHelpText(for type: String) -> String {
        switch type {
            case "QR Code": return "Enter the text or URL for your QR code"
            case "Barcode": return "Enter the 13 digits for your barcode"
            case "Code 128": return "Enter any combination of letters, numbers, or special characters"
            default: return ""
        }
    }

    private func addBarcode() {
        let newBarcode = Barcode(context: viewContext)
        newBarcode.id = UUID()
        newBarcode.label = label
        newBarcode.data = data
        newBarcode.type = {
            switch selectedType {
                case "Barcode": return "ean13"
                case "QR Code": return "qrcode"
                case "Code 128": return "code128"
                default: return "ean13"
            }
        }()
        do {
            try viewContext.save()
        } catch {
            print("Error saving barcode: \(error.localizedDescription)")
        }
    }
}
