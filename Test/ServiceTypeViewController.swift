//
//  ServiceTypeViewController.swift
//  Test
//
//  Created by Тимур on 13.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

@objc(ServiceType)
class ServiceType: NSObject {
    @objc var serviceCode: String?
    @objc var serviceType: String?
    @objc var serviceComment: String?

    
    init(serviceCode: String?, serviceType: String?, serviceComment: String?) {
        self.serviceCode = serviceCode
        self.serviceType = serviceType
        self.serviceComment = serviceComment
    }
}

var sCode: Int = -1

class ServiceTypeViewController: NSViewController {

    @IBOutlet var serviceTypaArray: NSArrayController!
    @IBOutlet weak var deleteId: NSTextField!
    @IBOutlet weak var table: NSTableView!
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    var serviceType: [ServiceType] = []
    
    
    @IBAction func showAll(_ sender: NSButton) {
        serviceTypaArray.remove(contentsOf: serviceType)
        serviceType = []
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            let res = p.exec(statement: "select * from servicetype;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
                let c2 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
                serviceType.append(ServiceType(serviceCode: c0, serviceType: c1, serviceComment: c2))
            }
            for i in serviceType {
                self.serviceTypaArray.addObject(i)
            }
            defer {
                p.close()
            }
        } catch {
            // handle errors
        }
    }
    
    @IBAction func show(_ sender: NSButton) {
        serviceTypaArray.remove(contentsOf: serviceType)
        serviceType = []
        if (Int(deleteId.stringValue) != nil) {
            do {
                let p = PGConnection()
                let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
                switch status {
                case .ok:
                    print("ok")
                default:
                    goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
                }
                let res = p.exec(statement: "select * from servicetype where service_code=$1;", params: [Int(deleteId.stringValue)])
                let num = res.numTuples()
                for x in 0..<num {
                    let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                    let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
                    let c2 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
                    serviceType.append(ServiceType(serviceCode: c0, serviceType: c1, serviceComment: c2))
                }
                for i in serviceType {
                    self.serviceTypaArray.addObject(i)
                }
                defer {
                    p.close()
                }
            } catch {
                // handle errors
            }
        }
    }
    
    
    
    @IBAction func deleteType(_ sender: NSButton) {
        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        switch status {
        case .ok:
            print("ok")
        default:
            goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
        }
        if sCode != -1 {
            let res = p.exec(statement: "delete from servicetype where service_code=$1;", params: [sCode])
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
            sCode = -1
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
        
        if (index != -1 && Int(serviceType[index].serviceCode ?? "") != nil) {
            sCode = Int(serviceType[index].serviceCode ?? "-1") ?? -1
            
            let myalert = NSAlert()
            myalert.messageText = "Успешно"
            myalert.informativeText = "Чтобы изменить данный элемент, нажмите кнопку изменить/добавть снизу, затем введите новые данные и нажмите кнопку изменить"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
    }
}
