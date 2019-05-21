import Foundation
import WebKit

final class JavascriptExecutor: NSObject {
    typealias InsertCSSHandler = () -> String
    private let webView: WKWebView
    private let insertCSSHandler: InsertCSSHandler

    enum Command: String {
        case startSVGAnimation = "document.getElementsByTagName('svg')[0].unpauseAnimations()"
        case stopSVGAnimation = "document.getElementsByTagName('svg')[0].pauseAnimations()"
    }

    init(webView: WKWebView, insertCSSHandler: @escaping InsertCSSHandler) {
        self.webView = webView
        self.insertCSSHandler = insertCSSHandler
        print("inited")
        super.init()
        webView.navigationDelegate = self
    }

    func deleteStyleIfNeeded() {
        let javsScript = """
            var elements = document.getElementsByTagName('style')
            if (elements.length > 0) {
                const targetElement = elements[0]
                const parentNode = targetElement.parentNode
                targetElement.parentNode.removeChild(targetElement)
            }
        """
        execute(javaScript: javsScript)
    }

    func insertCSS(rawCSS: String) {
        let css = resetCSS + rawCSS
        let javaScript = "var style = document.createElement('style'); style.innerHTML = `\(css)`; document.head.appendChild(style);"
        execute(javaScript: javaScript)
    }

    private func execute(javaScript: String, result: ((Any?, Error?) -> Void)? = nil) {
        let inlineJavaScript = javaScript.replacingOccurrences(of: "\n", with: "")
        DispatchQueue.main.async { [weak self] in
            self?.webView.evaluateJavaScript(inlineJavaScript) { (value, error) in
                result?(value, error)
            }
        }
    }

    func execute(javaScriptCommand: Command, result: ((Any?, Error?) -> Void)? = nil) {
        execute(javaScript: javaScriptCommand.rawValue, result: result)
    }
}

extension JavascriptExecutor {
    var resetCSS: String {
        return """
        a,abbr,acronym,address,applet,article,aside,audio,b,big,blockquote,body,canvas,caption,center,cite,code,dd,del,details,dfn,div,dl,dt,em,embed,fieldset,figcaption,figure,footer,form,h1,h2,h3,h4,h5,h6,header,hgroup,html,i,iframe,img,ins,kbd,label,legend,li,mark,menu,nav,object,ol,output,p,pre,q,ruby,s,samp,section,small,span,strike,strong,sub,summary,sup,table,tbody,td,tfoot,th,thead,time,tr,tt,u,ul,var,video{margin:0;padding:0;border:0;font-size:100%;font:inherit;vertical-align:baseline}article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section{display:block}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:after,blockquote:before,q:after,q:before{content:'';content:none}table{border-collapse:collapse;border-spacing:0}
        """
    }
}

extension JavascriptExecutor: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        insertCSS(rawCSS: insertCSSHandler())
    }
}
