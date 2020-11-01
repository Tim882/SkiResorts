//
//  ViieController.swift
//  Test
//
//  Created by Тимур on 09.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

@objc(SkiResort)
class SkiResort: NSObject {
    @objc var resort_id: String? = ""
    @objc var name: String?
    @objc var fullName: String?
    @objc var adress: String?
    @objc var airport: String?
    @objc var distanceToAirport: String?
    @objc var email: String?
    @objc var phone: String?
    
    init(name: String?, fullName: String?, adress: String?, airport: String?, distanceToAirport: String?, email: String?, phone: String?) {
        self.name = name
        self.fullName = fullName
        self.adress = adress
        self.airport = airport
        self.distanceToAirport = distanceToAirport
        self.email = email
        self.phone = phone
    }
    
    init(resort_id: String?, name: String?, fullName: String?, adress: String?, airport: String?, distanceToAirport: String?, email: String?, phone: String?) {
        self.resort_id = resort_id
        self.name = name
        self.fullName = fullName
        self.adress = adress
        self.airport = airport
        self.distanceToAirport = distanceToAirport
        self.email = email
        self.phone = phone
    }
}

class ViieController: NSViewController {

    @IBOutlet var resortsArray: NSArrayController!
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    @IBAction func logOut(_ sender: NSButton) {
        userLogin = ""
        //self.dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var resorts: [SkiResort] = []
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            let res = p.exec(statement: "select * from resorts;")
            let num = res.numTuples()
            for x in 0..<num {
                let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
                let c2 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
                let c3 = res.getFieldString(tupleIndex: x, fieldIndex: 3)
                let c4 = res.getFieldString(tupleIndex: x, fieldIndex: 4)
                let c5 = res.getFieldString(tupleIndex: x, fieldIndex: 5)
                let c6 = res.getFieldString(tupleIndex: x, fieldIndex: 6)
                let c7 = res.getFieldString(tupleIndex: x, fieldIndex: 7)
                resorts.append(SkiResort(name: c1, fullName: c2, adress: c3, airport: c4, distanceToAirport: c5, email: c6, phone: c7))
            }
            for i in resorts {
                self.resortsArray.addObject(i)
            }
            defer {
                p.close()
            }
        } catch {
            // handle errors
        }
    }
    
}
