import Foundation
import WebKit

final class JavaScriptExecutor: NSObject {
    private weak var webView: WKWebView?

    enum Command {
        case startSVGAnimation
        case stopSVGAnimation
        case startCSSAnimation
        case stopCSSAnimation
        case isAnimateSVG
        case isAnimateCSS

        var code: String {
            switch self {
            case .startSVGAnimation: return "document.getElementsByTagName('svg')[0].unpauseAnimations();"
            case .stopSVGAnimation: return "document.getElementsByTagName('svg')[0].pauseAnimations();"
            case .startCSSAnimation: return "document.body.style.setProperty('--style', 'running');"
            case .stopCSSAnimation: return "document.body.style.setProperty('--style', 'paused');"
            case .isAnimateSVG: return "document.getElementsByTagName('svg')[0].animationsPaused();"
            case .isAnimateCSS: return """
                var svg = document.body.getElementsByTagName("svg")[0];
                window.getComputedStyle(svg).animationPlayState;
            """
            }
        }
    }

    init(webView: WKWebView) {
        self.webView = webView
        super.init()
    }

    func execute(javaScriptCommand: Command, result: ((Any?, Error?) -> Void)? = nil) {
        execute(javaScript: javaScriptCommand.code, result: result)
    }

    private func execute(javaScript: String, result: ((Any?, Error?) -> Void)? = nil) {
        let inlineJavaScript = javaScript.replacingOccurrences(of: "\n", with: "")
        DispatchQueue.main.async { [weak self] in
            self?.webView?.evaluateJavaScript(inlineJavaScript) { (value, error) in
                result?(value, error)
            }
        }
    }
}
