import Elephant
import SwiftUI

@available(iOS 13.0, *)
struct SwiftUIExampleView: View {
    var body: some View {
        VStack(spacing: 24) {
            AnimatedSVGView(
                named: "loading-text",
                animationOwner: .css,
                style: .cssFile(name: "loading-text")
            )
            .frame(width: 220, height: 220)

            AnimatedSVGView(named: "image", animationOwner: .svg)
                .frame(width: 220, height: 220)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
