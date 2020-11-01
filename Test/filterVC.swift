//
//  filterVC.swift
//  Test
//
//  Created by Тимур on 16.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

class filterVC: NSViewController {
    
    var ids: [String] = []
    var results: [String] = []
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    @IBOutlet weak var selectRes: NSPopUpButton!
    @IBOutlet weak var lift: NSPopUpButton!
    @IBOutlet weak var babysitter: NSButton!
    @IBOutlet weak var photo: NSButton!
    @IBOutlet weak var easy: NSButton!
    @IBOutlet weak var night: NSButton!
    @IBOutlet weak var tow: NSButton!
    @IBOutlet weak var baby: NSButton!
    @IBOutlet weak var rent: NSButton!
    @IBOutlet weak var hire: NSButton!
    @IBOutlet weak var entertainments: NSButton!
    @IBOutlet weak var fourLift: NSButton!
    @IBOutlet weak var eightLift: NSButton!
    @IBOutlet weak var parking: NSButton!
    @IBOutlet weak var food: NSButton!
    @IBOutlet weak var spa: NSButton!
    @IBOutlet weak var trainer: NSButton!
    @IBOutlet weak var sport: NSButton!
    
    @IBAction func notDifficult(_ sender: NSButton) {
        ids = []
        results = []
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            let res = p.exec(statement: "select resort_id from trails where color='''зеленый''' group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            for i in ids {
                let res1 = p.exec(statement: "select name from resorts where resort_id=$1;", params: [Int(i)])
                let num1 = res1.numTuples()
                for x in 0..<num1 {
                    let c0 = res1.getFieldString(tupleIndex: x, fieldIndex: 0)
                    results.append(c0 ?? "")
                }
            }
            selectRes.removeAllItems()
            selectRes.addItems(withTitles: results)
            defer {
                p.close()
            }
        } catch {
            // handle errors
        }
    }
    
    @IBAction func lift(_ sender: NSButton) {
        ids = []
        results = []
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            if lift.itemTitle(at: lift.index(of: lift.selectedItem ?? NSMenuItem())) == "бугельный" {
                let res = p.exec(statement: "select resort_id from trails where lift='''бугельный''' group by resort_id;")
                let num = res.numTuples()
                for x in 0..<num {
                    let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                    ids.append(c0 ?? "")
                }
                print(ids)
                for i in ids {
                    let res1 = p.exec(statement: "select name from resorts where resort_id=$1;", params: [Int(i)])
                    let num1 = res1.numTuples()
                    for x in 0..<num1 {
                        let c0 = res1.getFieldString(tupleIndex: x, fieldIndex: 0)
                        results.append(c0 ?? "")
                    }
                }
                print(results)
            }
            else if lift.itemTitle(at: lift.index(of: lift.selectedItem ?? NSMenuItem())) == "беби-лифт" {
                let res = p.exec(statement: "select resort_id from trails where lift='''беби-лифт''' group by resort_id;")
                let num = res.numTuples()
                for x in 0..<num {
                    let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                    ids.append(c0 ?? "")
                }
                print(ids)
                for i in ids {
                    let res1 = p.exec(statement: "select name from resorts where resort_id=$1;", params: [Int(i)])
                    let num1 = res1.numTuples()
                    for x in 0..<num1 {
                        let c0 = res1.getFieldString(tupleIndex: x, fieldIndex: 0)
                        results.append(c0 ?? "")
                    }
                }
                print(results)
            }
            else if lift.itemTitle(at: lift.index(of: lift.selectedItem ?? NSMenuItem())) == "4-местный кресельный" {
                let res = p.exec(statement: "select resort_id from trails where lift='''4-местный кресельный''' group by resort_id;")
                let num = res.numTuples()
                for x in 0..<num {
                    let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                    ids.append(c0 ?? "")
                }
                print(ids)
                for i in ids {
                    let res1 = p.exec(statement: "select name from resorts where resort_id=$1;", params: [Int(i)])
                    let num1 = res1.numTuples()
                    for x in 0..<num1 {
                        let c0 = res1.getFieldString(tupleIndex: x, fieldIndex: 0)
                        results.append(c0 ?? "")
                    }
                }
                print(results)
            }
            else if lift.itemTitle(at: lift.index(of: lift.selectedItem ?? NSMenuItem())) == "8-мест кабинки" {
                let res = p.exec(statement: "select resort_id from trails where lift='''8-мест кабинки''' group by resort_id;")
                let num = res.numTuples()
                for x in 0..<num {
                    let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                    ids.append(c0 ?? "")
                }
                print(ids)
                for i in ids {
                    let res1 = p.exec(statement: "select name from resorts where resort_id=$1;", params: [Int(i)])
                    let num1 = res1.numTuples()
                    for x in 0..<num1 {
                        let c0 = res1.getFieldString(tupleIndex: x, fieldIndex: 0)
                        results.append(c0 ?? "")
                    }
                }
                print(results)
            }
            selectRes.removeAllItems()
            selectRes.addItems(withTitles: results)
            defer {
                p.close()
            }
        } catch {
            // handle errors
        }
    }
    
    
    @IBAction func night(_ sender: NSButton) {
        ids = []
        results = []
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            let res = p.exec(statement: "select resort_id from trails where nightlighting='''1''' group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            for i in ids {
                let res1 = p.exec(statement: "select name from resorts where resort_id=$1;", params: [Int(i)])
                let num1 = res1.numTuples()
                for x in 0..<num1 {
                    let c0 = res1.getFieldString(tupleIndex: x, fieldIndex: 0)
                    results.append(c0 ?? "")
                }
            }
            selectRes.removeAllItems()
            selectRes.addItems(withTitles: results)
            defer {
                p.close()
            }
        } catch {
            // handle errors
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lift.removeAllItems()
        lift.addItems(withTitles: ["бугельный", "беби-лифт", "4-местный кресельный", "8-мест кабинки"])
    }
    
    @IBAction func filter(_ sender: NSButton) {
        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        switch status {
        case .ok:
            print("ok")
        default:
            goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
        }
        var finalRes: [String] = getResorts()
        
        print(finalRes)
        
        if easy.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from trails where color='''зеленый''' group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        print(finalRes)
        
        if photo.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from complementry_services where service_code in (select service_code from servicetype where service_type = '''ФОТО''') group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        print(finalRes)
        
        if babysitter.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from complementry_services where service_code in (select service_code from servicetype where service_type = '''НЯНЯ''') group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        print(finalRes)
        
        if night.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from trails where nightlighting='''1''' group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        print(finalRes)
        
        if tow.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from trails where lift='''бугельный''' group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        print(finalRes)
        
        if baby.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from trails where lift='''беби-лифт''' group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        print(finalRes)
        
        if rent.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from complementry_services where service_code in (select service_code from servicetype where service_type = '''Аренда''') group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        print(finalRes)
        
        if hire.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from complementry_services where service_code in (select service_code from servicetype where service_type = '''Прокат''') group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        print(finalRes)
        
        if entertainments.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from complementry_services where service_code in (select service_code from servicetype where service_type = '''Развлечения''') group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        print(finalRes)
        
        if fourLift.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from trails where lift='''4-местный кресельный''' group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        
        print(finalRes)
        
        if eightLift.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from trails where lift='''8-мест кабинки''' group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        
        print(finalRes)
        
        if parking.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from complementry_services where service_code in (select service_code from servicetype where service_type = '''Парковка''') group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        
        print(finalRes)
        
        if food.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from complementry_services where service_code in (select service_code from servicetype where service_type = '''Питание''') group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        
        print(finalRes)
        
        if spa.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from complementry_services where service_code in (select service_code from servicetype where service_type = '''СПА''') group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        
        print(finalRes)
        
        if trainer.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from complementry_services where service_code in (select service_code from servicetype where service_type = '''Инструктор''') group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        
        print(finalRes)
        
        if sport.state == NSControl.StateValue.on {
            ids = []
            let res = p.exec(statement: "select resort_id from complementry_services where service_code in (select service_code from servicetype where service_type = '''СПОРТ''') group by resort_id;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                ids.append(c0 ?? "")
            }
            finalRes = Array(Set(finalRes).intersection(Set(ids)))
        }
        
        results = []
        
        for i in finalRes {
            let res1 = p.exec(statement: "select name from resorts where resort_id=$1;", params: [Int(i)])
            let num1 = res1.numTuples()
            for x in 0..<num1 {
                let c0 = res1.getFieldString(tupleIndex: x, fieldIndex: 0)
                results.append(c0 ?? "")
            }
        }
        
        ids = []
        
        print(finalRes)
        
        selectRes.removeAllItems()
        selectRes.addItems(withTitles: results)
    }
    
    func getResorts()->[String] {
        var rs: [String] = []
        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        let res = p.exec(statement: "select resort_id from resorts;")
        let num = res.numTuples()
        for x in 0..<num {
            let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
            rs.append(c0 ?? "")
        }
        return rs
    }
}
