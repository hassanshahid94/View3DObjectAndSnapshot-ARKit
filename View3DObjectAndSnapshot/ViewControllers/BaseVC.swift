//
//  BaseVC.swift
//  View3DObjectAndSnapshot
//
//  Created by Hassan on 19.9.2020.
//

import UIKit
import RappleProgressHUD

struct ImagesData {
    var image = UIImage()
    var xCamera = Float()
    var yCamera = Float()
    var zCamera = Float()
    var xObject = Float()
    var yObject = Float()
    var zObject = Float()
}

class BaseVC: UIViewController {

    //MARK:- Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Functions
    func startLoader() {
        RappleActivityIndicatorView.startAnimating(attributes: RappleModernAttributes)
    }
    
    func stopLoader() {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    func showAlert(message: String)
    {
        let alert = UIAlertController(title: "ARKit", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
