//
//  NewMessageController.swift
//  chatSample2
//
//  Created by 諸岡裕人 on 2016/10/11.
//  Copyright © 2016年 hiroto.morooka. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
	
	let cellId = "cellId"
	
	//空の配列を用意する
	var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cnacel", style: .Plain, target: self, action: #selector(handleCancel))
		
		tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
		
		//userの情報を取るためのメソッド
		fetchUser()
    }
	
	//usersの情報を取る
	func fetchUser(){
		FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
			
			if let dictionary = snapshot.value as? [String: AnyObject] {
				let user = User()
				user.id = snapshot.key
				user.setValuesForKeysWithDictionary(dictionary)
				//空の配列usersに、userに入っているdictionaryを追加する
				self.users.append(user)
				
				//　backgournd threadのためうまくいかないので、dispatchを使う
				dispatch_async(dispatch_get_main_queue(), {
				self.tableView.reloadData()
				})
			}

		}, withCancelBlock: nil)
	}
	
	func handleCancel(){
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	//テーブル数を決める。.countを使う
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	//セルに識別子(cellId)をつけて再利用する
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		//dequeueを使う
//		let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
		
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
		
		let user = users[indexPath.row]
		cell.textLabel?.text = user.name
		cell.detailTextLabel?.text = user.email
		
//		cell.imageView?.image = UIImage(named: "c3po.jpg")
//		cell.imageView?.contentMode = .ScaleAspectFill
		
		if let profileImageUrl = user.profileImageUrl {
			
			cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
			
//			let url = NSURL(string: profileImageUrl)
//			NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
//				
//					if error != nil {
//						print(error)
//						return
//					}
//				dispatch_async(dispatch_get_main_queue(), {
//					cell.profileImageView.image = UIImage(data: data!)
//					})
//				}).resume()
		}
		
		return cell
	}
	
	//セルの高さを変える処理
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 72
	}
	
	var messagesController: MessagesController?
	
	//tableviewクラスにオーバーライドする。テーブルの行をセレクトしたら動く処理
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		dismissViewControllerAnimated(true){
			print("Dismiss completed")
			let user = self.users[indexPath.row]
			self.messagesController?.showChatControllerForUser(user)
		}
	}
  }























