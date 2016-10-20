//
//  NewMessageController.swift
//  gameofchats
//
//  Created by Brian Voong on 6/29/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
	
	let cellId = "cellId"
	
	var users = [User]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(handleCancel))
		
		tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
		
		fetchUser()
	}
	
	//usersの情報を取る
	func fetchUser() {
		FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
			
			if let dictionary = snapshot.value as? [String: AnyObject] {
				let user = User()
				user.id = snapshot.key
				
				//if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
				user.setValuesForKeysWithDictionary(dictionary)
				//空の配列usersに、userに入っているdictionaryを追加する
				self.users.append(user)
				
				//　backgournd threadのためうまくいかないので、dispatchを使う
				//this will crash because of background thread, so lets use dispatch_async to fix
				dispatch_async(dispatch_get_main_queue(), {
					self.tableView.reloadData()
				})
				
				//                user.name = dictionary["name"]
			}
			
			}, withCancelBlock: nil)
	}
	
	func handleCancel() {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	//セルに識別子(cellId)をつけて再利用する
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
		
		let user = users[indexPath.row]
		cell.textLabel?.text = user.name
		cell.detailTextLabel?.text = user.email
		
		if let profileImageUrl = user.profileImageUrl {
			cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
		}
		
		return cell
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 72
	}
	
	var messagesController: MessagesController?
	
	//tableviewクラスにオーバーライドする。テーブルの行をセレクトしたら動く処理
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		dismissViewControllerAnimated(true) {
			print("Dismiss completed")
			let user = self.users[indexPath.row]
			self.messagesController?.showChatControllerForUser(user)
		}
	}
	
}








