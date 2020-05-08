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
    var testNavigate = [NMGLatLng(lat: 37.551285, lng: 126.9783740),
                        NMGLatLng(lat: 37.55136754128709, lng: 126.9784515070905),
                        NMGLatLng(lat: 37.55142537486709, lng: 126.9785208075845),
                        NMGLatLng(lat: 37.55147597919224, lng: 126.9785727829346),
                        NMGLatLng(lat: 37.55152586057785, lng: 126.9786211109039),
                        NMGLatLng(lat: 37.5515591148032, lng: 126.9786986180341),
                        NMGLatLng(lat: 37.55159092320107, lng: 126.9787898028502),
                        NMGLatLng(lat: 37.55166393786804, lng: 126.9788472492922),
                        NMGLatLng(lat: 37.55173767536853, lng: 126.9787989213209),
                        NMGLatLng(lat: 37.55183382316547, lng: 126.978715943144),
                        NMGLatLng(lat: 37.55189599387392, lng: 126.9786557611573),
                        NMGLatLng(lat: 37.55196105617537, lng: 126.9786092568978),
                        NMGLatLng(lat: 37.55203117883683, lng: 126.9785308379779),
                        NMGLatLng(lat: 37.55211142218821, lng: 126.9784761270822),
                        NMGLatLng(lat: 37.55222491938297, lng: 126.9783876777727),
                        NMGLatLng(lat: 37.55231745198652, lng: 126.9783785593045),
                        NMGLatLng(lat: 37.55240275538898, lng: 126.9784870692155),
                        NMGLatLng(lat: 37.55246857692355, lng: 126.9785965095607),
                        NMGLatLng(lat: 37.55252424089148, lng: 126.9786721929773),
                        NMGLatLng(lat: 37.55258279647291, lng: 126.9787442290184),
                        NMGLatLng(lat: 37.55264713527765, lng: 126.9788445323396),
                        NMGLatLng(lat: 37.55272376345278, lng: 126.9789302460638),
                        NMGLatLng(lat: 37.55276135458244, lng: 126.9790114005307),
                        NMGLatLng(lat: 37.55288280275648, lng: 126.9789521303796),
                        NMGLatLng(lat: 37.55294424969593, lng: 126.9789156564221),
                        NMGLatLng(lat: 37.55308377014323, lng: 126.9788190005216),
                        NMGLatLng(lat: 37.55314738562506, lng: 126.9787506119008),
                        NMGLatLng(lat: 37.55324280871241, lng: 126.9786685455599),
    ]
    var simulationFlag = 0
    var overlayAlphaFlag = 0
    var authState: NMFAuthState!
    var cameraUpdate = NMFCameraUpdate()
    var nmapFView = NMFMapView()
    var task : DispatchWorkItem?
    var addressText = UILabel()
    var overlay = UIImageView()
    var simaulationMarker = NMFMarker()
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
    var simulationButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("simulation", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.red, for: .selected)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(simulation), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        createMapView()
        createImageView()
        createAddressLabel()
        buttonAutolayout()
        simulationButtonAutolayout()
        simaulationMarker.position = NMGLatLng(lat: 37.551285, lng: 126.9783740)
        simaulationMarker.mapView = nmapFView
    }
    //좌표찍힐라벨(addressText)생성함수
    func createAddressLabel() {
        addressText = UILabel()
        self.view.addSubview(addressText)
        addressText.backgroundColor = .blue
        addressText.textColor = .white
        addressText.translatesAutoresizingMaskIntoConstraints = false
        addressText.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addressText.widthAnchor.constraint(equalToConstant: 200).isActive = true
        addressText.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        addressText.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    //맵뷰(nmapFView)생성함수
    func createMapView() {
        nmapFView = NMFMapView(frame: view.frame)
        nmapFView.addCameraDelegate(delegate: self)
        view.addSubview(nmapFView)
    }
    //핀(imageView)생성함수
    func createImageView() {
        //하드로 고정해놓았기때문에 후에 화면중앙에 핀의 꼭짓점이 정확히 찍히는 방법 구상해야됨
        self.view.addSubview(overlay)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.heightAnchor.constraint(equalToConstant: 50).isActive = true
        overlay.widthAnchor.constraint(equalToConstant: 35).isActive = true
        overlay.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        overlay.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -27).isActive = true
        overlay.image = UIImage(named:"testmarker")
    }
    func buttonAutolayout(){
        view.addSubview(button)
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    func simulationButtonAutolayout(){
        view.addSubview(simulationButton)
        simulationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150).isActive = true
        simulationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150).isActive = true
        simulationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        simulationButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    @objc func go(){
        overlayAlphaFlag = 0
        cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.5670135, lng: 126.9783740))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.5
        nmapFView.moveCamera(cameraUpdate)
    }
    //taskToSimulation을 하드로 넣어놓은 배열이 끝날때까지 재귀
    func repeatSimulation() {
        if simulationFlag <= testNavigate.count - 1 {
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.taskToSimulation(i: self.testNavigate[self.simulationFlag])
                group.leave()
                self.simulationFlag += 1
            }
            group.notify(queue: .main) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.taskToSimulation(i: self.testNavigate[self.simulationFlag])
                    self.simulationFlag += 1
                    self.repeatSimulation()
                }
            }
        }
        else{
            simulationFlag = 0
        }
    }
    //i로 넘어온 좌표값으로 마커 찍고 카메라 이동함
    @objc func taskToSimulation(i : NMGLatLng){
        simaulationMarker.position = i
        simaulationMarker.mapView = self.nmapFView
        cameraUpdate = NMFCameraUpdate(scrollTo: i)
        cameraUpdate.animation = .easeOut
        cameraUpdate.animationDuration = 1
        nmapFView.zoomLevel = 17
        nmapFView.moveCamera(cameraUpdate)
    }
    //simulation 버튼을 눌렀을때 임의로 설정한 좌표에 마커찍고 케메라 이동하고 repeatSimulation 호출
    @objc func simulation(){
        simaulationMarker.position = NMGLatLng(lat: 37.551285, lng: 126.9783740)
        simaulationMarker.mapView = nmapFView
        overlayAlphaFlag = 1
        overlay.alpha = 0
        cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.551285, lng: 126.9783740))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        nmapFView.zoomLevel = 17
        nmapFView.moveCamera(cameraUpdate)
        repeatSimulation()
    }
}
extension ViewController : NMFMapViewCameraDelegate{
    //카메라의 움직임이끝났을때
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        if overlayAlphaFlag == 0 {
            //1초뒤에 task를 실행
            task = DispatchWorkItem {
                //핀 알파값 원래대로
                self.overlay.alpha = 1
                //카메라포지션을 저장해줌(보기에편하게)
                let position = self.nmapFView.cameraPosition
                //카메라포지션의 좌표값을 스트링으로 변환후 addressText 띄우줌
                self.addressText.text = String(format: "%f",position.target.lat, position.target.lng)
                //이건 후에 api 쏠때 필요한 코드여서 그냥 남겨둠
                print(self.nmapFView.cameraPosition.target)
                //애니메이션의 시간은 0.25초 y 10 이동
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.overlay.transform = CGAffineTransform(translationX: 0, y: 10)
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8,execute: task!)
        }
    }
    //카메라가 움직일때
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool){
        if overlayAlphaFlag == 0 {
            //task를 취소
            task?.cancel()
            //핀 알파값 조정
            overlay.alpha = 0.5
            //애니메이션의 시간은 0.25초, y -10 이동
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.overlay.transform = CGAffineTransform(translationX: 0, y: -10)
            })
        }
    }
}
