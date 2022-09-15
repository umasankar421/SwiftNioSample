//
//  InterfaceController.swift
//  SwiftNIO WatchKit Extension
//
//  Created by Amaresh K V on 14/09/22.
//

import WatchKit
import Foundation
import MQTTNIO


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        print("awake")
        MQTTManager().connect()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("willActivate")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        print("didDeactivate")
    }
    
    func createSampleMQTTConnection() {
        let client = MQTTClient(
            host: "test.mosquitto.org",
            port: 1883,
            identifier: "watchTestConnection",
            eventLoopGroupProvider: .createNew
        )
        client.connect().whenComplete { result in
            switch result {
            case .success:
                print("Succesfully connected")
            case .failure(let error):
                print("Error while connecting \(error)")
            }
        }
    }

}
