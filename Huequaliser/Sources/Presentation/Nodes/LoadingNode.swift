//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import AsyncDisplayKit

public final class LoadingNode: ASDisplayNode {
    private let animationNode: ASDisplayNode = ASDisplayNode { () -> CALayer in
        let layer = CALayer()
        layer.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        layer.speed = 1
        LoadingNode.setUpAnimation(in: layer, size: CGSize(width: 50, height: 50), color: .white)
        return layer
    }

    public override init() {
        super.init()

        backgroundColor = UIColor.black.withAlphaComponent(0.4)

        automaticallyManagesSubnodes = true
    }

    public override func layoutSpecThatFits(
            _: ASSizeRange
    ) -> ASLayoutSpec {
        animationNode.style.preferredSize = CGSize(width: 100, height: 100)
        let center: ASCenterLayoutSpec = ASCenterLayoutSpec(
                centeringOptions: .XY,
                sizingOptions: [],
                child: animationNode
        )

        return center
    }

    private static func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let lineSpacing: CGFloat = 4
        let lineSize = CGSize(width: (size.width - 4 * lineSpacing) / 5, height: (size.height - 2 * lineSpacing) / 3)
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 1.2
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84, 0.96]
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        // Animation
        let animation = CAKeyframeAnimation(keyPath: "opacity")

        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.3, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        // Draw lines
        for i in 0 ..< 8 {
            let line = lineAt(angle: CGFloat(Double.pi / 4 * Double(i)),
                              size: lineSize,
                              origin: CGPoint(x: x, y: y),
                              containerSize: size,
                              color: color)

            animation.beginTime = beginTime + beginTimes[i]
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }

    private static func lineAt(
            angle: CGFloat,
            size: CGSize,
            origin: CGPoint,
            containerSize: CGSize,
            color: UIColor
    ) -> CALayer {
        let radius = containerSize.width / 2 - max(size.width, size.height) / 2
        let lineContainerSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))
        let lineContainer = CALayer()
        let lineContainerFrame = CGRect(
                x: origin.x + radius * (cos(angle) + 1),
                y: origin.y + radius * (sin(angle) + 1),
                width: lineContainerSize.width,
                height: lineContainerSize.height)
        let line: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                            cornerRadius: size.width / 2)
        line.fillColor = color.cgColor
        line.backgroundColor = nil
        line.path = path.cgPath
        line.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let lineFrame = CGRect(
                x: (lineContainerSize.width - size.width) / 2,
                y: (lineContainerSize.height - size.height) / 2,
                width: size.width,
                height: size.height)

        lineContainer.frame = lineContainerFrame
        line.frame = lineFrame
        lineContainer.addSublayer(line)
        lineContainer.sublayerTransform = CATransform3DMakeRotation(CGFloat(Double.pi / 2) + angle, 0, 0, 1)

        return lineContainer
    }
}
