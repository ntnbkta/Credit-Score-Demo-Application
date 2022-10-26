//
//  ARViewController.swift
//  CreditScoreUI
//
//  Created by Nithin Bhaktha on 16/10/22.
//

import Foundation
import ARKit

/*
 @abstract: Subclass of UIViewController to render the pie chart and the bars depicting User's Credit Score in market range in Augmented Reality using ARKit.
 */
class ARViewController: UIViewController {
    
    @IBOutlet weak var arScnView: ARSCNView!
    let augmentedRealitySession = ARSession()
    let configuration = ARWorldTrackingConfiguration()
    var nodeWeCanChange: SCNNode?
    var imageToApply: UIImage? 

    override func viewDidLoad() {
        super.viewDidLoad()
        // set up our ARSession
        arScnView.session = augmentedRealitySession
        
        // assign the ARSCNViewDelegate
        arScnView.delegate = self
        
        // setup plane detection
        configuration.planeDetection = [.horizontal, .vertical]
        
        // run our configuration
        augmentedRealitySession.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
        
    private func showImageInAR() {
        guard let image = imageToApply, let node = nodeWeCanChange  else {
            return
        }
        // apply the image on the node
        node.geometry?.firstMaterial?.diffuse.contents = image
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        arScnView.session.pause()
        arScnView.removeFromSuperview()
        arScnView = nil
    }
}

extension ARViewController: ARSCNViewDelegate{

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        // Check if we haven't created out interactive node, then proceed
        if nodeWeCanChange == nil{

            // Check if we have detected an ARPlaneAnchor
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

            // get the size of the ARPlaneAnchor
            let width = CGFloat(planeAnchor.extent.x / 2)
            let height = CGFloat(planeAnchor.extent.z / 2)

            // create an SCNPlane which matches the size of the ARPlaneAnchor
            nodeWeCanChange = SCNNode(geometry: SCNPlane(width: width, height: height))

            // rotate it
            nodeWeCanChange?.eulerAngles.x = -.pi/2

            // add it to our node
            node.addChildNode(nodeWeCanChange!)
        }
        
        showImageInAR()
    }
}
