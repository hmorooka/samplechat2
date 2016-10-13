//
//  LoginController.swift
//  chatSample2
//
//  Created by 諸岡裕人 on 2016/10/10.
//  Copyright © 2016年 hiroto.morooka. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginController: UIViewController {
	
	//MessagesControllerクラスを使えるようにする記述？
	var messagesController: MessagesController?
	
	
	//登録画面のviewを作る--------------------------------------------------------------------------------------
    
    //inputsContainerView : UIView（型指定？）
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
    //コードからAutoLayoutを使う場合は、falseに指定
        view.translatesAutoresizingMaskIntoConstraints = false
        
    //角丸とそれに合わせてオブジェクトをマスクする処理。セット。
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
	
	
	
	//ボタンを作る--------------------------------------------------------------------------------------
	
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitle("Register", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
		
		//ボタンを押したらhandleLoginResisterメソッドに飛ぶ　TouchUpInsideはイベントの種類
		
		
	//ボタンを押す処理--------------------------------------------------------------------------------------
		
		button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        return button
    }()
	
	//ボタンを押したら発動する　segmentIndexが0か1で判定して login signinで分ける
	func handleLoginRegister(){
		if loginRegisterSegmentedControll.selectedSegmentIndex == 0 {
			handleLogin()
		} else {
			handleRegister()
		}
	}
	
	
	
	//ログインの処理--------------------------------------------------------------------------------------
	
	
	//ログイン実装　guard文で入力漏れがないか確認　その後サインイン処理　コールバックで成功したらdismissViewで画面を変える
	func handleLogin(){
		guard let email = emailTextField.text, let password = passwordTextField.text
			else {
				print("Form is not valid")
				return
		}

		
		FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { ( user, error ) in
			
			if error != nil {
				print(error)
				return
			} else {
				//successfully log in　成功
				print("ログイン成功")
				
				//ログインした時にnavbarのタイトルがログインしたnameに変わるようにする
				self.messagesController?.fetchUserAndSetupNavBarTitle()
				self.dismissViewControllerAnimated(true, completion: nil)
			}
		
		})
	}

	
	

	
	
	
	
	
	
	//ここから
	//viewのセクション-------------------------------------------------------------------------------------------
	
	
	
	
	
	
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
	
	let nameSeparatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let emailTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Email"
		tf.translatesAutoresizingMaskIntoConstraints = false
		return tf
	}()
	
	let emailSeparatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let passwordTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Password"
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.secureTextEntry = true
		return tf
	}()
	
	lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "Resistance-logo.png")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .ScaleAspectFit
		
		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
		imageView.userInteractionEnabled = true
		
		return imageView
	}()
	
	lazy var loginRegisterSegmentedControll: UISegmentedControl = {
		let sc = UISegmentedControl(items: ["Login", "Register"])
		sc.translatesAutoresizingMaskIntoConstraints = false
		sc.tintColor = UIColor.whiteColor()
		sc.selectedSegmentIndex = 1
		sc.addTarget(self, action: #selector(handleLoginRegisterChange), forControlEvents: .ValueChanged)
		return sc
	}()
	
	func handleLoginRegisterChange(){
		//titleForSegmentAtInex(引数は番号　selectedSegmentIndexは番号返す)でセグメントに設定されているタイトルを返す
		let title = loginRegisterSegmentedControll.titleForSegmentAtIndex(loginRegisterSegmentedControll.selectedSegmentIndex)
		loginRegisterButton.setTitle(title, forState: .Normal)
		
		//change height of inputContainerView inputsContainerの高さを変更できる。
		inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControll.selectedSegmentIndex == 0 ? 100 : 150
		
		//change nametextの高さ
		nameTextFieldHeightAnchor?.active = false
		nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControll.selectedSegmentIndex == 0 ? 0 : 1/3)
		nameTextFieldHeightAnchor?.active = true
		
		//change emailtextの高さをログイン押した時に1/2にする
		emailTextFieldHeightAnchor?.active = false
		emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControll.selectedSegmentIndex == 0 ? 1/2 : 1/3)
		emailTextFieldHeightAnchor?.active = true
		
		//change　passwordtextの高さをログイン押した時に1/2にする
		passwordTextFieldHeightAnchor?.active = false
		passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControll.selectedSegmentIndex == 0 ? 1/2 : 1/3)
		passwordTextFieldHeightAnchor?.active = true
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
            view.backgroundColor = UIColor(red: 77/255, green: 177/255, blue: 255/255, alpha: 1)
            
            //view.addSubview()でviewを追加している
            view.addSubview(inputsContainerView)
            view.addSubview(loginRegisterButton)
			view.addSubview(profileImageView)
			view.addSubview(loginRegisterSegmentedControll)
            
            setupInputsContainerView()
            setupLoginRegisterButton()
			setupProfileImageView()
			setupLoginRegisterSegmentedControll()
	}
	
	func setupLoginRegisterSegmentedControll(){
		//need x, y, width, height, constraints
		loginRegisterSegmentedControll.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
		loginRegisterSegmentedControll.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -12).active = true
		loginRegisterSegmentedControll.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
		loginRegisterSegmentedControll.heightAnchor.constraintEqualToConstant(36).active = true
	}
    
	func setupProfileImageView(){
		 //need x, y, width, height, constraints
		profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
		profileImageView.bottomAnchor.constraintEqualToAnchor(loginRegisterSegmentedControll.topAnchor, constant: -6).active = true
		profileImageView.widthAnchor.constraintEqualToConstant(160).active = true
		profileImageView.heightAnchor.constraintEqualToConstant(160).active = true
		
	}
	
		var inputsContainerViewHeightAnchor: NSLayoutConstraint?
		var nameTextFieldHeightAnchor: NSLayoutConstraint?
		var emailTextFieldHeightAnchor: NSLayoutConstraint?
		var passwordTextFieldHeightAnchor: NSLayoutConstraint?
	

        func setupInputsContainerView(){
        //need x, y, width, height, constraints
        
            inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
            inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
            inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
            inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraintEqualToConstant(150)
				inputsContainerViewHeightAnchor!.active = true
			
			inputsContainerView.addSubview(nameTextField)
			inputsContainerView.addSubview(nameSeparatorView)
			inputsContainerView.addSubview(emailTextField)
			inputsContainerView.addSubview(emailSeparatorView)
			inputsContainerView.addSubview(passwordTextField)

			
			//need x, y, width, height constraints
			nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
			nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
			
			nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
			nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
				nameTextFieldHeightAnchor!.active = true
			
			//need x, y, width, height constraints
			nameSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
			nameSeparatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
			nameSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
			nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
			
			//need x, y, width, height constraints
			emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
			emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
			
			emailTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
			
			emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
				emailTextFieldHeightAnchor!.active = true
			
			//need x, y, width, height constraints
			emailSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
			emailSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
			emailSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
			emailSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
			
			//need x, y, width, height constraints
			passwordTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
			passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
			
			passwordTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
			passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
				passwordTextFieldHeightAnchor!.active = true
    }
	
        func setupLoginRegisterButton(){
        //need x, y, width, height, constraints
			
            loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
            loginRegisterButton.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 12).active = true
            loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
            loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    
    
    
    
    //バーアイテムのスタイルを変更する
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension UIColor {

    convenience init(r:CGFloat, g: CGFloat, b: CGFloat) {
    self.init(red: 77/255, green: 177/255, blue: 255/255, alpha: 1)
    }
}
