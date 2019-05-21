import Foundation
import WebKit

final class JavaScriptExecutor: NSObject {
    typealias InsertCSSHandler = () -> String
    private let webView: WKWebView
    private let insertCSSHandler: InsertCSSHandler

    enum Command {
        case startSVGAnimation
        case stopSVGAnimation
        case startCSSAnimation
        case stopCSSAnimation
        case insertCSS(rawCSS: String)
        case isAnimateSVG
        case isAnimateCSS

        var code: String {
            switch self {
            case .startSVGAnimation: return "document.getElementsByTagName('svg')[0].unpauseAnimations();"
            case .stopSVGAnimation: return "document.getElementsByTagName('svg')[0].pauseAnimations();"
            case .startCSSAnimation: return "document.body.style.setProperty('--style', 'running');"
            case .stopCSSAnimation: return "document.body.style.setProperty('--style', 'paused');"
            case .insertCSS(let rawCSS): return """
                var style = document.createElement('style');
                style.innerHTML = `\(JavaScriptExecutor.declarationCSS + JavaScriptExecutor.resetCSS + rawCSS)`;
                document.head.appendChild(style);
            """
            case .isAnimateSVG: return "document.getElementsByTagName('svg')[0].animationsPaused();"
            case .isAnimateCSS: return """
                var svg = document.body.getElementsByTagName("svg")[0];
                window.getComputedStyle(svg).animationPlayState;
            """
            }
        }
    }

    init(webView: WKWebView, insertCSSHandler: @escaping InsertCSSHandler) {
        self.webView = webView
        self.insertCSSHandler = insertCSSHandler
        super.init()
        webView.navigationDelegate = self
    }

    func execute(javaScriptCommand: Command, result: ((Any?, Error?) -> Void)? = nil) {
        execute(javaScript: javaScriptCommand.code, result: result)
    }

    private func execute(javaScript: String, result: ((Any?, Error?) -> Void)? = nil) {
        let inlineJavaScript = javaScript.replacingOccurrences(of: "\n", with: "")
        DispatchQueue.main.async { [weak self] in
            self?.webView.evaluateJavaScript(inlineJavaScript) { (value, error) in
                result?(value, error)
            }
        }
    }
}

extension JavaScriptExecutor {
    static var resetCSS: String {
        return """
        a,abbr,acronym,address,applet,article,aside,audio,b,big,blockquote,body,canvas,caption,center,cite,code,dd,del,details,dfn,div,dl,dt,em,embed,fieldset,figcaption,figure,footer,form,h1,h2,h3,h4,h5,h6,header,hgroup,html,i,iframe,img,ins,kbd,label,legend,li,mark,menu,nav,object,ol,output,p,pre,q,ruby,s,samp,section,small,span,strike,strong,sub,summary,sup,table,tbody,td,tfoot,th,thead,time,tr,tt,u,ul,var,video{margin:0;padding:0;border:0;font-size:100%;font:inherit;vertical-align:baseline}article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section{display:block}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:after,blockquote:before,q:after,q:before{content:'';content:none}table{border-collapse:collapse;border-spacing:0}
        """
    }
    static var declarationCSS: String {
        return """
        * {
        animation-play-state: var(--style);
        }
        """
    }
}

extension JavaScriptExecutor: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        execute(javaScriptCommand: .insertCSS(rawCSS: insertCSSHandler()))
    }
}
