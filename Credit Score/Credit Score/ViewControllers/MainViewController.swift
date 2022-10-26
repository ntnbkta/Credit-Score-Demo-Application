//
//  MainViewController.swift
//  Credit Score
//
//  Created by Nithin Bhaktha on 13/10/22.
//

import UIKit

class MainViewController: UIViewController {
 
    // Dependencies 
    var scoreUICoordinator: CreditScoreUIProvider? = CreditScoreUICoordinator()
    var dataProvider: UserProvider? = UserManager.shared
    
    @IBAction func showCreditScore(_ sender: Any) {
        
        dataProvider?.fetchCreditCardUser({ result in
            switch result {
            case .success(let user):
                self.presentCreditScoreUI(user)

            case .failure(let error):
                NSLog(error.localizedDescription)
            }
        })
    }
        
    private func presentCreditScoreUI(_ user: User) {
        DispatchQueue.main.async {
            if let vc = self.scoreUICoordinator?.viewControllerFor(user) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
