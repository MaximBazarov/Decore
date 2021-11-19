import SwiftUI
import Decore

struct CounterView: View {

    let counterIndex: Int

    var body: some View {
        HStack {
            FancyButton(title: "+", tint: .red, foreground: .black)  {}
            Spacer()
            Text("\(counterIndex)")
            Spacer()
            FancyButton(title: "-", tint: .blue, foreground: .black)  {}
        }
        .padding()
        .background(Material.thinMaterial)
        .background(
            Color.blue.opacity(0.3)
        )
        .cornerRadius(8)
    }
}


struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        return CounterView(counterIndex: 1)
    }
}
