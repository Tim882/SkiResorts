//
//  exportVC.swift
//  Test
//
//  Created by Тимур on 26.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

class exportVC: NSViewController {
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }

    @IBOutlet weak var path: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func export(_ sender: NSButton) {
        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        switch status {
        case .ok:
            print("ok")
        default:
            goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
        }
        //resorts table
        var res = p.exec(statement: "copy resorts to '/\(path.stringValue)/resorts.csv' delimiter ',' csv header;")
        if res.errorMessage() != "" {
            goAlert(header: "Ошибка", val: res.errorMessage())
        }
        else {
            goAlert(header: "Успешно", val: "Результат в файле resorts.csv")
        }
        //complementry_services table
//        res = p.exec(statement: "copy complementry_services to '/Applications/complementary.csv' delimiter ',' csv header;")
//        if res.errorMessage() != "" {
//            goAlert(header: "Ошибка", val: res.errorMessage())
//        }
//        else {
//            goAlert(header: "Успешно", val: "Результат в файле complementary.csv в папке программы")
//        }
//        //service table
//        res = p.exec(statement: "copy service to '/Applications/service.csv' delimiter ',' csv header;")
//        if res.errorMessage() != "" {
//            goAlert(header: "Ошибка", val: res.errorMessage())
//        }
//        else {
//            goAlert(header: "Успешно", val: "Результат в файле service.csv в папке программы")
//        }
//        //servicetype table
//        res = p.exec(statement: "copy servicetype to '/Applications/servicetype.csv' delimiter ',' csv header;")
//        if res.errorMessage() != "" {
//            goAlert(header: "Ошибка", val: res.errorMessage())
//        }
//        else {
//            goAlert(header: "Успешно", val: "Результат в файле servicetype.csv в папке программы")
//        }
//        //trails table
//        res = p.exec(statement: "copy trails to '/Applications/trail.csv' delimiter ',' csv header;")
//        if res.errorMessage() != "" {
//            goAlert(header: "Ошибка", val: res.errorMessage())
//        }
//        else {
//            goAlert(header: "Успешно", val: "Результат в файле trail.csv в папке программы")
//        }
    }
    
}
