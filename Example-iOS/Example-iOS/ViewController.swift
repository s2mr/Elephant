import UIKit

final class ViewController: UIViewController {
    let svgView = SVGView(named: "image")

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(svgView)
        svgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            svgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            svgView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            svgView.widthAnchor.constraint(equalToConstant: 150),
            svgView.heightAnchor.constraint(equalToConstant: 150),
            ])
        svgView.load()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }

    @objc private func viewTapped() {
        svgView.isAnimate { [weak self] (value) in
            guard let value = value else { return }
            value ? self?.svgView.stopAnimation() : self?.svgView.startAnimation()
        }
    }
}
