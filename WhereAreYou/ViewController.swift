//
//  ViewController.swift
//  WhereAreYou
//
//  Created by once on 2020/05/02.
//  Copyright © 2020 once. All rights reserved.
//

import UIKit
import NMapsMap

class ViewController: UIViewController {

    var authState: NMFAuthState!
    var cameraUpdate : NMFCameraUpdate?
    var nmapFView : NMFMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nmapFView = NMFMapView(frame: view.frame)
        view.addSubview(nmapFView!)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.5670135, lng: 126.9783740))
        cameraUpdate!.animation = .fly
        cameraUpdate!.animationDuration = 3
        nmapFView!.moveCamera(cameraUpdate!)
        
    }


}

