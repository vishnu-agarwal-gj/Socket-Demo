//
//  File.swift
//  Socket Demo
//
//  Created by Vishnu Agarwal on 31/07/19.
//  Copyright © 2019 Vishnu Agarwal. All rights reserved.
//

import Foundation
import SwiftWebSocket
import Reachability
class SwiftWebSocketDemo {
    static let shared = SwiftWebSocketDemo()
    var timer: Timer?
    let reachability = Reachability()!
    init() {
    }
    func echoTest(){
        var messageNum = 0
        let ws = WebSocket("wss://echo.websocket.org")
        let send : ()->() = {
            messageNum += 1
            let msg = "\(messageNum): \(NSDate().description)"
            print("send: \(msg)")
            ws.send(msg)
        }
        
        ws.event.open = { [weak self] in
            if ws.readyState == .open {
                print("opened")
                self?.timer?.invalidate()
                self?.timer = nil
                send()
            } else {
                print("open but not open")
            }
            
        }
        ws.event.close = { [weak self] code, reason, clean in
            print("close", reason)
            if self?.timer != nil {
                self?.timer?.invalidate()
                self?.timer = nil
            }
            self?.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
                print("timer fired")
                ws.open()
            })
        }
        ws.event.error = { error in
            print("error \(error)")
        }
        ws.event.message = { message in
            if let text = message as? String {
                print("recv: \(text)")
                if messageNum == 10000 {
                    ws.close()
                } else {
                    send()
                }
            }
        }
        
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
