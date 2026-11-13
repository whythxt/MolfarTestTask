import SwiftUI

struct ContentView: View {
    @State private var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Text("MolfarTestTask")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
