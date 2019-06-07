import UIKit
import Elephant

final class ViewController: UIViewController {
    private let container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 8.0
        return stack
    }()
    private let svgView = SVGView(named: "loading-text", animationOwner: .css, style: .cssFile(name: "loading-text"))
    private let svgView2 = SVGView(named: "image", animationOwner: .svg)
    private var svgViews: [SVGView] = []
    
    private lazy var startAnimationButton: UIButton = self.createButton(backgroundColor: #colorLiteral(red: 0.4549019608, green: 0.7254901961, blue: 1, alpha: 1), title: "Start")
    private lazy var stopAnimationButton: UIButton = self.createButton(backgroundColor: #colorLiteral(red: 0.3333333333, green: 0.937254902, blue: 0.768627451, alpha: 1), title: "Stop")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white 
        setLayout()
        
        startAnimationButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        stopAnimationButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    private func setLayout() {
        
        guard let svgView = svgView else {
            print("svgView wasn't init")
            return
        }
        guard let svgView2 = svgView2 else {
            print("svgView wasn't init")
            return
        }
        svgViews = [svgView, svgView2]
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.rightAnchor.constraint(equalTo: view.rightAnchor),
            container.leftAnchor.constraint(equalTo: view.leftAnchor),
            ])
        
        svgView.translatesAutoresizingMaskIntoConstraints = false
        container.addArrangedSubview(svgView)
        NSLayoutConstraint.activate([
            svgView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            svgView.heightAnchor.constraint(equalTo: svgView.widthAnchor),
            ])
        
        svgView2.translatesAutoresizingMaskIntoConstraints = false
        container.addArrangedSubview(svgView2)
        NSLayoutConstraint.activate([
            svgView2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            svgView2.heightAnchor.constraint(equalTo: svgView2.widthAnchor),
            ])

        container.addArrangedSubview(startAnimationButton)
        container.addArrangedSubview(stopAnimationButton)
    }
    
    private func createButton(backgroundColor: UIColor, title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            button.heightAnchor.constraint(equalToConstant: 48)
            ])
        button.layer.masksToBounds = true
        DispatchQueue.main.async {
            button.layer.cornerRadius = button.layer.bounds.height / 2.0
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc private func startButtonTapped() {
        svgViews.forEach { [weak self] view in
            view.startAnimation() { _ in
                self?.printIsAnimate(view)
            }
        }
    }
    
    @objc private func stopButtonTapped() {
        svgViews.forEach { [weak self] view in
            view.stopAnimation() { _ in
                self?.printIsAnimate(view)
            }
        }
    }

    @objc private func printIsAnimate(_ view: SVGView) {
        view.isAnimate { (value, _) in
            guard let value = value else { return }
            print("[\(Unmanaged.passUnretained(view).toOpaque())]", "isAnimate:", value)
        }
    }
}
