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

    func isAnimate(result: @escaping (Bool?) -> Void) {
        switch loader.animationOwner {
        case .css: isAnimateCSS(result: result)
        case .svg: isAnimateSVG(result: result)
        }
    }

    private func isAnimateSVG(result: @escaping (Bool?) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.evaluateJavaScript("document.getElementsByTagName('svg')[0].animationsPaused()") { value, _ in
                guard let value = value as? NSNumber, let bool = Bool(exactly: value) else { result(nil); return }
                result(!bool)
            }
        }
    }

    private func isAnimateCSS(result: @escaping (Bool?) -> Void) {
        DispatchQueue.main.async { [weak self] in
            let js = """
            var svg = document.body.getElementsByTagName("svg")[0];
            window.getComputedStyle(svg).animationPlayState
            """.replacingOccurrences(of: "\n", with: "")
            self?.evaluateJavaScript(js) { value, error in
                guard let value = value as? String else { result(nil); return }
                result(value == "running")
            }
        }
    }

    func animationRawCSS(isAnimate: Bool) -> String {
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
            executor.deleteStyleIfNeeded()
            executor.insertCSS(rawCSS: loader.css + animationRawCSS(isAnimate: true))
        case .svg:
            executor.execute(javaScriptCommand: .startSVGAnimation)
        }
    }

    func stopAnimation(result: ((Error?) -> Void)? = nil) {
        switch loader.animationOwner {
        case .css:
            executor.deleteStyleIfNeeded()
            executor.insertCSS(rawCSS: loader.css + animationRawCSS(isAnimate: false))
        case .svg:
            executor.execute(javaScriptCommand: .stopSVGAnimation)
        }
    }
}
