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
    var addressString : String?
    var addressText : UILabel?
    var imageView : UIImageView?
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
    var task : DispatchWorkItem?
    var markerForCenter : NMFMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMapView()
        buttonAutolayout()
        createImageView()
        createAddressLabel()
    }
    //좌표찍힐라벨(addressText)생성함수
    func createAddressLabel() {
        addressText = UILabel()
        self.view.addSubview(addressText!)
        addressText!.backgroundColor = .blue
        addressText!.textColor = .white
        addressText!.translatesAutoresizingMaskIntoConstraints = false
        addressText!.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addressText!.widthAnchor.constraint(equalToConstant: 200).isActive = true
        addressText!.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        addressText!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    //맵뷰(nmapFView)생성함수
    func createMapView() {
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView!.addCameraDelegate(delegate: self)
        view.addSubview(nmapFView!)
    }
    //핀(imageView)생성함수
    func createImageView() {
        //하드로 고정해놓았기때문에 후에 화면중앙에 핀의 꼭짓점이 정확히 찍히는 방법 구상해야됨
        imageView  = UIImageView()
        self.view.addSubview(imageView!)
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView!.widthAnchor.constraint(equalToConstant: 35).isActive = true
        imageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        imageView!.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -27).isActive = true
        imageView!.image = UIImage(named:"testmarker")
    }
    func buttonAutolayout(){
        view.addSubview(button)
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
    //카메라의 움직임이끝났을때
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        //1초뒤에 task를 실행
        task = DispatchWorkItem {
            //핀 알파값 원래대로
            self.imageView?.alpha = 1
            //카메라포지션을 저장해줌(보기에편하게)
            let position = self.nmapFView!.cameraPosition
            //카메라포지션의 좌표값을 스트링으로 변환후 addressText 띄우줌
            self.addressText!.text = String(format: "%f",position.target.lat, position.target.lng)
            //이건 후에 api 쏠때 필요한 코드여서 그냥 남겨둠
            print(self.nmapFView!.cameraPosition.target)
            //애니메이션의 시간은 0.25초 y 10 이동
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.imageView!.transform = CGAffineTransform(translationX: 0, y: 10)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8,execute: task!)
    }
    //카메라가 움직일때
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool){
        //task를 취소
        task?.cancel()
        //핀 알파값 조정
        imageView?.alpha = 0.5
        //애니메이션의 시간은 0.25초, y -10 이동
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.imageView!.transform = CGAffineTransform(translationX: 0, y: -10)
        })
    }
}
