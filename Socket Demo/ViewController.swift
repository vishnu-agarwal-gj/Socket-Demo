//
//  ViewController.swift
//  Socket Demo
//
//  Created by Vishnu Agarwal on 31/07/19.
//  Copyright © 2019 Vishnu Agarwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //SwiftWebSocketDemo.shared.echoTest()
        StarScreamDemo.shared.setup()
    }


}

