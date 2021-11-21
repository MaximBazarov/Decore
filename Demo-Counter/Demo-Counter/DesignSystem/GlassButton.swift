
import SwiftUI

struct FancyButton: View {
    var title = ""
    var tint: Color = .accentColor
    var foreground: Color = .white

    var callback: (() -> Void)? = nil

    @GestureState private var longPress = false

    var body: some View {
        Button(title) { callback?() }
        .tint(foreground)
        .padding()
        .frame(minWidth: 64, minHeight: 64)
        .background(
            ZStack {
                angularGradient
                LinearGradient(
                    gradient: Gradient(
                        colors: [ tint, tint.opacity(0.7)]
                    ),
                    startPoint: .top,
                    endPoint: .bottom)
                    .cornerRadius(20)
                    .blendMode(.lighten)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.linearGradient(
                    colors: [
                        Color.white.opacity(0.4),
                        Color.white.opacity(0.2),
                        Color.black.opacity(0.2)
                    ],
                    startPoint: .top,
                    endPoint: .bottom), lineWidth: 2)
                .blendMode(.overlay)
                .shadow(color: Color("P80-2"), radius: 18, x: 0, y: 0)
        )
        .background(angularGradient)
        .scaleEffect(longPress ? 1.25 : 1)
        .gesture(
            LongPressGesture(minimumDuration: 0.1)
                .updating($longPress) { currentState, gestureState, transaction in
                    gestureState = currentState
                    transaction.animation = .spring(
                        response: 0.4,
                        dampingFraction: 0.6)

                }
                .onEnded { finished in
                    if finished { callback?() }
                }
        )

    }

    var angularGradient: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.clear)
            .overlay(AngularGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(#colorLiteral(red: 0, green: 0.5199999809, blue: 1, alpha: 1)), location: 0.0),
                    .init(color: Color(#colorLiteral(red: 0.2156862745, green: 1, blue: 0.8588235294, alpha: 1)), location: 0.4),
                    .init(color: Color(#colorLiteral(red: 1, green: 0.4196078431, blue: 0.4196078431, alpha: 1)), location: 0.5),
                    .init(color: Color(#colorLiteral(red: 1, green: 0.1843137255, blue: 0.6745098039, alpha: 1)), location: 0.8)]),
                center: .center
            ))
            .padding(6)
            .blur(radius: 30)
            .opacity(0.8)
    }
}

struct FancyButton_Previews: PreviewProvider {
    static var previews: some View {
        FancyButton(title: "+")
    }
}
