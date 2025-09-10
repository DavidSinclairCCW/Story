import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct SupportView: View {
    let phoneNumber = "6197336995"

    var body: some View {
        VStack(spacing: 20) {
            Text("Need Help?")
                .font(.title)
            Button(action: callSupport) {
                Label("Call Support", systemImage: "phone.fill")
            }
            .buttonStyle(PillButtonStyle())
            Spacer()
        }
        .padding()
        .background(Theme.background)
        .navigationTitle("Support")
        .tint(Theme.accent)
    }

    private func callSupport() {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
    }
}
