//
//  WhereYouStandView.swift
//  CreditScoreUISDK
//
//  Created by Nithin Bhaktha on 19/10/22.
//

import UIKit

/*
 @abstract: A custom subclass of UIView. Where You Stand View plants the user's credit score with respect to market's credit score range
 @discussion: Use show(_ model:) API to pass in the model, CreditScoreModel while initializing an instance of this view. This view consists of 5 bar like subviews which can be used to depict worst through excellent market ranges. These bars are colored categorizing worst (dark red) and gradually adding greens to represent excellent (Green).
 */
class WhereYouStandView: UIView {
    
    struct Constants {
        static let nibName = "WhereYouStandView"
    }
    
    private(set) var model: CreditScoreModel?
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var excellentPercentageShareLabel: UILabel!
    @IBOutlet weak var goodPercentageShareLabel: UILabel!
    @IBOutlet weak var averagePercentageShareLabel: UILabel!
    @IBOutlet weak var badPercentageShareLabel: UILabel!
    @IBOutlet weak var worstPercentageShareLabel: UILabel!
    
    @IBOutlet weak var excellentRangeLabel: UILabel!
    @IBOutlet weak var goodRangeLabel: UILabel!
    @IBOutlet weak var averageRangeLabel: UILabel!
    @IBOutlet weak var badRangeLabel: UILabel!
    @IBOutlet weak var worstRangeLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        addSubview(youAreHereView)
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Constants.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    /// An arrow imaged view, to point at the market range where the User's credit score is contained.
    private var youAreHereView: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.darkText, for: .normal)
        button.setBackgroundImage(UIImage(named: "arrow.png", in: Bundle.creditScoreUIBundle(), with: nil), for: .normal)
        button.isUserInteractionEnabled = false
        button.contentMode = .scaleAspectFill
        // shadow
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 20.0, height: 20.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 10.0
        button.layer.masksToBounds = false
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerStackView.layoutIfNeeded()
        showYouAreHereView()
    }

    // use this API to set the view's model
    func show(_ model: CreditScoreModel) {
        self.model = model
        updateRangeLabels()
    }

    // updates all labels to represent the model's score and ranges.
    private func updateRangeLabels() {
        guard let model = model else {
            return
        }
        
        youAreHereView.setAttributedTitle(NSAttributedString(string:"\(model.score)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15.0)]), for: .normal)
        excellentPercentageShareLabel.text = "\(model.scoreRange.excellent.percentageShare)%"
        goodPercentageShareLabel.text = "\(model.scoreRange.good.percentageShare)%"
        averagePercentageShareLabel.text = "\(model.scoreRange.average.percentageShare)%"
        badPercentageShareLabel.text = "\(model.scoreRange.bad.percentageShare)%"
        worstPercentageShareLabel.text = "\(model.scoreRange.worst.percentageShare)%"
        
        excellentRangeLabel.text = model.scoreRange.excellent.getAsText()
        goodRangeLabel.text = model.scoreRange.good.getAsText()
        averageRangeLabel.text = model.scoreRange.average.getAsText()
        badRangeLabel.text = model.scoreRange.bad.getAsText()
        worstRangeLabel.text = model.scoreRange.worst.getAsText()
    }
    
    // Shows the Arrow imaged view with User's current score amidst the market ranges.
    private func showYouAreHereView() {
        
        let currentDevice = UIDevice.current.userInterfaceIdiom
        let leadingConstant = DeviceSpecificConfig(ipad: 250.0, iphone: 150.0, unspecified: 150.0)
        let stackView = containerStackView.subviews[barLevel()]
        let size = CGSize(width: stackView.bounds.width / 5, height: stackView.bounds.height)

        youAreHereView.frame.size = size
        youAreHereView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            youAreHereView.topAnchor.constraint(equalTo: stackView.topAnchor),
            youAreHereView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            youAreHereView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: leadingConstant[currentDevice]),
            youAreHereView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            youAreHereView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])
    }
    
    // Gets the bar level of the current model's score amidst the market ranges.
    private func barLevel() -> Int {
        
        guard let score = model?.score, let range = model?.scoreRange else {
            return 0
        }
        
        if (range.excellent.minScore...range.excellent.maxScore).contains(score) { return 0 }
        else if (range.good.minScore...range.good.maxScore).contains(score) { return 1 }
        else if (range.average.minScore...range.average.maxScore).contains(score) { return 2 }
        else if (range.bad.minScore...range.bad.maxScore).contains(score) { return 3 }
        else if (range.worst.minScore...range.worst.maxScore).contains(score) { return 4 }
        return 0
    }
}

extension CreditScoreMarketRange {
    
    func getAsText() -> String {
        return "\(minScore)" + "-" + "\(maxScore)"
    }
}
