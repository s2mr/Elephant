import WebKit

public class SVGView: UIView, WKNavigationDelegate {
    private lazy var webView: WKWebView = .init(frame: self.bounds)
    private let loader: SVGLoader
    private lazy var executor = JavaScriptExecutor(webView: self.webView)

    public init?(named: String, animationOwner: AnimationOwner, style: SVGLoader.Style? = .default, bundle: Bundle = .main) {
        let style = style ?? SVGLoader.Style(rawCSS: "")
        guard let loader = SVGLoader(named: named, animationOwner: animationOwner, style: style, bundle: bundle)
            else {
                print("Image not found.")
                return nil
        }
        self.loader = loader
        super.init(frame: .zero)

        setup()
    }
    
    public init?(fileURL: URL, animationOwner: AnimationOwner, style: SVGLoader.Style? = .default) {
        let style = style ?? SVGLoader.Style(rawCSS: "")
        guard let loader = SVGLoader(fileURL: fileURL, animationOwner: animationOwner, style: style)
            else {
                print("Image not found.")
                return nil
        }
        self.loader = loader
        super.init(frame: .zero)
        
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        NSLayoutConstraint.activate([
           webView.topAnchor.constraint(equalTo: topAnchor),
           webView.rightAnchor.constraint(equalTo: rightAnchor),
           webView.bottomAnchor.constraint(equalTo: bottomAnchor),
           webView.leftAnchor.constraint(equalTo: leftAnchor),
            ])
        webView.isOpaque = false
        webView.backgroundColor = .clear
        isUserInteractionEnabled = false
        isOpaque = false
        backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false
        
        webView.loadHTMLString(loader.html, baseURL: nil)
    }

    public func isAnimate(result: @escaping (Bool?, Error?) -> Void) {
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

    public func startAnimation(result: ((Error?) -> Void)? = nil) {
        switch loader.animationOwner {
        case .css:
            executor.execute(javaScriptCommand: .startCSSAnimation) { (_, e) in
                result?(e)
            }
        case .svg:
            executor.execute(javaScriptCommand: .startSVGAnimation) { _, e in
                result?(e)
            }
        }
    }

    public func stopAnimation(result: ((Error?) -> Void)? = nil) {
        switch loader.animationOwner {
        case .css:
            executor.execute(javaScriptCommand: .stopCSSAnimation) { (_, e) in
                result?(e)
            }
        case .svg:
            executor.execute(javaScriptCommand: .stopSVGAnimation) { _, e in
                result?(e)
            }
        }
    }

    // MARK: - WKNavigationDelegate

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backgroundColor = .clear
        isOpaque = false
    }
}
