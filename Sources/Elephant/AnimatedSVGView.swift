import SwiftUI

@available(iOS 14.0, *)
public struct AnimatedSVGView: UIViewRepresentable {
    private let named: String?
    private let fileURL: URL?
    private let animationOwner: AnimationOwner
    private let style: SVGLoader.Style?
    private let bundle: Bundle
    private let controller: AnimatedSVGViewController?

    public init(
        named: String,
        animationOwner: AnimationOwner,
        style: SVGLoader.Style? = .default,
        bundle: Bundle = .main,
        controller: AnimatedSVGViewController? = nil
    ) {
        self.named = named
        self.fileURL = nil
        self.animationOwner = animationOwner
        self.style = style
        self.bundle = bundle
        self.controller = controller
    }

    public init(
        fileURL: URL,
        animationOwner: AnimationOwner,
        style: SVGLoader.Style? = .default,
        controller: AnimatedSVGViewController? = nil
    ) {
        self.named = nil
        self.fileURL = fileURL
        self.animationOwner = animationOwner
        self.style = style
        self.bundle = .main
        self.controller = controller
    }

    public func makeUIView(context: Context) -> UIView {
        makeSVGView() ?? UIView()
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}

    private func makeSVGView() -> SVGView? {
        let svgView: SVGView?

        if let named {
            svgView = SVGView(named: named, animationOwner: animationOwner, style: style, bundle: bundle)
        } else if let fileURL {
            svgView = SVGView(fileURL: fileURL, animationOwner: animationOwner, style: style)
        } else {
            svgView = nil
        }

        if let svgView {
            controller?.attach(svgView)
        }

        return svgView
    }
}
