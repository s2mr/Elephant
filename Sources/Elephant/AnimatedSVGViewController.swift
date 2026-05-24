import Combine

@available(iOS 14.0, *)
public final class AnimatedSVGViewController: ObservableObject {
    private weak var svgView: SVGView?

    public init() {}

    public func startAnimation(result: ((Error?) -> Void)? = nil) {
        svgView?.startAnimation(result: result)
    }

    public func stopAnimation(result: ((Error?) -> Void)? = nil) {
        svgView?.stopAnimation(result: result)
    }

    public func isAnimate(result: @escaping (Bool?, Error?) -> Void) {
        svgView?.isAnimate(result: result)
    }

    func attach(_ svgView: SVGView) {
        self.svgView = svgView
    }
}
