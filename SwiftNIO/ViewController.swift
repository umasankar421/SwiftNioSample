//
//  ViewController.swift
//  SwiftNIO
//
//  Created by Amaresh K V on 14/09/22.
//

import UIKit
import MQTTNIO

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MQTTManager().connect()
    }
}

