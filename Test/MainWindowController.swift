//
//  MainWindowController.swift
//  Test
//
//  Created by Тимур on 10.12.2019.
//  Copyright © 2019 Luffor. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    convenience override init(window: NSWindow?) {
        self.init(windowNibName: "MainWindowController")
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        contentViewController = ViieController()
    }
    
}
