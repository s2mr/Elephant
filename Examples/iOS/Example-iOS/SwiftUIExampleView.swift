import Elephant
import SwiftUI

@available(iOS 14.0, *)
struct SwiftUIExampleView: View {
    @StateObject private var cssController = AnimatedSVGViewController()
    @StateObject private var svgController = AnimatedSVGViewController()

    var body: some View {
        VStack(spacing: 24) {
            AnimatedSVGView(
                named: "loading-text",
                animationOwner: .css,
                style: .cssFile(name: "loading-text"),
                controller: cssController
            )
            .frame(width: 220, height: 220)

            AnimatedSVGView(
                named: "image",
                animationOwner: .svg,
                controller: svgController
            )
                .frame(width: 220, height: 220)

            HStack(spacing: 16) {
                Button("Play", action: startAnimation)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 120, height: 44)
                    .background(Color.blue)
                    .cornerRadius(8)

                Button("Pause", action: stopAnimation)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(width: 120, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    private func startAnimation() {
        cssController.startAnimation()
        svgController.startAnimation()
    }

    private func stopAnimation() {
        cssController.stopAnimation()
        svgController.stopAnimation()
    }
}
