//
//  LoginController+handlers.swift
//  chatSample2
//
//  Created by 諸岡裕人 on 2016/10/11.
//  Copyright © 2016年 hiroto.morooka. All rights reserved.
//

import UIKit
import Firebase

//loginControllerの拡張→ここでmessagesControllerクラスに定義されているメソッドを使う場合
//loginControllerに var messagesController: MessagesControllerを定義する→messagesController.~が使える
extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	
	
	
	
	//registerユーザー登録の処理--------------------------------------------------------------------------------------
	
	func handleRegister(){
		guard let email = emailTextField.text, password = passwordTextField.text, name = nameTextField.text
			else {
				print("Form is not valid")
				return
		}
		
		//ユーザーをfirebaseに登録
		FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
			
			if error != nil {
				print(error)
				return
			}
			
			guard let uid = user?.uid else{
				return
			}
			//successfully authenticated user　データベースに保存
			
			let imageName = NSUUID().UUIDString
			let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
			
			if let profileImage = self.profileImageView.image, uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
			
			
//			if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1){　　→余り安全ではないから上の書き方になった？
			
//			if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
			
				//putdataで画像をアップロードしている
				storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
					
					if error != nil {
						print(error)
						return
					}
					
					//NSURL型をString型に変える時に absoluteStringを使う
					if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
						//valuesに登録情報を格納している
						let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
						self.registerUserIntoDatabaseWithUID(uid, values: values)
					}
				})
			}
		})
	}
	
	
	//データベースに保存するメソッド　引数にはuidとdictionary型のvaluesを取る
	private func registerUserIntoDatabaseWithUID(uid: String, values:[String: AnyObject]){
		
		let ref = FIRDatabase.database().reference()
		
		//ここでdb内にusersフォルダを作成
		let usersReference = ref.child("users").child(uid)
		//updateで更新している
		usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
			
			if err != nil {
				print(err)
				return
			}
			
			//新規登録した時にnavbarの名前が登録者のnamenに変わるようにする
//			self.messagesController?.fetchUserAndSetupNavBarTitle()
			
//			self.messagesController?.navigationItem.title = values["name"] as? String
			
			let user = User()
			
			user.setValuesForKeysWithDictionary(values)
			
			self.messagesController?.setupNavBarWithUser(user)
			
			self.dismissViewControllerAnimated(true, completion: nil)
			print("saved user succesfully into Firebase db ")
		})
		
	}
	
	

	func handleSelectProfileImage(){
		let picker = UIImagePickerController()
		
		picker.delegate = self
		picker.allowsEditing = true
		
		presentViewController(picker, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		
		var selectedImageFromPicker: UIImage?
		
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
			
			selectedImageFromPicker = editedImage
			print(editedImage.size)
			
		} else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			
			selectedImageFromPicker = originalImage
			print(originalImage.size)
		}
		
		if let selectedImage = selectedImageFromPicker {
			profileImageView.image = selectedImage
		}
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
}