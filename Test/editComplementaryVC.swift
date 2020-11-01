//
//  editComplementaryVC.swift
//  Test
//
//  Created by Тимур on 14.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

class editComplementaryVC: NSViewController {
    
    @IBOutlet weak var id: NSTextField!
    @IBOutlet weak var resortId: NSTextField!
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var price: NSTextField!
    @IBOutlet weak var tariff: NSTextField!
    @IBOutlet weak var comment: NSTextField!
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    @IBAction func add(_ sender: NSButton) {
        if (sCode != -1 && Double(price.stringValue) != nil) {
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
            let result = p.exec(statement: "insert into complementry_services (resort_id, service_code, service_name, total_sum, tariff_type, service_comment) values ($1, $2, $3, $4, $5, $6)", params: [Int(resorteId),  sCode, "'"+name.stringValue+"'", Double(price.stringValue), "'"+tariff.stringValue+"'", "'"+comment.stringValue+"'"])
            let myalert = NSAlert()
            if result.errorMessage() == "" {
                myalert.messageText = "Успешно"
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
            myalert.informativeText = "resort_id, код услуги и цена должны быть числом"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
        sCode = -1
    }
    
    @IBAction func change(_ sender: NSButton) {
        if (allId != -1 && sCode != -1 && Double(price.stringValue) != nil) {
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
            let result = p.exec(statement: "update complementry_services set resort_id=$1, service_code=$2, service_name=$3, total_sum=$4, tariff_type=$5, service_comment=$6 where id=$7;", params: [Int(resorteId),  sCode, "'"+name.stringValue+"'", Double(price.stringValue), "'"+tariff.stringValue+"'",  "'"+comment.stringValue+"'", allId])
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
            myalert.informativeText = "resort_id, код услуги, цена и id должны быть числом"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
        allId = -1
        sCode = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
