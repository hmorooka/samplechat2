//
//  ChatLogController.swift
//  chatSample2
//
//  Created by 諸岡裕人 on 2016/10/13.
//  Copyright © 2016年 hiroto.morooka. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate{
	
	
	lazy var inputTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter message..."
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.delegate = self
		return textField
	}()
	
	
	var user: User? {
		didSet {
			navigationItem.title = user?.name
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = UIColor.whiteColor()
		
		setupInputComponents()
	}
	
	func setupInputComponents() {
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(containerView)
		
		//ios9 constraint anchors
		//neet x,y,width,height
		
		containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
		containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
		containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
		containerView.heightAnchor.constraintEqualToConstant(50).active = true
		
		let sendButton = UIButton(type: .System)
		sendButton.setTitle("Send", forState: .Normal)
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
		containerView.addSubview(sendButton)
		
		//need x,y,w,h
		sendButton.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
		sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
		sendButton.widthAnchor.constraintEqualToConstant(80).active = true
		sendButton.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
		
		containerView.addSubview(inputTextField)
		//x,y,w,h
		inputTextField.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8).active = true
		inputTextField.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
//		inputTextField.widthAnchor.constraintEqualToConstant(100).active = true
		inputTextField.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
		inputTextField.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
		
		let separatorLineView = UIView()
		separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
		separatorLineView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(separatorLineView)
		//x,y,w,h
		separatorLineView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
		separatorLineView.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
		separatorLineView.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor).active = true
		separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true
		
	}
	
	
//メッセージを送ってデータベースに登録する処理--------------------------------------------------------------------------------------
	
	//toIdを取るのに
	func handleSend(){
		let ref = FIRDatabase.database().reference().child("messages")
		let childRef = ref.childByAutoId()
		let toId = user!.id!
		print(user!.id!)
		let fromId = FIRAuth.auth()!.currentUser!.uid
		let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
		let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp]
		childRef.updateChildValues(values)
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		handleSend()
		return true
	}
}

















