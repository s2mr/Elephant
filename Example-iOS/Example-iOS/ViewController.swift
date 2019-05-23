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
    
    private lazy var startAnimationButton: UIButton = self.createButton(backgroundColor: .blue, title: "Start")
    private lazy var stopAnimationButton: UIButton = self.createButton(backgroundColor: .red, title: "Stop")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white 
        setLayout()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    private func setLayout() {
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

    @objc private func viewTapped() {
        svgView.isAnimate { [weak self] (value, _) in
            guard let value = value else { return }
            value ? self?.svgView.stopAnimation() : self?.svgView.startAnimation()
        }
        svgView2.isAnimate { [weak self] (value, _) in
            guard let value = value else { return }
            value ? self?.svgView2.stopAnimation() : self?.svgView2.startAnimation()
        }
    }
}
