//
//  editTypeVC.swift
//  Test
//
//  Created by Тимур on 14.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

class editTypeVC: NSViewController {
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    @IBOutlet weak var serviceCode: NSTextField!
    @IBOutlet weak var serviceType: NSTextField!
    @IBOutlet weak var comment: NSTextField!
    
    @IBAction func add(_ sender: NSButton) {
        //if (serviceCode != nil) {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            let result = p.exec(statement: "insert into servicetype (service_type, sirvice_comment) values ($1, $2)", params: ["'"+serviceType.stringValue+"'", "'"+comment.stringValue+"'"])
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
        //} else {
//            let myalert = NSAlert()
//            myalert.messageText = "Ошибка"
//            myalert.informativeText = "код услуги должно быть числом"
//            myalert.addButton(withTitle: "OK")
//            myalert.runModal()
        //}
        sCode = -1
    }
    
    @IBAction func change(_ sender: NSButton) {
        if (sCode != -1) {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            let result = p.exec(statement: "update servicetype set service_code=$1, service_type=$2, sirvice_comment=$3 WHERE service_code=$1;", params: [sCode, "'"+serviceType.stringValue+"'", "'"+comment.stringValue+"'"])
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
            myalert.informativeText = "код услуги должно быть числом"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
        sCode = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
