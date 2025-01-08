import UIKit


final class GradientView: UIView {
    // MARK: - Private properties
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Inits
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    // MARK: - Override functions
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    // MARK: - Private functions
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.ypBlack.withAlphaComponent(0).cgColor,
            UIColor.ypBlack.withAlphaComponent(0.2).cgColor,
        ]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
