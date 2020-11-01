//
//  serviceVC.swift
//  Test
//
//  Created by Тимур on 15.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

class ServiceClient: NSObject {
    @objc var serviceName: String?
    @objc var price: String?
    @objc var amount: String?
    @objc var surcharge: String?
    @objc var discount: String?
    @objc var complex: String?

    
    init(serviceName: String?, price: String?, amount: String?, surcharge: String?, discount: String?, complex: String?) {
        self.serviceName = serviceName
        self.price = price
        self.amount = amount
        self.surcharge = surcharge
        self.discount = discount
        self.complex = complex
    }
}

class serviceVC: NSViewController {
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    var servicesCl: [ServiceClient] = []

    @IBOutlet var serviceClientArray: NSArrayController!
    @IBOutlet weak var resorts: NSPopUpButton!
    
    @IBAction func show(_ sender: NSButton) {
        serviceClientArray.remove(contentsOf: servicesCl)
        servicesCl = []
        
        var name = ""
        if names.count != 0 {
            for i in 0...names.count-1 {
                if names[i] == resorts.itemTitle(at: resorts.index(of: resorts.selectedItem ?? NSMenuItem())) {
                    name = id[i]
                }
            }
        }

        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        switch status {
        case .ok:
            print("ok")
        default:
            goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
        }
        let res = p.exec(statement: "select servicename, totalsum, amount, surcharge, specialdiscounts, complex from service where resort_id=$1;", params: [Int(name)])
        let num = res.numTuples()
        for x in 0..<num {
            let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
            let c2 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
            let c3 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
            let c4 = res.getFieldString(tupleIndex: x, fieldIndex: 3)
            let c5 = res.getFieldString(tupleIndex: x, fieldIndex: 4)
            let c6 = res.getFieldString(tupleIndex: x, fieldIndex: 5)
            servicesCl.append(ServiceClient(serviceName: c1, price: c2, amount: c3, surcharge: c4, discount: c5, complex: c6))
        }
        for i in servicesCl {
            self.serviceClientArray.addObject(i)
        }
    }
    
    var names: [String] = []
    var id: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            print(status)
            let res = p.exec(statement: "select name, resort_id from resorts;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0) ?? ""
                let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1) ?? ""
                id.append(c1)
                names.append(c0)
            }
            resorts.removeAllItems()
            resorts.addItems(withTitles: names)
            defer {
                p.close()
            }
        } catch {
            // handle errors
        }
    }
    
}
