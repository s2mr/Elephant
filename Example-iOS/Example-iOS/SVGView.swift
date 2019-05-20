import WebKit

final class SVGView: WKWebView {
    private let loader: SVGLoader

    init?(svgName: String) {
        guard let loader = SVGLoader(svgName: svgName) else { return nil }
        self.loader = loader
        super.init(frame: .zero, configuration: .init())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func load() {
        loadHTMLString(loader.html, baseURL: nil)
    }
}
