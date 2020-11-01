//
//  addReview.swift
//  Test
//
//  Created by Тимур on 14.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

class addReview: NSViewController {
    
    @IBOutlet weak var resorts: NSPopUpButton!
    @IBOutlet weak var rating: NSPopUpButton!
    @IBOutlet weak var reviewField: NSTextField!
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    var names: [String] = []
    var id: [String] = []
    
    @IBAction func add(_ sender: NSButton) {
        var name = ""
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            //print(status)
            if names.count != 0 {
                for i in 0...names.count-1 {
                    if names[i] == resorts.itemTitle(at: resorts.index(of: resorts.selectedItem ?? NSMenuItem())) {
                        name = id[i]
                    }
                }
            }
            
            var res = p.exec(statement: "select * from reviews where user_login=$1 and resort_id=$2;", params: [userLogin, Int(name)])
            print(userLogin)
            var can = true
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0) ?? ""
                let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1) ?? ""
                if c0 == name {
                    can = false
                }
            }
            if can {
                p.exec(statement: "insert into reviews (resort_id, user_login, review, rating) values ($1, $2, $3, $4);", params: [Int(name), userLogin, reviewField.stringValue, Int(rating.index(of: rating.selectedItem ?? NSMenuItem()))+1])
            } else {
                let myalert = NSAlert()
                myalert.messageText = "Ошибка"
                myalert.informativeText = "Вы уже написали отзыв об этом курорте"
                myalert.addButton(withTitle: "OK")
                myalert.runModal()
            }
            self.dismiss(self)
            defer {
                p.close()
            }
        } catch {
            // handle errors
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rating.removeAllItems()
        rating.addItems(withTitles: ["1", "2", "3", "4", "5"])
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            let res = p.exec(statement: "select name, resort_id from resorts;")
            let num = res.numTuples()
            for x in 0..<num {
                let c0 = res.getFieldString(tupleIndex: x, fieldIndex: 0) ?? ""
                let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1) ?? ""
                id.append(c1)
                names.append(c0)
            }
            resorts.removeAllItems()
            resorts.addItems(withTitles: names)
            defer {
                p.close()
            }
        } catch {
            // handle errors
        }
        
    }
}
