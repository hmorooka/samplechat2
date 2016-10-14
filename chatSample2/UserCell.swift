//
//  UserCell.swift
//  chatSample2
//
//  Created by 諸岡裕人 on 2016/10/14.
//  Copyright © 2016年 hiroto.morooka. All rights reserved.
//

import UIKit
import Firebase

//オリジナルセルを作る処理

class UserCell: UITableViewCell {
	
	var message: Message? {
		
		didSet {
		
			if let toId = message?.toId {
			let ref = FIRDatabase.database().reference().child("users").child(toId)
			ref .observeEventType(.Value, withBlock: { (snapshot) in
				
				if let dictionary = snapshot.value as? [String: AnyObject]{
					
					self.textLabel?.text = dictionary["name"] as? String
					
					if let profileImageUrl = dictionary["profileImageUrl"] as? String{
						
						self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
					}
				}
				
				}, withCancelBlock: nil)
		}
		
		self.detailTextLabel?.text = message?.text
			if let seconds = message?.timestamp?.doubleValue{
				let timestampDate = NSDate(timeIntervalSince1970: seconds)
				
				let dateFormatter = NSDateFormatter()
				dateFormatter.dateFormat = "hh:mm:ss a"
				timeLabel.text = dateFormatter.stringFromDate(timestampDate)
			}
	}
}

	override func layoutSubviews() {
		super.layoutSubviews()
		
		//テキスト、ディテールラベルの場所を変える処理
		textLabel?.frame = CGRectMake(64, textLabel!.frame.origin.y - 2, textLabel!.frame.width, textLabel!.frame.height)
		
		detailTextLabel?.frame = CGRectMake(64, detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
	}
	
	//プロファイル写真のviewを変更する処理
	let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 24
		imageView.layer.masksToBounds = true
		imageView.contentMode = .ScaleAspectFill
		return imageView
	}()
	
	let timeLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFontOfSize(12)
		label.textColor = UIColor.darkGrayColor()
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?){
		super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier )
		
		//プロフィール写真の位置を変える処理
		addSubview(profileImageView)
		addSubview(timeLabel)
		
		//ios 9 constraint anchors
		//need x,v,width,height anchors
		profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
		profileImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
		profileImageView.widthAnchor.constraintEqualToConstant(48).active = true
		profileImageView.heightAnchor.constraintEqualToConstant(48).active = true
		
		//need x,v,width,height anchors
		timeLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
		timeLabel.centerYAnchor.constraintEqualToAnchor(self.topAnchor, constant: 18).active = true
		timeLabel.widthAnchor.constraintEqualToConstant(100).active = true
		timeLabel.heightAnchor.constraintEqualToAnchor(textLabel?.heightAnchor).active = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

