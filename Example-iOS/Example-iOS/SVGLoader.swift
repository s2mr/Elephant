import Foundation
import WebKit

final class SVGLoader {
    let html: String
    init?(svgName: String) {
        guard
            let url = Bundle.main.url(forResource: svgName, withExtension: "svg"),
            let data = try? Data(contentsOf: url),
            let source = String(data: data, encoding: .utf8) else { return nil }

        self.html = """
        <!doctype html>
        <html>

        <head>
            <title>Document</title>
            <link rel="stylesheet" type="text/css" href="./loading-text.css">
        </head>

        <body>
            \(source)
        </body>

        </html>
       """


    }
}
