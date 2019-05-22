import Foundation
import WebKit

public final class SVGLoader {
    let html: String
    let svg: String
    let css: String
    let animationOwner: AnimationOwner

    public struct Style {
        var rawCSS: String

        var resetCSS: String {
            return """
            a,abbr,acronym,address,applet,article,aside,audio,b,big,blockquote,body,canvas,caption,center,cite,code,dd,del,details,dfn,div,dl,dt,em,embed,fieldset,figcaption,figure,footer,form,h1,h2,h3,h4,h5,h6,header,hgroup,html,i,iframe,img,ins,kbd,label,legend,li,mark,menu,nav,object,ol,output,p,pre,q,ruby,s,samp,section,small,span,strike,strong,sub,summary,sup,table,tbody,td,tfoot,th,thead,time,tr,tt,u,ul,var,video{margin:0;padding:0;border:0;font-size:100%;font:inherit;vertical-align:baseline}article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section{display:block}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:after,blockquote:before,q:after,q:before{content:'';content:none}table{border-collapse:collapse;border-spacing:0}
            """
        }

        var declarationCSS: String {
            return """
            * {
            animation-play-state: var(--style);
            }
            """
        }

        public static var `default`: Style {
            return Style(rawCSS: """
            svg {
                width: 100vw;
                height: 100vh;
            }
            """)
        }

        public static func cssFile(name: String, bundle: Bundle = .main) -> Style {
            guard
                let url = bundle.url(forResource: name, withExtension: "css"),
                let rawString = try? String(contentsOf: url, encoding: .utf8) else { fatalError("Cannot read file.") }

            return .init(rawCSS: rawString + "\n" + Style.default.rawCSS)
        }
    }

    init?(named: String, animationOwner: AnimationOwner, style: Style, bundle: Bundle) {
        guard
            let url = bundle.url(forResource: named, withExtension: "svg"),
            let data = try? Data(contentsOf: url),
            let svg = String(data: data, encoding: .utf8) else { return nil }

        self.animationOwner = animationOwner
        self.svg = svg
        self.css = style.rawCSS
        self.html = """
        <!doctype html>
        <html>

        <head>
            <meta charset="utf-8"/>
            <style>
                \(self.css)
                \(style.resetCSS)
                \(style.declarationCSS)
            </style>
        </head>

        <body>
            \(self.svg)
        </body>

        </html>
        """
    }
}
