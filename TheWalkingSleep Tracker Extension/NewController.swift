//
//  InterfaceController.swift
//  TheWalkingSleep Tracker Extension
//
//  Created by Olivia Corrodi on 10/7/18.
//  Copyright © 2018 Olivia Corrodi. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import Alamofire
import CoreAudio
import AVFoundation
import Contacts

class NewController: WKInterfaceController {
    
    @IBOutlet var mainButton: WKInterfaceButton!
    @IBOutlet var sendMessageButton: WKInterfaceButton!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(InterfaceController.detectSteps), userInfo: nil, repeats: isGettingLocation )
        //sharedDefaults?.synchronize()
        //sharedDefaults?.set(false, forKey: "isGettingLocation")
        //sharedDefaults?.set(false, forKey: "isRinging")
        steps = detectSteps()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func didTapMainButton() {
    }
    @IBAction func sendMessage() {
    }
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var isGettingLocation = false
    var isRinging = false
    var avPlayer: AVAudioPlayer!
    var location = ""
    let pedoMeter = CMPedometer()
    let activityManager = CMMotionActivityManager()
    
    //
    //MARK: - Emoji Properties
    let sunEmoji = "☀️"
    let moonEmoji = "🌙"
    let clockEmoji = "⏰"
    let tiffanyColor = UIColor(red: 82/255, green: 225/255, blue: 192/255, alpha: 1)
    let navyColor = UIColor(red: 41/255, green: 22/255, blue: 172/255, alpha: 1)
    let darkGrayColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1)
    let lightGrayColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
    
    //MARK: - IBOutlet Properties
    
    var steps = 0
    
    //let sharedDefaults = UserDefaults(suiteName: "group.TheWalkingSleep")
    
    
    
    
    //MARK: - Help button related functions
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> CLPlacemark{
        var loc = CLPlacemark()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if error != nil{
                print(error as Any)
            } else if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                //self.sharedDefaults?.setValue(pm, forKey: "location")
                loc = pm
                //let address = ABCreateStringWithAddressDictionary(pm.addressDictionary!, false)
                //self.location = address
            }
            
            //sharedDefaults.setValue(trimmed, forKey: "location")
            
        }
        return loc
    }
    
    
    
    @IBAction func getHelpButtonTapped(_ sender: WKInterfaceButton) {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        location = getLocation(manager: locationManager)
        //getLocation(manager: locationManager)
        let contact = "Joe Smith"
        let name = "Bob Wilson"
        let parameters: Parameters = [
            "To": "6099554578" ?? "",
            "Body": "Hey \(contact), \(name) has sleepwalked and needs your help! Find them at \(location)"
        ]
        
        Alamofire.request("https://onyx-dalmatian-2821.twil.io/thewalkingsleep", method: .post, parameters: parameters, headers: headers).response { response in
            print(response)
            
        }
        //let location = getLocation(manager: locationManager)
        //reverseGeocoding(latitude: location.latitude, longitude: location.longitude)
    }
    
    
    func reloadTimer() {
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(InterfaceController.detectSteps), userInfo: nil, repeats: isGettingLocation )
    }
    
    
    
    //MARK: - Location related functions + Buttons
    
    @IBAction func mainButtonTapped(_ sender: WKInterfaceButton) {
        print(isGettingLocation)
        if isGettingLocation == true{
            isGettingLocation = false
            //sharedDefaults?.set(false, forKey: "isGettingLocation")
            avPlayer?.stop()
            avPlayer?.pause()
            isRinging = false
            mainButton.setAttributedTitle(NSAttributedString(string: sunEmoji))
            
        } else {
            isGettingLocation = true
            // sharedDefaults?.set(true, forKey: "isGettingLocation")
            self.reloadTimer()
            avPlayer?.stop()
            avPlayer?.pause()
            mainButton.setAttributedTitle(NSAttributedString(string: moonEmoji))
            
        }
        if isRinging{
            avPlayer?.stop()
            avPlayer?.pause()
            isRinging = false
            //sharedDefaults?.set(false, forKey: "isRinging")
            isGettingLocation = false
            
            mainButton.setAttributedTitle(NSAttributedString(string: sunEmoji))
        }
        
        
    }
    
    //MARK: - Wake up and get location functions
    
    func wakeUp() {
        if isGettingLocation {
            if let urlpath = Bundle.main.path(forResource: "alarmNoise",ofType: "wav") {
                //let url = NSURL.fileURL(withPath: urlpath!)
                let url = URL(fileURLWithPath: urlpath)
                //var audioPlayer = AVAudioPlayer()
                
                do{
                    //let sleepHeaviness = sharedDefaults.float(forKey: "sleepHeaviness")
                    //let volumeView = MPVolumeView()
                    //if let view = volumeView.subviews.first as? UISlider{
                    //view.value = sleepHeaviness
                    //}
                    avPlayer = try AVAudioPlayer(contentsOf: url)
                    avPlayer.prepareToPlay()
                    avPlayer.play()
                    mainButton.setAttributedTitle(NSAttributedString(string: clockEmoji))
                    isRinging = true
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getLocation(manager: CLLocationManager) -> String {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let pm = reverseGeocoding(latitude: locValue.latitude, longitude: locValue.longitude)
        var style =  CNPostalAddressFormatterStyle(rawValue: 0)
        let newVal = CNPostalAddressFormatter.string(from: pm.postalAddress!, style: style!)
        return newVal
    }
    
    //MARK: - Step detection function
    
    @objc func detectSteps() -> Int{
        var loc = getLocation(manager: locationManager)
        if(CMPedometer.isStepCountingAvailable()){
            //            print(self.steps)
            let move = 8
            if self.steps >= move {
                wakeUp()
            }
            self.steps = 0
            let startTime = Date() as NSDate
            self.pedoMeter.queryPedometerData(from: startTime as Date, to: NSDate() as Date) { (data : CMPedometerData!, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        self.steps = Int(data.numberOfSteps)
                    }
                })
                self.pedoMeter.startUpdates(from: startTime as Date) { (data: CMPedometerData!, error) -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        if(error == nil){
                            self.steps = Int(data.numberOfSteps)
                        }
                    })
                }
            }
        }
        return self.steps
    }
}

