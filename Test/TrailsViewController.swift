//
//  TrailsViewController.swift
//  Test
//
//  Created by Тимур on 13.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

@objc(Trails)
class Trails: NSObject {
    
    @objc var id: String?
    @objc var resort_id: String?
    @objc var trailName: String?
    @objc var color: String?
    @objc var trailLength: String?
    @objc var heightDifference: String?
    @objc var slope: String?
    @objc var lift: String?
    @objc var nightLighting: String?
    @objc var nameTr: String?
    
    
    init(id: String?,resort_id: String?, trailName: String?, color: String?, trailLength: String?, heightDifference: String?, slope: String?, lift: String?, nightLighting: String?) {
        self.id = id
        self.resort_id = resort_id
        self.trailName = trailName
        self.color = color
        self.trailLength = trailLength
        self.heightDifference = heightDifference
        self.slope = slope
        self.lift = lift
        self.nightLighting = nightLighting
    }
}


class TrailsViewController: NSViewController {
    
    @IBOutlet var trailsArray: NSArrayController!
    @IBOutlet weak var deleteId: NSTextField!
    @IBOutlet weak var rId: NSTextField!
    @IBOutlet weak var table: NSTableView!
    
    var trails: [Trails] = []
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    @IBAction func showAll(_ sender: NSButton) {
        trailsArray.remove(contentsOf: trails)
        
        trails = []
        do {
            var resorteId = ""
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            let res10 = p.exec(statement: "select resort_id from resorts where name=$1;", params: [rId.stringValue])
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
            let res = p.exec(statement: "select * from trails where resort_id=$1;", params: [Int(resorteId)])
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
                let c2 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
                let c3 = res.getFieldString(tupleIndex: x, fieldIndex: 3)
                let c4 = res.getFieldString(tupleIndex: x, fieldIndex: 4)
                let c5 = res.getFieldString(tupleIndex: x, fieldIndex: 5)
                let c6 = res.getFieldString(tupleIndex: x, fieldIndex: 6)
                let c7 = res.getFieldString(tupleIndex: x, fieldIndex: 7)
                let c8 = res.getFieldString(tupleIndex: x, fieldIndex: 8)
                trails.append(Trails(id: c8, resort_id: c0, trailName: c1, color: c2, trailLength: c3, heightDifference: c4, slope: c5, lift: c6, nightLighting: c7))
            }
            for i in trails {
                self.trailsArray.addObject(i)
            }
            defer {
                p.close()
            }
        } catch {
            // handle errors
        }
    }
    
    @IBAction func show(_ sender: NSButton) {
        trailsArray.remove(contentsOf: trails)
        trails = []
        if (Int(deleteId.stringValue) != nil) {
            do {
                let p = PGConnection()
                let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
                print(status)
                let res = p.exec(statement: "select * from trails where id=$1;", params: [Int(deleteId.stringValue)])
                let num = res.numTuples()
                for x in 0..<num {
                    let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                    let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
                    let c2 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
                    let c3 = res.getFieldString(tupleIndex: x, fieldIndex: 3)
                    let c4 = res.getFieldString(tupleIndex: x, fieldIndex: 4)
                    let c5 = res.getFieldString(tupleIndex: x, fieldIndex: 5)
                    let c6 = res.getFieldString(tupleIndex: x, fieldIndex: 6)
                    let c7 = res.getFieldString(tupleIndex: x, fieldIndex: 7)
                    let c8 = res.getFieldString(tupleIndex: x, fieldIndex: 8)
                    trails.append(Trails(id: c8, resort_id: c0, trailName: c1, color: c2, trailLength: c3, heightDifference: c4, slope: c5, lift: c6, nightLighting: c7))
                }
                for i in trails {
                    self.trailsArray.addObject(i)
                }
                defer {
                    p.close()
                }
            } catch {
                // handle errors
            }
        }
    }
    
    
    @IBAction func deleteTrail(_ sender: NSButton) {
        
        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        
        if allId != -1 {
            let res = p.exec(statement: "delete from complementry_services where id=$1;", params: [allId])
            if res.errorMessage() == "" {
                let myalert = NSAlert()
                myalert.messageText = "Удалено"
                myalert.informativeText = ""
                myalert.addButton(withTitle: "OK")
                myalert.runModal()
            }
            else {
                let myalert = NSAlert()
                myalert.messageText = "Ошибка"
                myalert.informativeText = res.errorMessage()
                myalert.addButton(withTitle: "OK")
                myalert.runModal()
            }
            allId = -1
        }
        else {
            goAlert(header: "Ошибка", val: "Выберете удаляемый элемент")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tableAction(_ sender: NSTableView) {
        var index: Int = table.selectedRow
        
        if (index != -1 && Int(trails[index].id ?? "") != nil) {
            allId = Int(trails[index].id ?? "-1") ?? -1
            
            let myalert = NSAlert()
            myalert.messageText = "Успешно"
            myalert.informativeText = "Чтобы изменить данный элемент, нажмите кнопку изменить/добавть снизу, затем введите новые данные и нажмите кнопку изменить"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
    }
}
