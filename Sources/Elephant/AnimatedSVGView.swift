import SwiftUI

@available(iOS 13.0, *)
public struct AnimatedSVGView: UIViewRepresentable {
    private let named: String?
    private let fileURL: URL?
    private let animationOwner: AnimationOwner
    private let style: SVGLoader.Style?
    private let bundle: Bundle

    public init(
        named: String,
        animationOwner: AnimationOwner,
        style: SVGLoader.Style? = .default,
        bundle: Bundle = .main
    ) {
        self.named = named
        self.fileURL = nil
        self.animationOwner = animationOwner
        self.style = style
        self.bundle = bundle
    }

    public init(
        fileURL: URL,
        animationOwner: AnimationOwner,
        style: SVGLoader.Style? = .default
    ) {
        self.named = nil
        self.fileURL = fileURL
        self.animationOwner = animationOwner
        self.style = style
        self.bundle = .main
    }

    public func makeUIView(context: Context) -> UIView {
        makeSVGView() ?? UIView()
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}

    private func makeSVGView() -> SVGView? {
        if let named {
            return SVGView(named: named, animationOwner: animationOwner, style: style, bundle: bundle)
        }

        if let fileURL {
            return SVGView(fileURL: fileURL, animationOwner: animationOwner, style: style)
        }

        return nil
    }
}
