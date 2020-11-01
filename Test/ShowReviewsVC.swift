//
//  ShowReviewsVC.swift
//  Test
//
//  Created by Тимур on 13.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

@objc(Review)
class Review: NSObject {
    @objc var userLogin: String?
    @objc var review: String?
    @objc var rating: String?

    
    init(userLogin: String?, review: String?, rating: String?) {
        self.userLogin = userLogin
        self.review = review
        self.rating = rating
    }
}

class ShowReviewsVC: NSViewController {
    
    var names: [String] = []
    var id: [String] = []
    
    @IBOutlet weak var resorts: NSPopUpButton!
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    

    @IBAction func delete(_ sender: NSButton) {
        var name = ""
        if names.count != 0 {
            for i in 0...names.count-1 {
                if names[i] == resorts.itemTitle(at: resorts.index(of: resorts.selectedItem ?? NSMenuItem())) {
                    name = id[i]
                }
            }
        }

        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        switch status {
        case .ok:
            print("ok")
        default:
            goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
        }
        let res = p.exec(statement: "delete from reviews where resort_id=$1 and user_login=$2;", params: [Int(name), userLogin])
        let myalert = NSAlert()
        if res.errorMessage() == "" {
            myalert.messageText = "Успешно удален"
        }
        else {
            myalert.messageText = "Ошибка"
            myalert.informativeText = res.errorMessage()
        }
        myalert.addButton(withTitle: "OK")
        myalert.runModal()

    }
    
    var reviews: [Review] = []
    
    @IBOutlet var reviewsArray: NSArrayController!
    
    @IBAction func show(_ sender: NSButton) {
        reviewsArray.remove(contentsOf: reviews)
        reviews = []
        
        var name = ""
        if names.count != 0 {
            for i in 0...names.count-1 {
                if names[i] == resorts.itemTitle(at: resorts.index(of: resorts.selectedItem ?? NSMenuItem())) {
                    name = id[i]
                }
            }
        }

        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        switch status {
        case .ok:
            print("ok")
        default:
            goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
        }
        let res = p.exec(statement: "select * from reviews where resort_id=$1;", params: [Int(name)])
        let num = res.numTuples()
        for x in 0..<num {
            let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
            let c2 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
            let c3 = res.getFieldString(tupleIndex: x, fieldIndex: 3)
            reviews.append(Review(userLogin: c1, review: c2, rating: c3))
        }
        for i in reviews {
            self.reviewsArray.addObject(i)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let p = PGConnection()
            let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
            switch status {
            case .ok:
                print("ok")
            default:
                goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
            }
            var res = p.exec(statement: "select name, resort_id from resorts;")
            var num = res.numTuples()
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
