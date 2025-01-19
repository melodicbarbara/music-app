import SwiftUI
import PDFKit

struct ContentView: View {
    @State private var pdfURL: URL?

    var body: some View {
        VStack {
            if let pdfURL = pdfURL {
                PDFKitView(url: pdfURL)
            } else {
                Text("Fetching PDF...")
                    .onAppear {
                        downloadPDF(from: "http://localhost:3001/pdf/baggage-price_updated-on-25sep-24_ar_en.pdf")
                    }
            }
        }
    }

    func downloadPDF(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("downloaded.pdf")
                do {
                    try data.write(to: tempURL)
                    DispatchQueue.main.async {
                        self.pdfURL = tempURL
                    }
                } catch {
                    print("Error saving file:", error)
                }
            }
        }.resume()
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
