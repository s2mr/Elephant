import Foundation
import WebKit

enum AnimationOwner {
    case css
    case svg
}

final class SVGLoader {
    let html: String
    let svg: String
    let css: String
    let animationOwner: AnimationOwner

    struct Style {
        var rawCSS: String
        static var `default`: Style {
            return Style(rawCSS: """
            svg {
                width: 100vw;
                height: 100vh;
            }
            """)
        }
        static func cssFile(name: String, bundle: Bundle = .main) -> Style {
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
        </head>

        <body>
            \(self.svg)
        </body>

        </html>
        """

        print(html)
    }
}
