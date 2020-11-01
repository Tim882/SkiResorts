//
//  ServiceViewController.swift
//  Test
//
//  Created by Тимур on 13.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

@objc(Service)
class Service: NSObject {
    
    @objc var id: String?
    @objc var resort_id: String?
    @objc var serviceCode: String?
    @objc var serviceName: String?
    @objc var amount: String?
    @objc var totalSum: String?
    @objc var surcharge: String?
    @objc var complex: String?
    @objc var serviceComment: String?
    
    init(id: String?, resort_id: String?, serviceCode: String?, serviceName: String?, amount: String?, totalSum: String?, surcharge: String?, complex: String?, serviceComment: String?) {
        self.id = id
        self.resort_id = resort_id
        self.serviceCode = serviceCode
        self.serviceName = serviceName
        self.amount = amount
        self.totalSum = totalSum
        self.surcharge = surcharge
        self.complex = complex
        self.serviceComment = serviceComment
    }
}

class ServiceViewController: NSViewController {
    
    var service: [Service] = []
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    @IBOutlet weak var deleteId: NSTextField!
    @IBOutlet var serviceArray: NSArrayController!
    @IBOutlet weak var table: NSTableView!
    
    @IBOutlet weak var rId: NSTextField!
    @IBAction func showAll(_ sender: NSButton) {
        serviceArray.remove(contentsOf: service)
        service = []
        do {
            var resorteId=""
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
            let res = p.exec(statement: "select * from service where resort_id=$1;", params: [Int(resorteId)])
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                let c3 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
                let c4 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
                let c5 = res.getFieldString(tupleIndex: x, fieldIndex: 3)
                let c6 = res.getFieldString(tupleIndex: x, fieldIndex: 4)
                let c7 = res.getFieldString(tupleIndex: x, fieldIndex: 5)
                let c8 = res.getFieldString(tupleIndex: x, fieldIndex: 6)
                let c9 = res.getFieldString(tupleIndex: x, fieldIndex: 7)
                let c10 = res.getFieldString(tupleIndex: x, fieldIndex: 8)
                let c11 = res.getFieldString(tupleIndex: x, fieldIndex: 9)
                //let c12 = res.getFieldString(tupleIndex: x, fieldIndex: 12)

                service.append(Service(id: c11, resort_id: c0, serviceCode: c3, serviceName: c4, amount: c5, totalSum: c6, surcharge: c7, complex: c8, serviceComment: c9))
            }
            for i in service {
                self.serviceArray.addObject(i)
            }
            defer {
                p.close()
            }
        } catch {
            // handle errors
        }
    }
    
//    @IBAction func show(_ sender: NSButton) {
//        serviceArray.remove(contentsOf: service)
//        service = []
//        if (Int(deleteId.stringValue) != nil) {
//            do {
//                let p = PGConnection()
//                let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
//                print(status)
//                let res = p.exec(statement: "select * from service where id=$1;", params: [deleteId.stringValue])
//                let num = res.numTuples()
//                for x in 0..<num {
//                    let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
//                    let c3 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
//                    let c4 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
//                    let c5 = res.getFieldString(tupleIndex: x, fieldIndex: 3)
//                    let c6 = res.getFieldString(tupleIndex: x, fieldIndex: 4)
//                    let c7 = res.getFieldString(tupleIndex: x, fieldIndex: 5)
//                    let c8 = res.getFieldString(tupleIndex: x, fieldIndex: 6)
//                    let c9 = res.getFieldString(tupleIndex: x, fieldIndex: 7)
//                    let c10 = res.getFieldString(tupleIndex: x, fieldIndex: 8)
//                    let c11 = res.getFieldString(tupleIndex: x, fieldIndex: 9)
//                    //let c12 = res.getFieldString(tupleIndex: x, fieldIndex: 12)
//
//                    service.append(Service(id: c11, resort_id: c0, serviceCode: c3, serviceName: c4, amount: c5, totalSum: c6, surcharge: c7, complex: c8, serviceComment: c9))
//                }
//                for i in service {
//                    self.serviceArray.addObject(i)
//                }
//                defer {
//                    p.close()
//                }
//            } catch {
//                // handle errors
//            }
//        }
//    }
    
    @IBAction func deleteService(_ sender: NSButton) {
        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        //let res = p.exec(statement: "delete from service where id=$1;", params: [service[table.selectedRow].id])
        
        if allId != -1 {
            let res = p.exec(statement: "delete from service where id=$1;", params: [allId])
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
        
        if (index != -1 && Int(service[index].id ?? "") != nil) {
            allId = Int(service[index].id ?? "-1") ?? -1
            
            let myalert = NSAlert()
            myalert.messageText = "Успешно"
            myalert.informativeText = "Чтобы изменить данный элемент, нажмите кнопку изменить/добавть снизу, затем введите новые данные и нажмите кнопку изменить"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
    }
}
