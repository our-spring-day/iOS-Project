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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
    }


}

