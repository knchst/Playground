import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Turtle Rock")
                .font(.title)
            Text("Joshua Tree National Park")
                .font(.subheadline)
        }
    }
}

PlaygroundPage.current.liveView = UIHostingController(rootView: ContentView())

