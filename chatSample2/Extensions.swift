//
//  Extensions.swift
//  chatSample2
//
//  Created by 諸岡裕人 on 2016/10/11.
//  Copyright © 2016年 hiroto.morooka. All rights reserved.
//


//キャッシュの処理？　これをやるとデータ通信量が小さくなって早くなる？キャッシュに残っているものはそのまま使うとかそういう類の話かも？



import UIKit

let imageCache = NSCache()

extension  UIImageView {
	
	
	func loadImageUsingCacheWithUrlString(urlString: String){
		
		self.image = nil
		
		//check cache for image first
		if let cachedImage = imageCache.objectForKey(urlString) as? UIImage{
			self.image = cachedImage
			return
		}
		
		
		//otherwise fire off a new download
		let url = NSURL(string: urlString)
		NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
			
			if error != nil {
				print(error)
				return
			}
			dispatch_async(dispatch_get_main_queue(), {
				if let downloadImage = UIImage(data: data!) {
					
					imageCache.setObject(downloadImage, forKey: urlString)
					self.image = UIImage(data: data!)
					
				}
			})
		}).resume()
	}
	
	
}
