import SwiftUI

struct ContentView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)
            AccountView()
                .tabItem { Label("Account", systemImage: "person.crop.circle") }
                .tag(1)
            SupportView()
                .tabItem { Label("Support", systemImage: "phone") }
                .tag(2)
        }
        .background(Theme.background)
        .tint(Theme.accent)
        .animation(.easeInOut, value: selection)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
