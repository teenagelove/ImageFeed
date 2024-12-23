import UIKit


final class GradientView: UIView {

    private let gradientLayer = CAGradientLayer()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.ypBlack.withAlphaComponent(0).cgColor,
            UIColor.ypBlack.withAlphaComponent(0.2).cgColor,
        ]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
