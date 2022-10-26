//
//  CircularScoreView.swift
//  CreditScore
//
//  Created by Nithin Bhaktha on 12/10/22.
//

import UIKit
import Foundation
import QuartzCore

/*
 @abstract: A custom subclass of UIView. Cirular view which renders a progress animation of the credit score and has a centered large label denoting the credit score.
 @discussion: Pass in the model, CreditScoreModel while initializing an instance of this view. The progress animation is circular with 300 as the start score and 900 as the end score.
 */
class CircularScoreView: UIView {
    
    struct Constants {
        static let nibName = "CircularScoreView"
        static let startScore = 300
        static let endScore = 900
        static let startPoint = CGFloat(Double.pi / 2)
        static let endPoint = CGFloat(2*Double.pi)
        static let circularViewDuration: TimeInterval = 2
        static let circularRadius: CGFloat = UIScreen.main.preferredMode!.size.width / 12
    }
    
    // MARK: - Properties -
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private(set) var model: CreditScoreModel?
    private var circularPath: UIBezierPath?
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startLabel: UILabel?
    private var endLabel: UILabel?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        updateShapeLayers()
        createStartEndLabels()
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Constants.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    // date formatter to format any date model to the known format
    private lazy var formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df
    }()
    
    // creates the start score label and end score label that is visible at the start and end of the circle respectively
    private func createStartEndLabels() {
        guard startLabel == nil, endLabel == nil else {
            return
        }

        startLabel = UILabel(frame: .zero)
        if let startLabel {
            startLabel.text = "\(Constants.startScore)"
            addSubview(startLabel)
        }
        endLabel = UILabel(frame: .zero)
        if let endLabel {
            endLabel.text = "\(Constants.endScore)"
            addSubview(endLabel)
        }
    }

    // layout the start and the end labels based on where the circular path is.
    private func layoutStartEndLabels(_ circularPath: UIBezierPath) {

        guard let startLabel, let endLabel else {
            return
        }
        
        let sPoint = CGPoint.pointOnCircle(center: self.center,
                                           radius: Constants.circularRadius,
                                           angle: Constants.startPoint,
                                           padding: 22.5)
        let startFrame = CGRect(origin: sPoint, size: CGSize(width: 50, height: 50))
        startLabel.frame = startFrame
        
        let ePoint = CGPoint.pointOnCircle(center: self.center,
                                           radius: Constants.circularRadius,
                                           angle: Constants.endPoint,
                                           padding: -12.0)
        let endFrame = CGRect(origin: ePoint, size: CGSize(width: 50, height: 50))
        endLabel.frame = endFrame
    }
    
    private func updateShapeLayers() {
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .square
        circleLayer.lineWidth = 20.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.lightGray.cgColor
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .square
        progressLayer.lineWidth = 20.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = #colorLiteral(red: 0.8832228184, green: 0.7315439582, blue: 0.4175841212, alpha: 1)//UIColor.yellow.cgColor
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()

        let circularPath = UIBezierPath(arcCenter: self.center,
                                        radius: Constants.circularRadius,
                                        startAngle: Constants.startPoint,
                                        endAngle: Constants.endPoint, clockwise: true)
        
        layoutStartEndLabels(circularPath)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        
        // call the animation with circularViewDuration
        progressAnimation(duration: Constants.circularViewDuration)
    }
    
    func show(_ model: CreditScoreModel) {
        
        self.model = model
        scoreLabel.text = "\(model.score)"
        dateLabel.text = "As of \(formatter.string(from: model.scoreDate))."

        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
    
    private func progressAnimation(duration: TimeInterval) {
        
        guard let model else {
            return
        }
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        let toValue = Float(model.score - Constants.startScore) / Float(Constants.endScore - Constants.startScore)
        circularProgressAnimation.toValue = toValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}

extension CGPoint {
    
    static func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat, padding: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle) + padding
        let y = center.y + radius * sin(angle) - padding
        
        return CGPoint(x: x, y: y)
    }
}
