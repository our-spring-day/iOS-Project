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

    var button : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("FLY", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.red, for: .selected)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(go), for: .touchUpInside)
        return button
    }()
    var authState: NMFAuthState!
    var cameraUpdate : NMFCameraUpdate?
    var nmapFView : NMFMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView!.addCameraDelegate(delegate: self)
        view.addSubview(nmapFView!)
        view.addSubview(button)
        buttonAutolayout()

        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        marker.mapView = nmapFView

    }

    func buttonAutolayout(){
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func go(){
        cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.5670135, lng: 126.9783740))
        cameraUpdate!.animation = .fly
        cameraUpdate!.animationDuration = 1.5
        nmapFView!.moveCamera(cameraUpdate!)
    }
}

extension ViewController : NMFMapViewCameraDelegate{
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            print(self.nmapFView!.cameraPosition.target)
        }
        
    }
}
