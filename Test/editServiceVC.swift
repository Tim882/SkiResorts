//
//  editServiceVC.swift
//  Test
//
//  Created by Тимур on 14.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

class editServiceVC: NSViewController {
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }

    @IBOutlet weak var id: NSTextField!
    @IBOutlet weak var resortId: NSTextField!
    @IBOutlet weak var serviceCode: NSTextField!
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var serviceType: NSTextField!
    @IBOutlet weak var amount: NSTextField!
    @IBOutlet weak var price: NSTextField!
    @IBOutlet weak var surcharge: NSTextField!
    @IBOutlet weak var specialDiscounts: NSTextField!
    @IBOutlet weak var complex: NSTextField!
    
    @IBAction func add(_ sender: NSButton) {
        if (Int(serviceCode.stringValue) != nil && Double(amount.stringValue) != nil && Int(surcharge.stringValue) != nil && Int(price.stringValue) != nil && Int(surcharge.stringValue) != nil) {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            var resorteId = ""
            let res10 = p.exec(statement: "select resort_id from resorts where name=$1;", params: [resortId.stringValue])
            let num10 = res10.numTuples()
            if num10 != 0 {
                let c0 = res10.getFieldString(tupleIndex: 0, fieldIndex: 0)
                resorteId = c0 ?? ""
            }
            else {
                let myalert = NSAlert()
                myalert.messageText = "Ошибка"
                myalert.informativeText = "некорректное название курорта"
                myalert.addButton(withTitle: "OK")
                myalert.runModal()
            }
            let result = p.exec(statement: "insert into service (resort_id, servicecode, servicename, servicetype, amount, totalsum, surcharge, specialdiscounts, complex) values ($1, $2, $3, $4, $5, $6, $7, $8, $9)", params: [Int(resorteId), Int(serviceCode.stringValue), "'"+name.stringValue+"'", "'"+serviceType.stringValue+"'", Double(amount.stringValue), Int(price.stringValue), Int(surcharge.stringValue), "'"+specialDiscounts.stringValue+"'", "'"+complex.stringValue+"'"])
            let myalert = NSAlert()
            if result.errorMessage() == "" {
                myalert.messageText = "Успешно"
                myalert.informativeText = ""
            }
            else {
                myalert.messageText = "Ошибка"
                myalert.informativeText = result.errorMessage()
            }
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
            p.close()
        } else {
            let myalert = NSAlert()
            myalert.messageText = "Ошибка"
            myalert.informativeText = "resort_id, код услуги, количество, доплата, цена и перпад высот должны быть числом"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
    }
    
    @IBAction func change(_ sender: NSButton) {
        if (allId != -1 && Int(serviceCode.stringValue) != nil && Double(amount.stringValue) != nil && Int(surcharge.stringValue) != nil && Int(price.stringValue) != nil && Int(surcharge.stringValue) != nil) {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            var resorteId = ""
            let res10 = p.exec(statement: "select resort_id from resorts where name=$1;", params: [resortId.stringValue])
            let num10 = res10.numTuples()
            if num10 != 0 {
                let c0 = res10.getFieldString(tupleIndex: 0, fieldIndex: 0)
                resorteId = c0 ?? ""
            }
            else {
                let myalert = NSAlert()
                myalert.messageText = "Ошибка"
                myalert.informativeText = "некорректное название курорта"
                myalert.addButton(withTitle: "OK")
                myalert.runModal()
            }
            let result = p.exec(statement: "update service set resort_id=$1, servicecode=$2, servicename=$3, servicetype=$4, amount=$5, totalsum=$6, surcharge=$7, specialdiscounts=$8, complex=$9 where id=$10;", params: [Int(resorteId), Int(serviceCode.stringValue), "'"+name.stringValue+"'", "'"+serviceType.stringValue+"'", Double(amount.stringValue), Int(price.stringValue), Int(surcharge.stringValue), "'"+specialDiscounts.stringValue+"'", "'"+complex.stringValue+"'",  allId])
            let myalert = NSAlert()
            if result.errorMessage() == "" {
                myalert.messageText = "Успешно"
                //myalert.informativeText = ""
            }
            else {
                myalert.messageText = "Ошибка"
                myalert.informativeText = result.errorMessage()
            }
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
            p.close()
        } else {
            let myalert = NSAlert()
            myalert.messageText = "Ошибка"
            myalert.informativeText = "resort_id, код услуги, количество, доплата, цена и перпад высот должны быть числом"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
        allId = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
