//
//  AccountViewController.swift
//  Test
//
//  Created by Тимур on 12.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa
import PerfectPostgreSQL

var userLogin = ""

class AccountViewController: NSViewController {
    
    
    @IBOutlet weak var adminBtn: NSButton!
    @IBOutlet weak var clientBtn: NSButton!
    
    func goAlert(header: String, val: String) {
        let myalert = NSAlert()
        myalert.messageText = header
        myalert.informativeText = val
        myalert.addButton(withTitle: "OK")
        myalert.runModal()
    }
    
    @IBAction func enter(_ sender: NSButton) {
        var exist = false
        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        switch status {
        case .ok:
            print("ok")
        default:
            goAlert(header: "Ошибка", val: "не удалось подключиться к серверу, попробуйте перезагрузить приложение или зайти позднее")
        }
        if (userNameSignIn.stringValue != "" && userPasswordSignIn.stringValue != "") {
            let res = p.exec(statement: "select * from users where user_login = $1;", params: [userNameSignIn.stringValue])
            let num = res.numTuples()
            for x in 0..<num {
                let c1 = res.getFieldString(tupleIndex: x, fieldIndex: 0)
                let c2 = res.getFieldString(tupleIndex: x, fieldIndex: 1)
                let c3 = res.getFieldString(tupleIndex: x, fieldIndex: 2)
                if (userNameSignIn.stringValue == c1 && userPasswordSignIn.stringValue == c2 && c3 == "client") {
                    userLogin = userNameSignIn.stringValue
                    userNameSignIn.stringValue = ""
                    userPasswordSignIn.stringValue = ""
                    print("\(userLogin) user login")
                    clientBtn.isEnabled = false
                    clientBtn.isEnabled = true
                    let myalert = NSAlert()
                    myalert.messageText = "Отлично"
                    myalert.informativeText = "Чтобы войти в ваш аккаунт, нажмите на кнопку Войти как клиент"
                    myalert.addButton(withTitle: "OK")
                    myalert.runModal()
                    exist = true
                }
                else if (userNameSignIn.stringValue == c1 && userPasswordSignIn.stringValue == c2 && c3 == "worker") {
                    userNameSignIn.stringValue = ""
                    userPasswordSignIn.stringValue = ""
                    workerLogin = userNameSignIn.stringValue
                    clientBtn.isEnabled = false
                    adminBtn.isEnabled = true
                    let myalert = NSAlert()
                    myalert.messageText = "Отлично"
                    myalert.informativeText = "Чтобы войти в ваш аккаунт, нажмите на кнопку Войти как администратор"
                    myalert.addButton(withTitle: "OK")
                    myalert.runModal()
                    exist = true
                }
                else if (userNameSignIn.stringValue == c1 && userPasswordSignIn.stringValue != c2) {
                    clientBtn.isEnabled = false
                    adminBtn.isEnabled = false
                    
                    let myalert = NSAlert()
                    myalert.messageText = "Ошибка"
                    myalert.informativeText = "неверный логин или пароль"
                    myalert.addButton(withTitle: "OK")
                    myalert.runModal()
                    exist = true
                }
            }
            if (exist != true) {
                let myalert = NSAlert()
                myalert.messageText = "Ошибка"
                myalert.informativeText = "такой пользователь не существует"
                myalert.addButton(withTitle: "OK")
                myalert.runModal()
            }
        }
        else {
            clientBtn.isEnabled = false
            adminBtn.isEnabled = false
            
            let myalert = NSAlert()
            myalert.messageText = "Ошибка"
            myalert.informativeText = "field is empty"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
        p.close()
    }
    
    @IBOutlet weak var userPasswordSignIn: NSTextField!
    @IBOutlet weak var userNameSignIn: NSTextField!
    @IBOutlet weak var userName: NSTextField!
    @IBOutlet weak var userPassword: NSTextField!
    
    @objc(User)
    class User: NSObject {
        @objc var name: String?
        @objc var fullName: String?
        @objc var adress: String?
        
        init(name: String?, fullName: String?, adress: String?) {
            self.name = name
            self.fullName = fullName
            self.adress = adress
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        clientBtn.isEnabled = false
        adminBtn.isEnabled = false
    }
    
    @IBAction func signUpButton(_ sender: NSButton) {
        let p = PGConnection()
        let status = p.connectdb("postgresql://client:123@localhost:5432/ski_resorts")
        if (userName.stringValue != "" && userPassword.stringValue != "") {
            let result = p.exec(statement: "insert into users (user_login, user_password, privilege) values ($1, $2, $3)",params: [userName.stringValue, userPassword.stringValue, "client"])
            let myalert = NSAlert()
            myalert.messageText = "Поздравляем"
            myalert.informativeText = "пользователь успешно зарегистрирован"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
        else {
            clientBtn.state = .off
            adminBtn.state = .off
            
            let myalert = NSAlert()
            myalert.messageText = "Ошибка"
            myalert.informativeText = "field is empty"
            myalert.addButton(withTitle: "OK")
            myalert.runModal()
        }
        p.close()
    }
    
}
