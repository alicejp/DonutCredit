import UIKit

struct RoundedViewConfig {
    let progressRatio: CGFloat
    let radiusRatio: CGFloat
    let color: UIColor
}

class RoundedView: UIView
{
    var config : RoundedViewConfig

    private struct Constants
    {
      static let arcWidth: CGFloat = 5
    }

    init(config: RoundedViewConfig = RoundedViewConfig(progressRatio: 1, radiusRatio: 1, color: UIColor.black))
    {
        self.config = config
        super.init(frame: .zero)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect)
    {
        let baseRadius = bounds.width/2 - Constants.arcWidth/2
        let progressRadius = config.radiusRatio * baseRadius
        let progressEndAngle = config.progressRatio * .pi * 3 / 2

        drawClockwiseArc(with: progressRadius, endAngle: progressEndAngle, color: config.color)
    }

    private func drawClockwiseArc(with radius: CGFloat, startAngle: CGFloat = -.pi/2 , endAngle: CGFloat, color: UIColor)
    {
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                                   radius: radius,
                                   startAngle: startAngle,
                                 endAngle: endAngle,
                                clockwise: true)

        path.lineWidth = Constants.arcWidth
        color.setStroke()
        path.stroke()
    }
}
