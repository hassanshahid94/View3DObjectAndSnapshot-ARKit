//
//  ViewController.swift
//  View3DObjectAndSnapshot
//
//  Created by Hassan on 19.9.2020.
//

import UIKit
import SceneKit
import ARKit
import CoreData

class ViewController: BaseVC {
    
    //MARK:- Variables
    var arrImages = [ImagesData]()
    let delegate = UIApplication.shared.delegate as! AppDelegate
     
    var cameraPosition: SCNVector3!
    var objectPostion: SCNVector3!
    
    var snapshopt: UIImage!
    
    var flagDotAdd = false
    
    //MARK:- Outlets
    @IBOutlet weak var btnSnapshot: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var vwShutter: UIView!
    @IBOutlet weak var btnLoadImages: UIButton!
    @IBOutlet weak var btnClearData: UIButton!
    @IBOutlet weak var btnClearARView: UIButton!
    
    //MARK:- Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    
        sceneView.session.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        startLoader()
        let touch = touches.first
        let location = touch?.location(in: sceneView)

        let hitResults = sceneView.hitTest(location!, types: .featurePoint)

        if let hitTestResult = hitResults.first {
            let transform = hitTestResult.worldTransform
            
            objectPostion = SCNVector3(x: transform.columns.3.x, y: transform.columns.3.y, z:transform.columns.3.z)

            guard let curveScene = SCNScene(named: "art.scnassets/curve.scn"),
                let curveNode = curveScene.rootNode.childNode(withName: "curve", recursively: false)
                else { return }

            curveNode.position = objectPostion
            curveNode.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
            sceneView.scene.rootNode.addChildNode(curveNode)
            stopLoader()
        }
        else
        {
            stopLoader()
            showAlert(message: "Tap again to add object")
        }
    }
    
    //MARK:- Actions
    @IBAction func btnSnapshotAction(_ sender: UIButton) {
        
        if objectPostion != nil{
            vwShutter.alpha = 1.0
            vwShutter.isHidden = false
            snapshopt = sceneView.snapshot()
            flagDotAdd = true
            UIView.animate(withDuration: 1.0, animations: {
                       self.vwShutter.alpha = 0.0
                   }) { (finished) in
                       self.vwShutter.isHidden = true
            }
        }
        else{
            showAlert(message: "Please place the 3D-object first")
        }
        
    }
    
    @IBAction func btnLoadImagesAction(_ sender: UIButton) {
        loadSnapshots()
    }
    
    @IBAction func btnClearDataAction(_ sender: UIButton) {
        
        resetAllRecords(entityName: "ImagesDataInfo")
    }
    
    @IBAction func btnClearARviewAction(_ sender: UIButton) {
        startLoader()
        resetView()
        stopLoader()
    }
    
    //MARK:- Funtions
    func loadSnapshots()
    {
        startLoader()
        arrImages.removeAll()
        arrImages = delegate.arrImages
        if arrImages.count == 0
        {
            showAlert(message: "No snapshot has been saved")
        }
        for imgData in arrImages
        {
            //Adding snapshot to the ARView
            let snapshotObject = SCNPlane(width: sceneView.bounds.width / 6000 , height: sceneView.bounds.height / 6000)
            
            let  image = imgData.image
            snapshotObject.firstMaterial?.diffuse.contents = image
            snapshotObject.firstMaterial?.lightingModel = .constant
          
            cameraPosition = SCNVector3(imgData.xCamera,imgData.yCamera,imgData.zCamera)
            
            let snapshotNode = SCNNode (geometry: snapshotObject)
            snapshotNode.position = cameraPosition
            sceneView.scene.rootNode.addChildNode(snapshotNode)
            
            //Adding X-Dot to the ARView // Camera postion point
            let xNode = SCNNode(geometry: SCNSphere(radius: 0.002))
            xNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            xNode.position = cameraPosition
            sceneView.scene.rootNode.addChildNode(xNode)
            
            //Adding Z-Dot to the ARView // Object Postion
            objectPostion = SCNVector3(imgData.xObject,imgData.yObject,imgData.zObject)
            let zNode = SCNNode(geometry: SCNSphere(radius: 0.02))
            zNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            zNode.position = objectPostion
            sceneView.scene.rootNode.addChildNode(zNode)
        }
        stopLoader()
        showAlert(message: "\(arrImages.count) snapshots has been showed")
        
    }
    
    func saveImageData(image: UIImage, xCamera: Float, yCamera: Float, zCamera: Float, xObject: Float, yObject: Float, zObject: Float)
    {
        let managedObjectContex =  delegate.persistant.viewContext
        managedObjectContex.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
        let objectInfo = NSEntityDescription.insertNewObject(forEntityName: "ImagesDataInfo",into: managedObjectContex)
        if let imageData = image.jpegData(compressionQuality: 1) {
            
            
            objectInfo.setValue(imageData, forKey: "image")
            objectInfo.setValue(xCamera, forKey: "x_camera")
            objectInfo.setValue(yCamera, forKey: "y_camera")
            objectInfo.setValue(zCamera, forKey: "z_camera")
            
            objectInfo.setValue(xObject, forKey: "x_object")
            objectInfo.setValue(yObject, forKey: "y_object")
            objectInfo.setValue(zObject, forKey: "z_object")
        }
        
        do{
            try managedObjectContex.save()
            delegate.getData()
            print("dataSaved")
            self.showAlert(message: "Snapshot has been saved.")
        }catch{
            print("error")
            showAlert(message: "Something went wrong")
        }
    }
    
    func resetAllRecords(entityName : String)
    {
        startLoader()
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistant.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
            delegate.arrImages.removeAll()
            resetView()
        }
        catch
        {
            print ("There was an error")
            showAlert(message: "Error in deleting data")
        }
        stopLoader()
    }
    
    func resetView()
    {
        objectPostion = nil
        sceneView.scene.rootNode.enumerateChildNodes { (existingNode, _) in
            existingNode.removeFromParentNode()
        }
    }
}

extension ViewController: ARSessionDelegate{
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        // Do something with the new transform
        let currentTransform = frame.camera.transform
        
    
        if flagDotAdd{
            cameraPosition = SCNVector3(Float(currentTransform.columns.3.x), Float(currentTransform.columns.3.y), Float(currentTransform.columns.3.z))
            
            //Adding x-dot the ARView / Camera postion
            let xNode = SCNNode(geometry: SCNSphere(radius: 0.002))
            xNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            xNode.position = cameraPosition
            sceneView.scene.rootNode.addChildNode(xNode)
            
            //Adding z-dot the ARView / Object postion
            let zNode = SCNNode(geometry: SCNSphere(radius: 0.002))
            zNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            zNode.position = objectPostion
            sceneView.scene.rootNode.addChildNode(zNode)
            
            //Saving image and postions to the coredata
            self.saveImageData(image: snapshopt, xCamera: cameraPosition.x, yCamera: cameraPosition.y, zCamera: cameraPosition.z, xObject: objectPostion.x, yObject: objectPostion.y, zObject: objectPostion.z)
            
            flagDotAdd.toggle()
        }
    }
}
