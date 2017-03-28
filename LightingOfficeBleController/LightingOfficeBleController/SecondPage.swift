//
//  SecondPage.swift
//  LightingOfficeBleController
//
//  Created by lighting on 2017/3/14.
//  Copyright © 2017年 ROE. All rights reserved.
//

import UIKit
import CoreBluetooth

class SecondPage: UIViewController, UIPickerViewDelegate, CBPeripheralDelegate {

    enum SendDataError:Error {
        case CharacteristicNotFound
    }
    
    let GROUP_IDS = ["整合構裝2":0,
                    "光學工程":1,
                    "整合構裝1":2,
                    "電子工程1":3,
                    "電子工程2":4,
                    "品質管理":5,
                    "工程管理":6,
                    "中央走道":7,
                    "電控實驗室":8,
                    "光機實驗室":9,
                    "處長室":10,
                    "電子實驗室":11,
                    "副總室":12,
                    "特助室":13]
    
    var mCentralManager:CBCentralManager!
    var mConnectPeripheral:CBPeripheral!
    var mCharDictionary=[String:CBCharacteristic]()
    var mTargetDevice = ""
    var mGroupId = 0
    var mAddressId = 0
    
    @IBOutlet weak var mBrightnessControlPanel: UIView!
    @IBOutlet weak var mGroupAddressControlPanel: UIView!
    @IBOutlet weak var mUserQueryBrightness: UILabel!
    @IBOutlet weak var mUserSetBrightness: UILabel!
    @IBOutlet weak var mSelectedAreaKey: UILabel!
    @IBOutlet weak var mSelectedAreaValue: UILabel!
    @IBOutlet weak var mBrightnessSlider: UISlider!
    @IBOutlet weak var mNavigationBar: UINavigationBar!
    @IBOutlet weak var mPickerView: UIPickerView!
    @IBOutlet weak var mGroupAddressSegment: UISegmentedControl!
    @IBOutlet weak var mOnButton: UIButton!
    @IBOutlet weak var mOffButton: UIButton!
    @IBOutlet weak var mIncreaseBrightnessButton: UIButton!
    @IBOutlet weak var mDecreaseBrightnessButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mNavigationBar.topItem?.title = mTargetDevice
        mNavigationBar.backItem?.title = "Back"
        
        // Initial picker view
        mPickerView.delegate = self
        mPickerView.layer.borderColor = UIColor.black.cgColor
        mPickerView.layer.borderWidth = 1
        
        // Initial user set brightness label
        mBrightnessSlider.value = queryBrightness()
        mUserSetBrightness.text = String(Int(mBrightnessSlider.value))
        mUserQueryBrightness.text = ""
        mBrightnessControlPanel.layer.borderColor = UIColor.black.cgColor
        mBrightnessControlPanel.layer.borderWidth = 1
        
        // Initial group/address choosing section
        mSelectedAreaKey.text = "Group id::"
        mSelectedAreaValue.text = String(mGroupId)
        
        mGroupAddressControlPanel.layer.borderColor = UIColor.black.cgColor
        mGroupAddressControlPanel.layer.borderWidth = 1
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    func appMovedToBackground() {
        print("Second page get into background")
        dismiss(animated: true, completion: nil)
    }
    
    func queryBrightness() -> Float {
        let brightness = 0.0
        //TODO
        return Float(brightness)
    }
    
    // +Picker view
    
    // UIPickerView 有幾列可以選擇
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerView 各列有多少行資料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch mGroupAddressSegment.selectedSegmentIndex {
            case 0:
                return GROUP_IDS.count
            case 1:
                return 64 // 64 lights
            default:
                return 0
        }
    }
    
    // UIPickerView 每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch mGroupAddressSegment.selectedSegmentIndex {
            case 0:
                let groupKeys = Array(GROUP_IDS.keys)
                return String(groupKeys[row])
            case 1:
                return String(row)
            default:
                return ""
        }
    }
    
    // UIPickerView 改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch mGroupAddressSegment.selectedSegmentIndex {
        case 0:
            let groupKeys = Array(GROUP_IDS.keys)
            let key = groupKeys[row]
            mGroupId = GROUP_IDS[key]!
            mSelectedAreaKey.text = "Group id::"
            mSelectedAreaValue.text = String(mGroupId)
            print("PickerView selected group id = \(mGroupId)")
            break
        case 1:
            mAddressId = row
            mSelectedAreaKey.text = "Address id::"
            mSelectedAreaValue.text = String(mAddressId)
            print("PickerView selected address id = \(mAddressId)")
            break
        default:
            break
        }
    }
    // -Picker view

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func onClick(_ sender: Any) {
        var command:UInt16
        
        print("OnClick group id:\(mGroupId), address id:\(mAddressId)")
        if mGroupAddressSegment.selectedSegmentIndex == 0 {
            // power on command:0x1000+(0x80+id*2)+1
            command = UInt16(0x1000+(0x80+mGroupId*2)+1)
        } else {
            // power on command:0x1000+(id*2)+1
            command = UInt16(0x1000+(mAddressId*2)+1)
        }
        
        let commandData = NSData(bytes: &command, length: MemoryLayout<UInt16>.size)
        
        do {
            try sendData(commandData as Data, uuidString: "2A55", writeType: .withResponse)
        } catch {
            print(error)
        }
        
        mBrightnessSlider.value = 254
        mUserSetBrightness.text = "254"
    }

    @IBAction func offClick(_ sender: Any) {
        var command:UInt16
        
        print("OffClick group id:\(mGroupId), address id:\(mAddressId)")
        if mGroupAddressSegment.selectedSegmentIndex == 0 {
            command = UInt16(0x80+(mGroupId*2))
        } else {
            command = UInt16(mAddressId*2)
        }
        
        let commandData = NSData(bytes: &command, length: MemoryLayout<UInt16>.size)
        
        do {
            try sendData(commandData as Data, uuidString: "2A55", writeType: .withResponse)
        } catch {
            print(error)
        }
        
        mBrightnessSlider.value = 0
        mUserSetBrightness.text = "0"
    }
    
    @IBAction func groupAddressSwitch(_ sender: Any) {
        mPickerView.selectRow(0, inComponent: 0, animated: false)
        mGroupId = 0
        mAddressId = 0
        mPickerView.reloadAllComponents()
        
        if mGroupAddressSegment.selectedSegmentIndex == 0 {
            // Group
            mSelectedAreaKey.text = "Group id::"
            mSelectedAreaValue.text = String(mGroupId)
        } else {
            // Address
            mSelectedAreaKey.text = "Address id::"
            mSelectedAreaValue.text = String(mAddressId)
        }
    }
    
    
    @IBAction func backClick(_ sender: Any) {
        print("Second page on back clicked.")
        if mCentralManager != nil && mConnectPeripheral != nil {
            print("Second page disconnected.")
            let user = UserDefaults.standard
            user.removeObject(forKey: "KEY_PERIPHERAL_UUID")
            user.synchronize()
            mCentralManager.cancelPeripheralConnection(mConnectPeripheral)
            mCentralManager = nil
            mConnectPeripheral = nil
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onBrightnessBarValueChanged(_ sender: Any) {
        mUserSetBrightness.text = String(Int(mBrightnessSlider.value*254))
    }
    
    @IBAction func onBrightnessBarTouchUpInside(_ sender: Any) {
        var command:UInt16
        let brightness = Int(mBrightnessSlider.value*254)
        
        if mGroupAddressSegment.selectedSegmentIndex == 0 {
            //group:brightness*256+id*2+0x80
            command = UInt16(brightness*256+mGroupId*2+0x80)
        } else {
            //address:brightness*256+id*2
            command = UInt16(brightness*256+mAddressId*2)
        }
        
        let commandData = NSData(bytes: &command, length: MemoryLayout<UInt16>.size)
        
        do {
            try sendData(commandData as Data, uuidString: "2A55", writeType: .withResponse)
        } catch {
            print(error)
        }
    }
    
    @IBAction func onIncreaseBrightness(_ sender: Any) {
        var brightness = Int(mBrightnessSlider.value*254)+1
        if brightness > 254 {
            brightness = 254
        }
        print("brightness = \(brightness)")
        mBrightnessSlider.value = Float(brightness)/254
        print("mBrightnessSlider.value = \(mBrightnessSlider.value)")
        mUserSetBrightness.text = brightness.description
        
        // Write value
        var command:UInt16
        if mGroupAddressSegment.selectedSegmentIndex == 0 {
            //group:brightness*256+id*2+0x80
            command = UInt16(brightness*256+mGroupId*2+0x80)
        } else {
            //address:brightness*256+id*2
            command = UInt16(brightness*256+mAddressId*2)
        }
        
        let commandData = NSData(bytes: &command, length: MemoryLayout<UInt16>.size)
        
        do {
            try sendData(commandData as Data, uuidString: "2A55", writeType: .withResponse)
        } catch {
            print(error)
        }
    }
    
    @IBAction func onDecreaseBrightness(_ sender: Any) {
        var brightness = Int(mBrightnessSlider.value*254)-1
        if brightness < 0 {
            brightness = 0
        }
        print("brightness = \(brightness)")
        mBrightnessSlider.value = Float(brightness)/254
        print("mBrightnessSlider.value = \(mBrightnessSlider.value)")
        mUserSetBrightness.text = brightness.description
        
        // Write value
        var command:UInt16
        if mGroupAddressSegment.selectedSegmentIndex == 0 {
            //group:brightness*256+id*2+0x80
            command = UInt16(brightness*256+mGroupId*2+0x80)
        } else {
            //address:brightness*256+id*2
            command = UInt16(brightness*256+mAddressId*2)
        }
        
        let commandData = NSData(bytes: &command, length: MemoryLayout<UInt16>.size)
        
        do {
            try sendData(commandData as Data, uuidString: "2A55", writeType: .withResponse)
        } catch {
            print(error)
        }
    }
    
    @IBAction func queryBrightnessClick(_ sender: Any) {
        var command:UInt16
        
        print("Query brightness group id:\(mGroupId), address id:\(mAddressId)")
        if mGroupAddressSegment.selectedSegmentIndex == 0 {
            command = UInt16(0xA000+(0x80+mGroupId*2)+1)
        } else {
            command = UInt16(0xA000+(mAddressId*2)+1)
        }
        
        let commandData = NSData(bytes: &command, length: MemoryLayout<UInt16>.size)
        
        do {
            try sendData(commandData as Data, uuidString: "2A55", writeType: .withResponse)
        } catch {
            print(error)
        }
    }
    
    ////
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor:"+characteristic.uuid.uuidString)
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
