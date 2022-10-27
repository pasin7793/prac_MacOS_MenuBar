//
//  ViewController.swift
//  prac_MacOS_MenuBar
//
//  Created by 임준화 on 2022/10/27.
//

import Cocoa

class ViewController: NSViewController {

    
    var changeStatusButton: NSButton = {
        let btn = NSButton(title: "change to random emoji", target: self, action: #selector(changeStatusButton(_:)))
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.changeStatusButton)
        self.setupContraints()
    }
    
    func setupContraints(){
        NSLayoutConstraint.activate([
            self.changeStatusButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.changeStatusButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc func changeStatusButton(_ sender: NSButton){
        
        let emojis = ["🇰🇷","🇨🇳","🇰🇵","🇺🇸"]
        let randomIndex = Int.random(in: 0..<emojis.count)
        
        if let delegate = NSApplication.shared.delegate as? AppDelegate{
            delegate.statusItem.button?.changeStatus(emojiString: emojis[randomIndex])
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

