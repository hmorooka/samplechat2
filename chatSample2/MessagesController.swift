//
//  ViewController.swift
//  chatSample2
//
//  Created by 諸岡裕人 on 2016/10/10.
//  Copyright © 2016年 hiroto.morooka. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

	let cellId = "cellId"
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
		
		let image = UIImage(named: "new_message_icon")
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(handleNewMessage))
		
		checkIfUserIsLoggedIn()
		
		//カスタム（セル）クラスを使うときの作法
		tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
		
		observeMessages()
    }
	
	
	var messages = [Message]()
	var messageDictionary = [String: Message]()
	
	
	
//cellの動的なデータ変更の処理。セルの数とセルの内容を決める。---------------------------------------------------------------------------

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		//as! カスタムクラス　で　セルに再利用するカスタムクラスを指定する
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
		
		let message = messages[indexPath.row]
		cell.message = message
		
		return cell
	}
	
	
	//セルの高さを変える処理
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 72
	}
	
	
//メッセージが追加されたらデータベースからsnapshotでテキスト抽出して配列に入れる---------------------------------------------------------------------------
	
	func observeMessages(){
		
		let ref = FIRDatabase.database().reference().child("messages")
		ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
		
			if let dictionary = snapshot.value as? [String: AnyObject]{
				let message = Message()
				message.setValuesForKeysWithDictionary(dictionary)
				
//				self.messages.append(message)
				
				if let toId = message.toId {
					self.messageDictionary[toId] = message
					
					self.messages = Array(self.messageDictionary.values)
					
					self.messages.sortInPlace({ (message1, message2) -> Bool in
						return message1.timestamp?.intValue > message2.timestamp?.intValue
					})
				}
				
				print(message.text)
				
				dispatch_async(dispatch_get_main_queue(), {
					self.tableView.reloadData()
				})
			}
		}, withCancelBlock: nil)
	}

//新規チャット開始画面への移行--------------------------------------------------------------------------------------
	func handleNewMessage(){
		let newMessageController = NewMessageController()
		newMessageController.messagesController = self
		let navController = UINavigationController(rootViewController: newMessageController)
		presentViewController(navController, animated: true, completion: nil)
	}
	

	//ログインしていたらnavbarに名前を表示する/performSelector→ちょっと動作を遅らせて実行したいとかで使う withObjectはhandlelogoutの引数にあたる
	//でも、dispatch_afterを使うほうがいいみたい（ios8から廃止になったらしい）
	func checkIfUserIsLoggedIn(){
		//user is not logged in
		if FIRAuth.auth()?.currentUser?.uid == nil {
			performSelector(#selector(handleLogout), withObject: nil, afterDelay: 0)
		} else {
			fetchUserAndSetupNavBarTitle()
		}
	}
	
	
	//ユーザー名をnavbarに表示するメソッド
	func fetchUserAndSetupNavBarTitle(){
		
		//何かしらの理由でuidがnilの可能性がある。なるべく!のアンラップは使わないほうがいい？ってこと。→下のuid!の！が外れる
		guard let uid = FIRAuth.auth()?.currentUser?.uid else{
			return
		}
		FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
			
			print(snapshot)
			if let dictionary = snapshot.value as? [String: AnyObject] {
				
				self.navigationItem.title = dictionary["name"] as? String
				
				//User()はUser.swiftに定義されているオブジェクトで、name,email,profileImageの変数を持っている
				let user = User()
				user.setValuesForKeysWithDictionary(dictionary)
				//ここでメソッド実行
				self.setupNavBarWithUser(user)
				
			}
			}, withCancelBlock: nil)
		}
	
	//navbarに名前とprofileimageを実装する
	func setupNavBarWithUser(user: User) {
		let titleView = UIView()
		titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
		//        titleView.backgroundColor = UIColor.redColor()
		
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		titleView.addSubview(containerView)
		
		let profileImageView = UIImageView()
		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		profileImageView.contentMode = .ScaleAspectFill
		profileImageView.layer.cornerRadius = 20
		profileImageView.clipsToBounds = true
		if let profileImageUrl = user.profileImageUrl {
			profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
		}
		
		containerView.addSubview(profileImageView)
		
		//ios 9 constraint anchors
		//need x,y,width,height anchors
		profileImageView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
		profileImageView.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
		profileImageView.widthAnchor.constraintEqualToConstant(40).active = true
		profileImageView.heightAnchor.constraintEqualToConstant(40).active = true
		
		let nameLabel = UILabel()
		
		containerView.addSubview(nameLabel)
		nameLabel.text = user.name
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		//need x,y,width,height anchors
		nameLabel.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 8).active = true
		nameLabel.centerYAnchor.constraintEqualToAnchor(profileImageView.centerYAnchor).active = true
		nameLabel.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
		nameLabel.heightAnchor.constraintEqualToAnchor(profileImageView.heightAnchor).active = true
		
		containerView.centerXAnchor.constraintEqualToAnchor(titleView.centerXAnchor).active = true
		containerView.centerYAnchor.constraintEqualToAnchor(titleView.centerYAnchor).active = true
		
		self.navigationItem.titleView = titleView
		
//		titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
	
	}
	
	
//チャット画面に移行する処理--------------------------------------------------------------------------------------
	
	func showChatControllerForUser(user: User) {
		let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewLayout())
		chatLogController.user = user
		navigationController?.pushViewController(chatLogController, animated: true)
		
	}
	
	
	func handleLogout(){
		
		do {
			try FIRAuth.auth()?.signOut()
		} catch let logoutError {
			print(logoutError)
		}
		
		let loginController = LoginController()
		loginController.messagesController = self
		presentViewController(loginController, animated: true, completion: nil)
	}

}

