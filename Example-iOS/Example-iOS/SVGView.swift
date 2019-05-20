import WebKit

final class SVGView: WKWebView {
    private let loader: SVGLoader

    init(named: String, bundle: Bundle = .main) {
        guard let loader = SVGLoader(named: named, bundle: bundle) else { fatalError("Image not found.") }
        self.loader = loader
        super.init(frame: .zero, configuration: .init())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func load() {
        loadHTMLString(loader.html, baseURL: nil)
        scrollView.isScrollEnabled = false
    }

    func isAnimate(result: @escaping (Bool?) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.evaluateJavaScript("document.getElementsByTagName('svg')[0].animationsPaused()") { value, _ in
                guard let value = value as? NSNumber, let bool = Bool(exactly: value) else { result(nil); return }
                result(!bool)
            }
        }
    }

    func startAnimation(result: ((Error?) -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.evaluateJavaScript("document.getElementsByTagName('svg')[0].unpauseAnimations()") { _ , error in
                result?(error)
            }
        }
    }

    func stopAnimation(result: ((Error?) -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.evaluateJavaScript("document.getElementsByTagName('svg')[0].pauseAnimations()") { _ , error in
                result?(error)
            }
        }
    }
}
