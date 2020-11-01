//
//  editResortVC.swift
//  Test
//
//  Created by Тимур on 14.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

class editResortVC: NSViewController {

    @IBOutlet weak var resortId: NSTextField!
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var fullName: NSTextField!
    @IBOutlet weak var adress: NSTextField!
    @IBOutlet weak var airport: NSTextField!
    @IBOutlet weak var distanceToAirport: NSTextField!
    @IBOutlet weak var email: NSTextField!
    @IBOutlet weak var phone: NSTextField!
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    @IBAction func add(_ sender: NSButton) {
        if (Int(distanceToAirport.stringValue) != nil) {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            let result = p.exec(statement: "insert into resorts (name, fullname, adress, airport, distancetoairport, site, phone) values ($1, $2, $3, $4, $5, $6, $7)", params: [name.stringValue, fullName.stringValue, adress.stringValue, airport.stringValue, Int(distanceToAirport.stringValue), email.stringValue, phone.stringValue])
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
            myalert.informativeText = "resort_id и расстояние до аэропорта должны быть числом"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
    }
    
    
    @IBAction func change(_ sender: NSButton) {
        if (Int(distanceToAirport.stringValue) != nil) {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            var resorteId = ""
            let res10 = p.exec(statement: "select resort_id from resorts where name=$1;", params: [name.stringValue])
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
            let result = p.exec(statement: "UPDATE public.resorts SET name=$2, fullname=$3, adress=$4, airport=$5, distancetoairport=$6, site=$7, phone=$8 WHERE resort_id=$1;",params: [Int(resorteId), name.stringValue, fullName.stringValue, adress.stringValue, airport.stringValue, Int(distanceToAirport.stringValue), email.stringValue, phone.stringValue])
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
            myalert.informativeText = "resort_id и расстояние до аэропорта должны быть числом"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
