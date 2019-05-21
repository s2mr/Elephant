import WebKit

final class SVGView: WKWebView {
    private let loader: SVGLoader
    private var executor: JavascriptExecutor!

    init(named: String, animationOwner: AnimationOwner, style: SVGLoader.Style? = .default, bundle: Bundle = .main) {
        let style = style ?? SVGLoader.Style(rawCSS: "")
        guard let loader = SVGLoader(named: named, animationOwner: animationOwner, style: style, bundle: bundle)
            else { fatalError("Image not found.") }
        self.loader = loader
        super.init(frame: .zero, configuration: .init())

        executor = JavascriptExecutor(webView: self) { return self.loader.css }
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        loadHTMLString(loader.html, baseURL: nil)
        scrollView.isScrollEnabled = false
        isUserInteractionEnabled = false
        isOpaque = false
        backgroundColor = UIColor.clear
        scrollView.backgroundColor = UIColor.clear
    }

    func isAnimate(result: @escaping (Bool?, Error?) -> Void) {
        switch loader.animationOwner {
        case .css: isAnimateCSS(result: result)
        case .svg: isAnimateSVG(result: result)
        }
    }

    private func isAnimateSVG(result: @escaping (Bool?, Error?) -> Void) {
        executor.execute(javaScriptCommand: .isAnimateSVG) { (value, error) in
            guard let value = value as? NSNumber, let bool = Bool(exactly: value) else { result(nil, error); return }
            result(!bool, error)
        }
    }

    private func isAnimateCSS(result: @escaping (Bool?, Error?) -> Void) {
        executor.execute(javaScriptCommand: .isAnimateCSS) { (value, error) in
            guard let value = value as? String else { result(nil, error); return }
            result(value == "running", error)
        }
    }

    private func animationRawCSS(isAnimate: Bool) -> String {
        let value = isAnimate ? "running" : "paused"
        return """
        * {
            animation-play-state: \(value);
        }
        """
    }

    func startAnimation(result: ((Error?) -> Void)? = nil) {
        switch loader.animationOwner {
        case .css:
            executor.execute(javaScriptCommand: .deleteStyleIfNeed) { _, e in
                result?(e)
            }
            executor.execute(javaScriptCommand: .insertCSS(rawCSS: loader.css + animationRawCSS(isAnimate: true))) { _, e in
                result?(e)
            }
        case .svg:
            executor.execute(javaScriptCommand: .startSVGAnimation) { _, e in
                result?(e)
            }
        }
    }

    func stopAnimation(result: ((Error?) -> Void)? = nil) {
        switch loader.animationOwner {
        case .css:
            executor.execute(javaScriptCommand: .deleteStyleIfNeed) { _, e in
                result?(e)
            }
            executor.execute(javaScriptCommand: .insertCSS(rawCSS: loader.css + animationRawCSS(isAnimate: false))) { _, e in
                result?(e)
            }
        case .svg:
            executor.execute(javaScriptCommand: .stopSVGAnimation) { _, e in
                result?(e)
            }
        }
    }
}
