import WebKit

final class SVGView: WKWebView {
    private let loader: SVGLoader

    init(named: String, animationOwner: AnimationOwner, style: SVGLoader.Style? = .default, bundle: Bundle = .main) {
        let style = style ?? SVGLoader.Style(rawCSS: "")
        guard let loader = SVGLoader(named: named, animationOwner: animationOwner, style: style, bundle: bundle)
            else { fatalError("Image not found.") }
        self.loader = loader
        super.init(frame: .zero, configuration: .init())

        navigationDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func load() {
        loadHTMLString(loader.html, baseURL: nil)
        scrollView.isScrollEnabled = false
        isUserInteractionEnabled = false
        isOpaque = false
        backgroundColor = UIColor.purple
        scrollView.backgroundColor = UIColor.clear
    }

    func insertCSS(rawCSS: String) {
        print("insertStyle")
//        let rawCSS = """
//            \(loader.css)
//        * {
//        background-color: red;
//        }
//
//        """.replacingOccurrences(of: "\n", with: "")

        let rawCSS = rawCSS.replacingOccurrences(of: "\n", with: "")

        let js = "var style = document.createElement('style'); style.innerHTML = '\(rawCSS)'; document.head.appendChild(style);"

        evaluateJavaScript(js) { _, error in
            if let error = error {
                print(error)
            }
        }
    }

    func printDocuments() {
        evaluateJavaScript("JSON.stringify(document.head.innerHTML)") { (any, error) in
            if let error = error {
                print(error)
            }
            print(any ?? "")
        }
    }

    func deleteStyleIfNeeded() {
        print("deleteStyle")
        evaluateJavaScript("""
            var elements = document.getElementsByTagName('style')
            if (elements.length > 0) {
                const targetElement = elements[0]
                const parentNode = targetElement.parentNode
                targetElement.parentNode.removeChild(targetElement)
            }
        """) { _, error in
            if let error = error {
                print(error)
            }
        }
    }

    func isAnimate(result: @escaping (Bool?) -> Void) {
        switch loader.animationOwner {
        case .css: isAnimateCSS(result: result)
        case .svg: isAnimateSVG(result: result)
        }
    }

    func isAnimateSVG(result: @escaping (Bool?) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.evaluateJavaScript("document.getElementsByTagName('svg')[0].animationsPaused()") { value, _ in
                guard let value = value as? NSNumber, let bool = Bool(exactly: value) else { result(nil); return }
                print("isAnimate:", !bool)
                result(!bool)
            }
        }
    }

    func isAnimateCSS(result: @escaping (Bool?) -> Void) {
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
        print("startAnimation")
        DispatchQueue.main.async { [weak self] in
            guard let me = self else { return }
            switch me.loader.animationOwner {
            case .css:
                me.deleteStyleIfNeeded()
                me.insertCSS(rawCSS: me.loader.css + me.animationRawCSS(isAnimate: true))
//                me.evaluateJavaScript("") { _, error in
//                    print(error)
//                }
            case .svg:
                me.evaluateJavaScript("document.getElementsByTagName('svg')[0].unpauseAnimations()") { _ , error in
                    result?(error)
                }
            }
        }
    }

    func stopAnimation(result: ((Error?) -> Void)? = nil) {
        print("stopAnimation")
        DispatchQueue.main.async { [weak self] in
            guard let me = self else { return }
            switch me.loader.animationOwner {
            case .css:
                me.deleteStyleIfNeeded()
                me.printDocuments()
                me.insertCSS(rawCSS: me.loader.css + me.animationRawCSS(isAnimate: false))
                me.printDocuments()
            case .svg:
                me.evaluateJavaScript("document.getElementsByTagName('svg')[0].pauseAnimations()") { _ , error in
                    result?(error)
                }
            }
        }
    }
}

extension SVGView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
        insertCSS(rawCSS: loader.css)
    }
}
