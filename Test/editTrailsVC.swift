//
//  editTrailsVC.swift
//  Test
//
//  Created by Тимур on 14.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

class editTrailsVC: NSViewController {

    @IBOutlet weak var id: NSTextField!
    @IBOutlet weak var resortId: NSTextField!
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var color: NSPopUpButton!
    @IBOutlet weak var length: NSTextField!
    @IBOutlet weak var heightDifference: NSTextField!
    @IBOutlet weak var slope: NSTextField!
    @IBOutlet weak var lift: NSTextField!
    @IBOutlet weak var nightlighting: NSTextField!
    
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    @IBAction func addT(_ sender: NSButton) {
        if (Int(length.stringValue) != nil && Int(heightDifference.stringValue) != nil) {
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
            //var cl = "'"+color.itemTitle(at: color.index(of: color.selectedItem ?? NSMenuItem()))+"'"
            let result = p.exec(statement: "insert into trails (resort_id, trailname, color, traillength, heightdifference, slope, lift, nightlighting) values ($1, $2, $3, $4, $5, $6, $7, $8)",params: [Int(resorteId), "'"+name.stringValue+"'", "'"+color.itemTitle(at: color.index(of: color.selectedItem ?? NSMenuItem()))+"'", Int(length.stringValue), Int(heightDifference.stringValue), "'"+slope.stringValue+"'", "'"+lift.stringValue+"'", "'"+nightlighting.stringValue+"'"])
            //print(color.itemTitle(at: color.index(of: color.selectedItem ?? NSMenuItem())))
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
            myalert.informativeText = "resort_id, длина и перпад высот должны быть числом"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
    }
    
    @IBAction func changeT(_ sender: NSButton) {
        if (Int(length.stringValue) != nil && Int(heightDifference.stringValue) != nil && allId != -1) {
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
            let result = p.exec(statement: "update trails set resort_id=$2, trailname=$3, color=$4, traillength=$5, heightdifference=$6, slope=$7, lift=$8, nightlighting=$9 where id=$1;", params: [allId, Int(resorteId), "'"+name.stringValue+"'", "'"+color.itemTitle(at: color.index(of: color.selectedItem ?? NSMenuItem()))+"'", Double(length.stringValue), Double(heightDifference.stringValue), "'"+slope.stringValue+"'", "'"+lift.stringValue+"'", "'"+nightlighting.stringValue+"'"])
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
            myalert.informativeText = "resort_id, длина, id и перпад высот должны быть числом"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        color.removeAllItems()
        color.addItems(withTitles: ["зеленый", "красный", "черный", "синий", ""])
    }
    
}
