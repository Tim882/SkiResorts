//
//  ResortViewController.swift
//  Test
//
//  Created by Тимур on 13.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

var workerLogin: String = ""
var allId: Int = -1

class ResortViewController: NSViewController {
    
    var resorts: [SkiResort] = []
    
    @IBOutlet var resortsArray: NSArrayController!
    @IBOutlet weak var deleteId: NSTextField!
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    @IBAction func showAll(_ sender: NSButton) {
        resortsArray.remove(contentsOf: resorts)
        resorts = []
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
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
                let c2 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
                let c3 = res.getFieldString(tupleIndex: x, fieldIndex: 3)
                let c4 = res.getFieldString(tupleIndex: x, fieldIndex: 4)
                let c5 = res.getFieldString(tupleIndex: x, fieldIndex: 5)
                let c6 = res.getFieldString(tupleIndex: x, fieldIndex: 6)
                let c7 = res.getFieldString(tupleIndex: x, fieldIndex: 7)
                resorts.append(SkiResort(resort_id: c0, name: c1, fullName: c2, adress: c3, airport: c4, distanceToAirport: c5, email: c6, phone: c7))
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
    
    @IBAction func show(_ sender: NSButton) {
        resortsArray.remove(contentsOf: resorts)
        resorts = []
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            var resorteId = ""
            let res10 = p.exec(statement: "select resort_id from resorts where name=$1;", params: [deleteId.stringValue])
            let num10 = res10.numTuples()
            if num10 != 0 {
                let c0 = res10.getFieldString(tupleIndex: 0, fieldIndex: 0)
                resorteId = c0 ?? ""
            }
            else {
                goAlert(header: "Ошибка", val: "некорректное название курорта")
            }
            let res = p.exec(statement: "select * from resorts where resort_id=$1;", params: [Int(resorteId)])
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
                resorts.append(SkiResort(resort_id: c0, name: c1, fullName: c2, adress: c3, airport: c4, distanceToAirport: c5, email: c6, phone: c7))
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
    
    @IBAction func deleteResort(_ sender: Any) {
        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        switch status {
        case .ok:
            print("ok")
        default:
            goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
        }
        var resorteId = ""
        let res10 = p.exec(statement: "select resort_id from resorts where name=$1;", params: [deleteId.stringValue])
        let num10 = res10.numTuples()
        if num10 != 0 {
            let c0 = res10.getFieldString(tupleIndex: 0, fieldIndex: 0)
            resorteId = c0 ?? ""
        }
        else {
            goAlert(header: "Ошибка", val: "некорректное название курорта")
        }
        let res = p.exec(statement: "delete from resorts where resort_id=$1;", params: [Int(resorteId)])
        if res.errorMessage() == "" {
            let c0 = res10.getFieldString(tupleIndex: 0, fieldIndex: 0)
            resorteId = c0 ?? ""
            goAlert(header: "Успешно", val: "")
        }
        else {
            goAlert(header: "Ошибка", val: res.errorMessage())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
