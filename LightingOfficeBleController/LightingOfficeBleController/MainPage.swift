//
//  MainPage.swift
//  LightingOfficeBleController
//
//  Created by lighting on 2017/3/14.
//  Copyright © 2017年 ROE. All rights reserved.
//

import UIKit
import CoreBluetooth

class MainPage: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource {

    enum SendDataError:Error {
        case CharacteristicNotFound
    }
    
    let DEVICE_NAME_ROOM_302 = "Room 302"
    let DEVICE_NAME_LIGHTING_OFFICE = "Lighting Office"
    
    var mCentralManager:CBCentralManager!
    var mConnectPeripheral:CBPeripheral!
    var mCharDictionary=[String:CBCharacteristic]()
    var mPeripherals = [String:CBPeripheral]()
    var mPeripheralName = Array<String>()
    var mTargetDevice = ""
    var mSelectedCell = TableViewCellForBleDevice()
    
    @IBOutlet weak var mPeripheralList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("MainPage, viewDidLoad()")
        // Do any additional setup after loading the view.
        
        if mCentralManager != nil && mConnectPeripheral != nil {
            NSLog("MainPage, viewDidLoad()-disconnect")
            let user = UserDefaults.standard
            user.removeObject(forKey: "KEY_PERIPHERAL_UUID")
            user.synchronize()
            mCentralManager.cancelPeripheralConnection(mConnectPeripheral)
        }
        
        mPeripheralList.dataSource = self
        mPeripheralList.delegate = self
        mPeripheralList.allowsSelection = true
        
        // Cancel bluetooth connection when app go into background
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appDidBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func appDidBecomeActive() {
        NSLog("MainPage, get in to foreground.")
        
        let queue = DispatchQueue.global()
        // It will invoke method#1
        mCentralManager = CBCentralManager(delegate:self, queue:queue)
    }
    
    func appMovedToBackground() {
        NSLog("MainPage, get into background.")
        let user = UserDefaults.standard
        user.removeObject(forKey: "KEY_PERIPHERAL_UUID")
        user.synchronize()
        if mConnectPeripheral != nil {
            mCentralManager.cancelPeripheralConnection(mConnectPeripheral)
        }
    }
    
    // +Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellForBleDevice
        
        cell.mText.text = mPeripheralName[indexPath.row]
        cell.mActivityIndicator.stopAnimating()
        cell.mActivityIndicator.isHidden = true
        
        cell.mIcon.image = #imageLiteral(resourceName: "bt_off")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mSelectedCell = tableView.cellForRow(at: indexPath) as! TableViewCellForBleDevice
        mSelectedCell.mActivityIndicator.isHidden = false
        mSelectedCell.mActivityIndicator.startAnimating()
        
        mTargetDevice = mPeripheralName[indexPath.row]
        NSLog("MainPage, selected device name:"+mTargetDevice+", stop scan.")
        
        mCentralManager.stopScan()
        let peripheral = mPeripherals[mTargetDevice]
        
        //儲存周邊UUID, 重新連線時需要該值
        let user = UserDefaults.standard
        user.set(peripheral?.identifier.uuidString, forKey: "KEY_PERIPHERAL_UUID")
        user.synchronize()
        
        mConnectPeripheral = peripheral
        mConnectPeripheral.delegate = self
        
        //It will invoke method#3
        mCentralManager.connect(mConnectPeripheral, options: nil)
    }
    // -Table view
    
    // Method#1
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        NSLog("MainPage, centralManagerDidUpdateState()")
        guard central.state == .poweredOn else {
            NSLog("MainPage, turn on bluetooth.")
            return
        }
        
        // It will invoke method#2
        NSLog("MainPage, centralManager.scanForPeripherals()")
        mCentralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // Method#2
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let name = peripheral.name {
            NSLog("MainPage, found BLE device:\(name)")
        } else {
            return
        }
        
        if peripheral.name != DEVICE_NAME_ROOM_302 && peripheral.name != DEVICE_NAME_LIGHTING_OFFICE {
            return
        }
        
        DispatchQueue.main.async(execute: {
            self.mPeripherals.updateValue(peripheral, forKey: peripheral.name!)
            self.mPeripheralName = Array(self.mPeripherals.keys)
            self.mPeripheralList.reloadData()
        })
    }
    
    // Method#3
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        mCharDictionary = [:]
        //It will invoke method#4
        peripheral.discoverServices(nil)
    }
    
    // Method#4
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            NSLog("MainPage, error:\(#file, #function)")
            return
        }
        
        for service in peripheral.services! {
            if service.uuid.uuidString == "1855" {
                // It will invoke method#5
                NSLog("MainPage, service:"+service.description)
                mConnectPeripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    // Method#5
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            NSLog("MainPage, error:\(#file, #function)")
            return
        }
        
        for characteristic in service.characteristics! {
            let uuidString = characteristic.uuid.uuidString
            mCharDictionary[uuidString] = characteristic
            NSLog("MainPage, found service:\(uuidString)")
            if uuidString == "2A55" {
                DispatchQueue.main.async {
                    if self.mTargetDevice == self.DEVICE_NAME_LIGHTING_OFFICE {
                        self.performSegue(withIdentifier: "GotoSecondPage", sender: self)
                    } else if self.mTargetDevice == self.DEVICE_NAME_ROOM_302 {
                        self.performSegue(withIdentifier: "GotoThirdPage", sender: self)
                    }
                    self.mSelectedCell.mActivityIndicator.isHidden = true
                    self.mSelectedCell.mActivityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // 取得Peripheral送過來的資料
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard error == nil else {
//            NSLog("MainPage, error:\(#file, #function)")
//            if let errorStatement = error {
//                NSLog("MainPage, error statement:\(errorStatement)")
//            }
//            return
//        }
//        
//        if characteristic.uuid.uuidString == "2A56" {
//            let data = characteristic.value! as NSData
//            DispatchQueue.main.async {
//                let string = String(data: data as Data, encoding: .utf8)!
//                print(string)
//            }
//        }
//    }
    
    // 斷線處理
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let state = UIApplication.shared.applicationState
        NSLog("MainPage, didDisconnectPeripheral:application state:\(state.rawValue)")
        if state == UIApplicationState.background {
            mCentralManager = nil
            mConnectPeripheral.delegate = nil
            mConnectPeripheral = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if mTargetDevice == DEVICE_NAME_LIGHTING_OFFICE {
            let vc = segue.destination as? SecondPage
            vc?.mCentralManager = self.mCentralManager
            vc?.mConnectPeripheral = self.mConnectPeripheral
            vc?.mCharDictionary = self.mCharDictionary
            vc?.mTargetDevice = self.mTargetDevice
        } else if mTargetDevice == DEVICE_NAME_ROOM_302 {
            let vc = segue.destination as? ThirdPage
            vc?.mCentralManager = self.mCentralManager
            vc?.mConnectPeripheral = self.mConnectPeripheral
            vc?.mCharDictionary = self.mCharDictionary
            vc?.mTargetDevice = self.mTargetDevice
        }
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
