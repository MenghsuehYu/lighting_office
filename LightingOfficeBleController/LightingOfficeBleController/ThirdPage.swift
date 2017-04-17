//
//  ThirdPage.swift
//  LightingOfficeBleController
//
//  Created by lighting on 2017/3/20.
//  Copyright © 2017年 ROE. All rights reserved.
//

import UIKit
import CoreBluetooth

class ThirdPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum SendDataError:Error {
        case CharacteristicNotFound
    }
    
    let SCENE_IDS = ["全部關閉",
                     "最亮",
                     "投影",
                     "白板",
                     "討論",
                     "節能",
                     "Scene6",
                     "Scene7",
                     "Scene8",
                     "Scene9",
                     "Scene10",
                     "Scene11",
                     "Scene12",
                     "Scene13",
                     "Scene14",
                     "Scene15"]
    
    var mCentralManager:CBCentralManager!
    var mConnectPeripheral:CBPeripheral!
    var mCharDictionary=[String:CBCharacteristic]()
    var mTargetDevice = ""
    var mSelectedScene = ""
    
    @IBOutlet weak var mNavigationBar: UINavigationBar!
    @IBOutlet weak var mSceneList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mNavigationBar.topItem?.title = mTargetDevice
        mNavigationBar.backItem?.title = "Back"
        
        mSceneList.dataSource = self
        mSceneList.delegate = self
        mSceneList.allowsSelection = true
        
        // Cancel bluetooth connection when app go into background
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    func appMovedToBackground() {
        NSLog("ThirdPage, get into background.")
        dismiss(animated: true, completion: nil)
    }

    //+ Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SCENE_IDS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellForScene
        
        cell.mTitle.text = SCENE_IDS[indexPath.row]
        
        if mSelectedScene == cell.mTitle.text {
            cell.mSwitch.setOn(true, animated: false)
        } else {
            cell.mSwitch.setOn(false, animated: false)
        }
        
        if cell.mTitle.text == "投影" {
            cell.mIcon.image = #imageLiteral(resourceName: "projection2")
        } else if cell.mTitle.text == "白板" {
            cell.mIcon.image = #imageLiteral(resourceName: "whiteboard")
        } else if cell.mTitle.text == "討論" {
            cell.mIcon.image = #imageLiteral(resourceName: "meeting")
        } else if cell.mTitle.text == "節能" {
            cell.mIcon.image = #imageLiteral(resourceName: "savepower")
        } else if cell.mTitle.text == "最亮" {
            cell.mIcon.image = #imageLiteral(resourceName: "powerOn")
        } else if cell.mTitle.text == "全部關閉" {
            cell.mIcon.image = #imageLiteral(resourceName: "powerOff")
        } else {
            cell.mIcon.image = #imageLiteral(resourceName: "radiantlogo_bs")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var command:UInt16 = 0
        mSelectedScene = SCENE_IDS[indexPath.row]
        NSLog("ThirdPage, selected scene = " + mSelectedScene)
        
        tableView.reloadData()
        
        if mSelectedScene == "全部關閉" {
            command = 0xfe
        } else if mSelectedScene == "最亮" {
            command = 0x10ff
        } else if mSelectedScene == "投影" {
            command = 0x12FF
        } else if mSelectedScene == "白板" {
            command = 0x14FF
        } else if mSelectedScene == "討論" {
            command = 0x13FF
        } else if mSelectedScene == "節能" {
            command = 0x15FF
        } else if mSelectedScene == "Scene6" {
            command = 0x16FF
        } else if mSelectedScene == "Scene7" {
            command = 0x17FF
        } else if mSelectedScene == "Scene8" {
            command = 0x18FF
        } else if mSelectedScene == "Scene9" {
            command = 0x19FF
        } else if mSelectedScene == "Scene10" {
            command = 0x1AFF
        } else if mSelectedScene == "Scene11" {
            command = 0x1BFF
        } else if mSelectedScene == "Scene12" {
            command = 0x1CFF
        } else if mSelectedScene == "Scene13" {
            command = 0x1DFF
        } else if mSelectedScene == "Scene14" {
            command = 0x1EFF
        } else if mSelectedScene == "Scene15" {
            command = 0x1FFF
        }
        
        let commandData = NSData(bytes: &command, length: MemoryLayout<UInt16>.size)
        
        do {
            try sendData(commandData as Data, uuidString: "2A55", writeType: .withResponse)
        } catch {
            NSLog("ThirdPage, tableView didSelect() error:\(error)")
        }
    }
    //- Table view
    
    @IBAction func backClick(_ sender: Any) {
        NSLog("ThirdPage, on back clicked.")
        if mCentralManager != nil && mConnectPeripheral != nil {
            NSLog("ThirdPage, disconnected.")
            let user = UserDefaults.standard
            user.removeObject(forKey: "KEY_PERIPHERAL_UUID")
            user.synchronize()
            mCentralManager.cancelPeripheralConnection(mConnectPeripheral)
            mCentralManager = nil
            mConnectPeripheral = nil
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func sendData(_ data: Data, uuidString:String, writeType: CBCharacteristicWriteType) throws {
        guard let characteristic = mCharDictionary[uuidString] else {
            throw SendDataError.CharacteristicNotFound
        }
        
        mConnectPeripheral.writeValue(
            data,
            for: characteristic,
            type: writeType
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
