//
//  FirstViewController.swift
//  SimpleMapDirection
//
//  Created by Hiroki Ikeuchi on 2019/07/14.
//  Copyright © 2019 ikeh1024. All rights reserved.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var informationLabel: UILabel!
    
    // CLLocation Manager Variables For Getting Coordinate
    let locationManager = CLLocationManager() // GPS座標を与えるオブジェクト
    var location: CLLocation?                 // 現在地の情報
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getLocation()
        updateLabels()
    }
    
    // MARK:- Actions
    func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        locationManager.delegate        = self                                // 測定結果はdelegateで取得する
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // 10メートルの測定精度とする
        locationManager.startUpdatingLocation()                               // 計測開始
    }

    
    // MARK:- CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        location = newLocation
        updateLabels()
    }
    
    // MARK:- Helper Methods
    // 権限の取得に失敗したとき、ユーザへポップアップを表示する
    // TODO: 設定画面に遷移させるのは困難なのだろうか？
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable locaiton services for this app in Settings",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateLabels() {
        if let location = location {
            print(String(format: "緯度：%.8f 経度：%.8f",
                         location.coordinate.latitude,
                         location.coordinate.longitude))
            informationLabel.text = ""
        } else {
            informationLabel.text = "位置情報が取得できていません。"
        }
    }

    
}

