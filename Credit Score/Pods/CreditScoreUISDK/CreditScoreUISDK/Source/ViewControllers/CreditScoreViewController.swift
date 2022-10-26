//
//  ViewController.swift
//  CreditScore
//
//  Created by Nithin Bhaktha on 12/10/22.
//

import UIKit

/*
 @abstract: Subclass of UIViewController to display User's Credit Score.
 @discussion: This ViewController embeds an animatable Circular progress view which has a large label with credit score at the center of it and a progress animation depicting the credit score.
 This ViewController also embeds a Where you stand view, which plants the User's credit score amidst the market ranges.
 Pass in a CreditScore Model object to this ViewController while instantiating an object of this ViewController.
 */
class CreditScoreViewController: UIViewController {
        
    var model: CreditScoreModel?
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var circularView: CircularScoreView!
    @IBOutlet weak var whereYouStandView: WhereYouStandView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCircularProgressBarView()
        setUpWhereYouStandView()
    }
        
    /// sets up Circular  Progress view
    func setUpCircularProgressBarView() {
        
        guard let model else {
            return
        }
        circularView.show(model)
    }
    
    /// sets up Where You Stand View
    func setUpWhereYouStandView() {
       
        guard let model else {
            return
        }
        whereYouStandView.show(model)
    }
    
    // MARK: Action Methods
    
    /// Action method to see the score analysis,
    ///  Temporarily, an alert is thrown but can be used to present more details
    @IBAction func seeMyScoreAnalysis(_ sender: Any) {
        let alert = UIAlertController(title: "See My Score Analysis", message: "Button Tapped", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: Navigations
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? ARViewController {
            destination.imageToApply = self.containerStackView.makeSnapshot()
        }
    }
}
