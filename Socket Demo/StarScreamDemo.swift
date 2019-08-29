//
//  File.swift
//  Socket Demo
//
//  Created by Vishnu Agarwal on 31/07/19.
//  Copyright © 2019 Vishnu Agarwal. All rights reserved.
//

import Foundation
import Starscream
protocol GSocketDelegate {
}
enum GSocketState {
    case disconnected
    case connected
    case connecting
}
class StarScreamDemo {
    var socket: WebSocket?
    var state: GSocketState = .disconnected
    static let shared = StarScreamDemo()
    var address: String = "ws://10.120.9.103:8080"
    var jwtToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImUxYjY5MTc3LTYyMzMtNDBhMS1hZmU5LTJmZGFmNTkwZjdlNCJ9.9cQDP95Xxz2iwSAsNBsD9L8JlYglKtFPF0Sjj2798-Q"
    func getStarted() {
        getSocketAddress()
    }
    func getSocketAddress() {
        var urlComponents = URLComponents.init()
        urlComponents.scheme = "https"
        urlComponents.host = Api.host
        urlComponents.path = Api.chatConnection
        guard let url = urlComponents.url else { return }
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(String(format: "Bearer %@", Token.auth), forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(json)
            if let json = json as? [String: AnyObject], let address = json["data"]?["address"] as? String, let jwtToken = json["data"]?["token"] as? String {
                self.address = "wss://"+address
                self.jwtToken = jwtToken
                print("Address: ", address, "\nJWTToken: ", jwtToken)
                self.setupSocket()
                self.connect()
            }
            }.resume()
    }
    func sendMessage(message: String) {
        
    }
    func setupSocket() {
        socket = WebSocket(url: URL(string: address)!)
        //websocketDidConnect
        socket?.onConnect = { [weak self] in
            self?.sendAuthMessage()
        }
        //websocketDidDisconnect
        socket?.onDisconnect = { (error: Error?) in
            print("websocket is disconnected: \(error?.localizedDescription ?? "")")
            //self?.socket?.connect()
        }
        //websocketDidReceiveMessage
        socket?.onText = { (text: String) in
            print("Received Text: \(text)")
        }
        //websocketDidReceiveData
        socket?.onData = { (data: Data) in
            let message = String.init(data: data, encoding: .utf8)
            print("Received Data: \(data.count), content is : \(message ?? "empty")")
        }
    }
    func connect() {
        state = .connecting
        socket?.connect()
    }
    func sendAuthMessage() {
        var dictionary = [String: AnyObject]()
        dictionary["auth_token"] = self.jwtToken as AnyObject
        dictionary["event_type"] = "auth" as AnyObject
        let str = String(format: "{\"auth_token\":\"%@\", \"event_type\":\"auth\"}", self.jwtToken)
        if let _ = try? JSONSerialization.data(withJSONObject: dictionary) {
            self.socket?.write(string: str, completion: {
                print("successfully sent message")
            })
        }
    }
}
