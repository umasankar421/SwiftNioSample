//
//  MQTTManager.swift
//  SwiftNIO
//
//  Created by Buddi, Umasankar on 15/09/22.
//

import Foundation
import MQTTNIO

class MQTTManager {
    var client: MQTTClient?
    var uuid: String?
    var status: Bool {
        client?.isActive() ?? false
    }
    
    func connect() {
        self.client = MQTTClient(
                            host: "test.mosquitto.org",
                            port: 1883,
                            identifier: "watchTestConnection",
                            eventLoopGroupProvider: .createNew
                        )

        if let isActive = self.client?.isActive(), !isActive {
            do {
                _ = try self.client?.connect().wait()
                print("socket connection completed")
            } catch let error {
                print("connection error \(error)")
                self.disconnect()
            }
        }
        self.client?.addPublishListener(named: "Respone", { result in
            switch result {
                case .success(let buffer) :
                    var publish = buffer.payload
                    let message = publish.readString(length: publish.readableBytes)
                    print("Message : \(String(describing: message))")
                    guard buffer.topicName.hasSuffix("reported") else { return }
                    DispatchQueue.main.async {
                        var publish = buffer.payload
                        let message = publish.readString(length: publish.readableBytes)
                    }
                case .failure(_) :
                    return
            }
        })
        self.client?.addCloseListener(named: "Closing", { _ in
            print("Closing connection by library")
            self.disconnect()
        })
    }
    func disconnect() {
        print("connection disconnected")
        try? self.client?.disconnect()
        try? self.client?.syncShutdownGracefully()
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
