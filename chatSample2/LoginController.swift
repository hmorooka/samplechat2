//
//  LoginController.swift
//  chatSample2
//
//  Created by 諸岡裕人 on 2016/10/10.
//  Copyright © 2016年 hiroto.morooka. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
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
	
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitle("Register", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        return button
    }()
    
    
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
	
	let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "Resistance-logo.png")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .ScaleAspectFit
		return imageView
	}()
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
            view.backgroundColor = UIColor(red: 77/255, green: 177/255, blue: 255/255, alpha: 1)
            
            //view.addSubview()でviewを追加している
            view.addSubview(inputsContainerView)
            view.addSubview(loginRegisterButton)
			view.addSubview(profileImageView)
            
            setupInputsContainerView()
            setupLoginRegisterButton()
			setupProfileImageView()
	}
    
	func setupProfileImageView(){
		 //need x, y, width, height, constraints
		profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
		profileImageView.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -12).active = true
		profileImageView.widthAnchor.constraintEqualToConstant(200).active = true
		profileImageView.heightAnchor.constraintEqualToConstant(200).active = true
		
	}
	
	
        func setupInputsContainerView(){
        //need x, y, width, height, constraints
        
            inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
            inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
            inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
            inputsContainerView.heightAnchor.constraintEqualToConstant(150).active = true
			
			inputsContainerView.addSubview(nameTextField)
			inputsContainerView.addSubview(nameSeparatorView)
			inputsContainerView.addSubview(emailTextField)
			inputsContainerView.addSubview(emailSeparatorView)
			inputsContainerView.addSubview(passwordTextField)

			
			//need x, y, width, height constraints
			nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
			nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
			
			nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
			nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3).active = true
			
			//need x, y, width, height constraints
			nameSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
			nameSeparatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
			nameSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
			nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
			
			//need x, y, width, height constraints
			emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
			emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
			
			emailTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
			emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3).active = true
			
			//need x, y, width, height constraints
			emailSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
			emailSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
			emailSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
			emailSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
			
			//need x, y, width, height constraints
			passwordTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
			passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
			
			passwordTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
			passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3).active = true
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
