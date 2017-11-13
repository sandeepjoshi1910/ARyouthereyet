//
//  ViewController.swift
//  ARYouThereYet
//
//  Created by Debojit Kaushik  on 11/7/17.
//  Copyright © 2017 Debojit Kaushik . All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        let currentLocation = locationManager.location
        let identityLocation = matrix_identity_float4x4
        let endLocation = CLLocation(latitude: 41.871117, longitude: -87.664129)
        // 41.871117, -87.664129
        let holder = MatrixHelper.transformMatrix(for: identityLocation, originLocation: currentLocation!, location: endLocation)
        // let finalLocation = SCNMatrix4.init(holder)
        // let ourLocation = SCNMatrix4.init(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: 0, m31: 0, m32: 0, m33: 1, m34: 0, m41: Float((currentLocation?.coordinate.latitude)!), m42: 0, m43: Float((currentLocation?.coordinate.longitude)!), m44: 0)
        
        // let endLocationMatrix = SCNMatrix4(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: 0, m31: 0, m32: 0, m33: 1, m34: 0, m41: Float(endLocation.coordinate.latitude), m42: 0, m43: Float(endLocation.coordinate.longitude), m44: 0)
        
        let geometry = SCNSphere(radius: 0.5)
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        let sphereNode = SCNNode(geometry: geometry)
        
        let testAnchor = ARAnchor(transform: holder)
        // sphereNode.position = SCNVector3Make(holder.columns.3.x, 0, holder.columns.3.z)
        // sphereNode.position = SCNVector3(sceneView.pointOfView!.simdWorldFront.x + holder.columns.3.x, sceneView.pointOfView!.simdWorldFront.y + holder.columns.3.y, sceneView.pointOfView!.simdWorldFront.z + holder.columns.3.z)
        sphereNode.transform = SCNMatrix4.init(testAnchor.transform)
        sphereNode.position = SCNVector3Make(holder.columns.3.x, holder.columns.3.y, holder.columns.3.z)

        //locationLabel.text = String(testAnchor.transform.columns.3.x)
        sceneView.scene.rootNode.addChildNode(sphereNode)
        print("TestAnchor: %s", testAnchor.transform)
        print("SphereNode: %s", sphereNode.transform)
        
        locationLabel.text = "\(testAnchor.transform.columns.3.x, testAnchor.transform.columns.3.y, testAnchor.transform.columns.3.z)"
        
        sceneView.session.add(anchor: testAnchor)
    }
}
