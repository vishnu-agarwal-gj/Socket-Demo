//
//  ViewController.swift
//  Socket Demo
//
//  Created by Vishnu Agarwal on 31/07/19.
//  Copyright © 2019 Vishnu Agarwal. All rights reserved.
//

import UIKit
import Network
class ViewController: UIViewController {
    let arrayDummyMessages = ["Hey", "hiii", "hello"]
    let tableNode = ASTableNode.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        StarScreamDemo.shared.getStarted()
        tableNode.frame = view.bounds
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubnode(tableNode)
        tableNode.delegate = self
        tableNode.dataSource = self
    }
}
extension ViewController: ASTableDelegate, ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return arrayDummyMessages.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard arrayDummyMessages.count > indexPath.row else { return { ASCellNode() } }
        
        let message = arrayDummyMessages[indexPath.row]
        
        // this may be executed on a background thread - it is important to make sure it is thread safe
        let cellNodeBlock = { () -> ASCellNode in
            let cellNode = MessageCell()
            cellNode.text = message
            return cellNode
        }
        
        return cellNodeBlock
    }
}
class MessageCell: ASTextCellNode {
    
}
