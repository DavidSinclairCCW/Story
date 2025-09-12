import SwiftUI

struct RollingNumberView: View {
    var value: Int
    private let height: CGFloat = 30
    @State private var previous: Int
    @State private var offset: CGFloat = 0

    init(value: Int) {
        self.value = value
        _previous = State(initialValue: value)
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("\(previous)")
                .frame(height: height)
            Text("\(value)")
                .frame(height: height)
        }
        .font(.title2.monospacedDigit())
        .offset(y: offset)
        .clipped()
        .onChange(of: value) { newValue in
            withAnimation(.easeInOut(duration: 0.4)) {
                offset = -height
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                previous = newValue
                offset = 0
            }
        }
    }
}
