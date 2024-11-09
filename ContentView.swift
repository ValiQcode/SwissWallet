import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Barcode.label, ascending: true)],
        animation: .default)
    private var barcodes: FetchedResults<Barcode>

    @State private var showAddBarcodeView = false
    @State private var selectedBarcode: Barcode? = nil
    @State private var showingLegalInfo = false

    var body: some View {
        NavigationView {
            List {
                ForEach(barcodes) { barcode in
                    Button(action: {
                        selectedBarcode = barcode
                    }) {
                        Text(barcode.label ?? "Unknown Label")
                    }
                }
                .onDelete(perform: deleteBarcodes)
            }
            .navigationBarTitle("Swiss Wallet")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddBarcodeView = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddBarcodeView) {
                AddBarcodeView()
            }
            .sheet(item: $selectedBarcode) { barcode in
                BarcodeDetailView(barcode: barcode)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                showingLegalInfo.toggle()
            } label: {
                Image(systemName: "questionmark.circle")
                    .foregroundColor(.gray.opacity(0.6))
                    .font(.footnote)
            }
            .popover(isPresented: $showingLegalInfo) {
                Text("© 2024 ValiQ Security GmbH")
                    .padding()
                    .font(.footnote)
            }
            .padding(8)
        }
    }

    private func deleteBarcodes(at offsets: IndexSet) {
        offsets.map { barcodes[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting barcode: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
