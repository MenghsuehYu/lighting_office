//
//  ViewController.swift
//  OfficeLightingManager
//
//  Created by lighting on 2017/2/6.
//  Copyright © 2017年 ROE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let LIGHTSTAG:[String:Int] = ["aisle":7,
                                  "director":10,
                                  "ee_lab":11,
                                  "ee1":3,
                                  "ee2":4,
                                  "qe":5,
                                  "pm":6,
                                  "sa":13,
                                  "vp":12,
                                  "om_lab":9,
                                  "ce_lab":8,
                                  "op":1,
                                  "me1":2,
                                  "me2":0]
    
    var mBrightnessValue = 0
    var mLights:[Int] = []
    @IBOutlet weak var oSaButton: UIButton!
    @IBOutlet weak var oVpButton: UIButton!
    @IBOutlet weak var oPmButton: UIButton!
    @IBOutlet weak var oQeButton: UIButton!
    @IBOutlet weak var oEe1Button: UIButton!
    @IBOutlet weak var oEe2Button: UIButton!
    @IBOutlet weak var oEeLabButton: UIButton!
    @IBOutlet weak var oDirectorButton: UIButton!
    @IBOutlet weak var oAisleButton: UIButton!
    @IBOutlet weak var oOmLabButton: UIButton!
    @IBOutlet weak var oCeLabButton: UIButton!
    @IBOutlet weak var oMe1Button: UIButton!
    @IBOutlet weak var oMe2Button: UIButton!
    @IBOutlet weak var oOpButton: UIButton!
    @IBOutlet weak var oSelectAllButton: UIButton!
    @IBOutlet weak var oConf2Button: UIButton!
    @IBOutlet weak var oConf3Button: UIButton!
    @IBOutlet weak var oOnButton: UIButton!
    @IBOutlet weak var oOffButton: UIButton!
    @IBOutlet weak var oBrightnessLabel: UILabel!
    @IBOutlet weak var oBrightnessSlider: UISlider!
    @IBOutlet weak var oBlankArea: UIView!
    @IBOutlet weak var oOfficeLightingManagerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initial()
    }
    
    @IBAction func aBrightnessSlider(_ sender: Any) {
        mBrightnessValue = Int(oBrightnessSlider.value * 254)
        oBrightnessLabel.text = mBrightnessValue.description
        for item in mLights {
            sendCommand(address:String(0x80+item*2), command:mBrightnessValue.description, group:item)
        }
    }
    
    @IBAction func aOnButton(_ sender: Any) {
        print("Turn on:")
        for item in mLights {
            sendCommand(address:String(0x80+item*2+1), command:String(0x10), group:item)
        }
    }

    @IBAction func aOffButton(_ sender: Any) {
        print("Turn off:")
        for item in mLights {
            sendCommand(address:String(0x80+item*2), command:String(0), group:item)
        }
    }
    
    @IBAction func aAisleButton(_ sender: Any) {
        mLights = []
        if oAisleButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oAisleButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oAisleButton)
            if !mLights.contains(LIGHTSTAG["aisle"]!) {
                mLights.append(LIGHTSTAG["aisle"]!)
            }
        }
    }
    
    @IBAction func aDirectorButton(_ sender: Any) {
        mLights = []
        if oDirectorButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oDirectorButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oDirectorButton)
            if !mLights.contains(LIGHTSTAG["director"]!) {
                mLights.append(LIGHTSTAG["director"]!)
            }
        }
    }
    
    @IBAction func aEeLabButton(_ sender: Any) {
        //Ignore it.
        /*mLights = []
        if oEeLabButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oEeLabButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oEeLabButton)
            if !mLights.contains(LIGHTSTAG["ee_lab"]!) {
                mLights.append(LIGHTSTAG["ee_lab"]!)
            }
        }*/
    }
    
    @IBAction func aEe2Button(_ sender: Any) {
        mLights = []
        if oEe2Button.layer.backgroundColor == UIColor.yellow.cgColor {
            oEe2Button.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oEe2Button)
            if !mLights.contains(LIGHTSTAG["ee2"]!) {
                mLights.append(LIGHTSTAG["ee2"]!)
            }
        }
    }
    
    @IBAction func aEe1Button(_ sender: Any) {
        mLights = []
        if oEe1Button.layer.backgroundColor == UIColor.yellow.cgColor {
            oEe1Button.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oEe1Button)
            if !mLights.contains(LIGHTSTAG["ee1"]!) {
                mLights.append(LIGHTSTAG["ee1"]!)
            }
        }
    }
    
    @IBAction func aQeButton(_ sender: Any) {
        mLights = []
        if oQeButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oQeButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oQeButton)
            if !mLights.contains(LIGHTSTAG["qe"]!) {
                mLights.append(LIGHTSTAG["qe"]!)
            }
        }
    }
    
    @IBAction func aPmButton(_ sender: Any) {
        mLights = []
        if oPmButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oPmButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oPmButton)
            if !mLights.contains(LIGHTSTAG["pm"]!) {
                mLights.append(LIGHTSTAG["pm"]!)
            }
        }
    }
    
    @IBAction func aSaButton(_ sender: Any) {
        mLights = []
        if oSaButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oSaButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oSaButton)
            if !mLights.contains(LIGHTSTAG["sa"]!) {
                mLights.append(LIGHTSTAG["sa"]!)
            }
        }
    }
    
    @IBAction func aVpButton(_ sender: Any) {
        //Ignore it.
        /*mLights = []
        if oVpButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oVpButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oVpButton)
            if !mLights.contains(LIGHTSTAG["vp"]!) {
                mLights.append(LIGHTSTAG["vp"]!)
            }
        }*/
    }
    
    @IBAction func aOmLabButton(_ sender: Any) {
        mLights = []
        if oOmLabButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oOmLabButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oOmLabButton)
            if !mLights.contains(LIGHTSTAG["om_lab"]!) {
                mLights.append(LIGHTSTAG["om_lab"]!)
            }
        }
    }
    
    @IBAction func aCeLabButton(_ sender: Any) {
        mLights = []
        if oCeLabButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oCeLabButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oCeLabButton)
            if !mLights.contains(LIGHTSTAG["ce_lab"]!) {
                mLights.append(LIGHTSTAG["ce_lab"]!)
            }
        }
    }
    
    @IBAction func aOpButton(_ sender: Any) {
        mLights = []
        if oOpButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oOpButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oOpButton)
            if !mLights.contains(LIGHTSTAG["op"]!) {
                mLights.append(LIGHTSTAG["op"]!)
            }
        }
    }
    
    @IBAction func aMe1Button(_ sender: Any) {
        mLights = []
        if oMe1Button.layer.backgroundColor == UIColor.yellow.cgColor {
            oMe1Button.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oMe1Button)
            if !mLights.contains(LIGHTSTAG["me1"]!) {
                mLights.append(LIGHTSTAG["me1"]!)
            }
        }
    }
    
    @IBAction func aMe2Button(_ sender: Any) {
        mLights = []
        if oMe2Button.layer.backgroundColor == UIColor.yellow.cgColor {
            oMe2Button.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oMe2Button)
            if !mLights.contains(LIGHTSTAG["me2"]!) {
                mLights.append(LIGHTSTAG["me2"]!)
            }
        }
    }
    
    @IBAction func aSelectAllButton(_ sender: Any) {
        mLights = []
        if oSelectAllButton.layer.backgroundColor == UIColor.yellow.cgColor {
            oSelectAllButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            clearButtonColor(ignore: oSelectAllButton)
            for item in LIGHTSTAG.keys {
                if !mLights.contains(LIGHTSTAG[item]!) {
                    mLights.append(LIGHTSTAG[item]!)
                }
            }
        }
    }
    
    func initial() {
        mBrightnessValue = Int(oBrightnessSlider.value * 254)
        oBrightnessLabel.text = mBrightnessValue.description
        
//        oOnButton.layer.cornerRadius = 20
//        oOnButton.layer.borderWidth = 5
//        oOnButton.layer.borderColor = UIColor.black.cgColor
//        
//        oOffButton.layer.cornerRadius = 20
//        oOffButton.layer.borderWidth = 5
//        oOffButton.layer.borderColor = UIColor.black.cgColor
//        
//        oSelectAllButton.layer.cornerRadius = 20
//        oSelectAllButton.layer.borderWidth = 5
//        oSelectAllButton.layer.borderColor = UIColor.black.cgColor
        
        oOfficeLightingManagerLabel.layer.cornerRadius = 20
        oOfficeLightingManagerLabel.layer.borderWidth = 5
        oOfficeLightingManagerLabel.layer.borderColor = UIColor.black.cgColor
        
        oVpButton.layer.borderWidth = 3
        oVpButton.layer.borderColor = UIColor.black.cgColor
        
        oSaButton.layer.borderWidth = 3
        oSaButton.layer.borderColor = UIColor.black.cgColor
        
        oPmButton.layer.borderWidth = 3
        oPmButton.layer.borderColor = UIColor.black.cgColor
        
        oQeButton.layer.borderWidth = 3
        oQeButton.layer.borderColor = UIColor.black.cgColor
        
        oEe1Button.layer.borderWidth = 3
        oEe1Button.layer.borderColor = UIColor.black.cgColor
        
        oEe2Button.layer.borderWidth = 3
        oEe2Button.layer.borderColor = UIColor.black.cgColor
        
        oEeLabButton.layer.borderWidth = 3
        oEeLabButton.layer.borderColor = UIColor.black.cgColor
        
        oDirectorButton.layer.borderWidth = 3
        oDirectorButton.layer.borderColor = UIColor.black.cgColor
        
        oAisleButton.layer.borderWidth = 3
        oAisleButton.layer.borderColor = UIColor.black.cgColor
        
        oOmLabButton.layer.borderWidth = 3
        oOmLabButton.layer.borderColor = UIColor.black.cgColor
        
        oCeLabButton.layer.borderWidth = 3
        oCeLabButton.layer.borderColor = UIColor.black.cgColor
        
        oMe1Button.layer.borderWidth = 3
        oMe1Button.layer.borderColor = UIColor.black.cgColor
        
        oOpButton.layer.borderWidth = 3
        oOpButton.layer.borderColor = UIColor.black.cgColor
        
        oMe2Button.layer.borderWidth = 3
        oMe2Button.layer.borderColor = UIColor.black.cgColor
        
        oConf2Button.layer.borderWidth = 3
        oConf2Button.layer.borderColor = UIColor.black.cgColor
        
        oConf3Button.layer.borderWidth = 3
        oConf3Button.layer.borderColor = UIColor.black.cgColor
        
        oBlankArea.layer.borderWidth = 3
        oBlankArea.layer.borderColor = UIColor.black.cgColor
    }
    
    func clearButtonColor(ignore:UIButton) {
        //oVpButton.layer.backgroundColor = UIColor.white.cgColor
        oSaButton.layer.backgroundColor = UIColor.white.cgColor
        oPmButton.layer.backgroundColor = UIColor.white.cgColor
        oQeButton.layer.backgroundColor = UIColor.white.cgColor
        oEe1Button.layer.backgroundColor = UIColor.white.cgColor
        oEe2Button.layer.backgroundColor = UIColor.white.cgColor
        //oEeLabButton.layer.backgroundColor = UIColor.white.cgColor
        oDirectorButton.layer.backgroundColor = UIColor.white.cgColor
        oAisleButton.layer.backgroundColor = UIColor.white.cgColor
        oOmLabButton.layer.backgroundColor = UIColor.white.cgColor
        oCeLabButton.layer.backgroundColor = UIColor.white.cgColor
        oMe1Button.layer.backgroundColor = UIColor.white.cgColor
        oOpButton.layer.backgroundColor = UIColor.white.cgColor
        oMe2Button.layer.backgroundColor = UIColor.white.cgColor
        oSelectAllButton.layer.backgroundColor = UIColor.white.cgColor
        ignore.layer.backgroundColor = UIColor.yellow.cgColor
    }
    
    func sendCommand(address:String, command:String, group:Int) {
        //Perform post action.
        var request = URLRequest(url: URL(string: "http://10.1.33.151/send_com_app.php")!)
        request.httpMethod = "POST"
        
        var postString = "dali_net_amount=2&dali_net_type=0&dali_net_cmds1="+address+"&dali_net_cmds2="+command
        
        request.httpBody = postString.data(using: .utf8)
        let task_post = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task_post.resume()
        
        //Perform post log action.
        request = URLRequest(url: URL(string: "http://10.1.33.151/log.php")!)
        request.httpMethod = "POST"
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let time = formatter.string(from: currentDateTime)
        
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        let time_s = formatter.string(from: currentDateTime)
        
        postString = "name=Wall_Switch&email=ROE_Lighting@radiant.com.tw&command="+command+"&addres="+address+"&time="+time+"&time_s="+time_s+"&lamp=-1&group="+String(group)+"&dali_number=1"
        
        request.httpBody = postString.data(using: .utf8)
        let task_post_log = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task_post_log.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

