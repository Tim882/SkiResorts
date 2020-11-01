//
//  complServiceVC.swift
//  Test
//
//  Created by Тимур on 15.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

class ComplClient: NSObject {
    @objc var serviceName: String?
    @objc var price: String?
    @objc var tariff: String?
    @objc var comment: String?

    
    init(serviceName: String?, price: String?, tariff: String?, comment: String?) {
        self.serviceName = serviceName
        self.price = price
        self.tariff = tariff
        self.comment = comment
    }
}

class complServiceVC: NSViewController {
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    var complServices: [ComplClient] = []

    @IBOutlet var complServiceArray: NSArrayController!
    @IBOutlet weak var resorts: NSPopUpButton!
    
    @IBAction func show(_ sender: NSButton) {
        complServiceArray.remove(contentsOf: complServices)
        complServices = []
        
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
        let res = p.exec(statement: "select service_name, total_sum, tariff_type, service_comment from complementry_services where resort_id=$1;", params: [Int(name)])
        let num = res.numTuples()
        for x in 0..<num {
            let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
            let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
            let c2 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
            let c3 = res.getFieldString(tupleIndex: x, fieldIndex: 3)
            complServices.append(ComplClient(serviceName: c0, price: c1, tariff: c2, comment: c3))
        }
        for i in complServices {
            self.complServiceArray.addObject(i)
        }
    }
    
    var names: [String] = []
    var id: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
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
