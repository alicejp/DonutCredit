import UIKit

class ProcessView: UIView
{
    var fatchBtnTapped: (()-> Void)?

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Dashboard"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        return label
    }()

    private lazy var processLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 3
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var loadBtn: UIButton = {
        var button = UIButton()
        button.setTitle("Load Data", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.addTarget(self, action: #selector(loadBtnTapped), for: .touchUpInside)
        button.layer.cornerRadius = 24
        button.layer.borderColor = UIColor.purple.cgColor
        button.layer.borderWidth = 1
        return button
    }()

    private var bubbleView: RoundedView!
    private var baseBubbleView: RoundedView!

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
        layout()
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    func updateWith(_ viewModel: ProcessViewModel)
    {
        processLabel.attributedText = specialString(creditScore: viewModel.creditScore, maxScoreValue: viewModel.maxScoreValue)
        setupAndLayoutBubbleView(viewModel)
    }

    private func specialString(creditScore: Int?, maxScoreValue: Int?) -> NSMutableAttributedString
    {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 80.0)
        ]

        let prefix = NSMutableAttributedString(string: "Your credit score is\n")
        let creditScore = NSAttributedString(string: "\(creditScore ?? 0)\n", attributes: attributes)
        let suffix = NSAttributedString(string: "out of \(maxScoreValue ?? 0)")

        prefix.append(creditScore)
        prefix.append(suffix)

        return prefix
    }

    private func setupAndLayoutBubbleView(_ viewModel: ProcessViewModel)
    {
        if bubbleView != nil, bubbleView.isDescendant(of: self) {
            bubbleView.removeFromSuperview()
        }

        bubbleView = RoundedView(config: RoundedViewConfig(progressRatio: viewModel.progressRatio,  radiusRatio: 0.75, color: .orange))
        addSubview(bubbleView)
        setNeedsDisplay()

        if bubbleView != nil, baseBubbleView != nil
        {
            bubbleView.layout([
                bubbleView.centerXAnchor.constraint(equalTo: centerXAnchor),
                bubbleView.centerYAnchor.constraint(equalTo: centerYAnchor),
                bubbleView.heightAnchor.constraint(equalToConstant: baseBubbleView.frame.height),
                bubbleView.widthAnchor.constraint(equalToConstant: baseBubbleView.frame.width)
            ])
        }
    }

    private func setup()
    {
        addSubview(titleLabel)
        addSubview(processLabel)
        baseBubbleView = RoundedView()
        addSubview(baseBubbleView)
        addSubview(loadBtn)
    }

    private func layout()
    {
        let margin: CGFloat = 20
        let radius: CGFloat = min(bounds.width, bounds.height) - margin * 2

        titleLabel.layout([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 48)
        ])

        processLabel.layout([
            processLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            processLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            processLabel.heightAnchor.constraint(equalToConstant: radius/2),
            processLabel.widthAnchor.constraint(equalToConstant: radius/2)
        ])

        baseBubbleView.layout([
            baseBubbleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            baseBubbleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            baseBubbleView.heightAnchor.constraint(equalToConstant: radius),
            baseBubbleView.widthAnchor.constraint(equalToConstant: radius)
        ])

        loadBtn.layout([
            loadBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            loadBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            loadBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            loadBtn.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc
    private func loadBtnTapped()
    {
        fatchBtnTapped?()
    }
}
