import Foundation
import WebKit

final class SVGLoader {
    let html: String
    let svg: String
    let css: String

    struct Style {
        var rawCSS: String
        static var `default`: Style {
            return Style(rawCSS: """
            svg {
                width: 100vw;
                height: 100vh;
                -webkit-animation: DASH 5s;
            }
            """)
        }
    }

    init?(named: String, style: Style, bundle: Bundle) {
        guard
            let url = bundle.url(forResource: named, withExtension: "svg"),
            let data = try? Data(contentsOf: url),
            let svg = String(data: data, encoding: .utf8) else { return nil }

        self.svg = svg
        self.css = style.rawCSS
        self.html = """
        <!doctype html>
        <html>

        <head>
            <meta charset="utf-8"/>
        </head>

        <body>
            \(self.svg)
        </body>

        <style>
            \(self.css)
        </style>

        </html>
        """
    }
}
