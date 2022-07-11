//
//  TableView.swift
//  TestingDynamicTableViewDataSource
//
//  Created by Krishna Venkatramani on 29/06/2022.
//

import Foundation
import UIKit

extension UITableView{
	
	private static var propertyKey: UInt8 = 1
	
	private var source: TableViewDataSource? {
		get { return objc_getAssociatedObject(self, &Self.propertyKey) as? TableViewDataSource }
		set { objc_setAssociatedObject(self, &Self.propertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	
	func dequeueCell<T:UITableViewCell>() -> T{
		let identifier = "\(T.self)"
		guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
			register(T.self, forCellReuseIdentifier: identifier)
			return dequeueReusableCell(withIdentifier: identifier) as? T ?? T()
		}
		return cell
	}
	
	func reload(with source: TableViewDataSource){
		self.source = source
		dataSource = self.source
		delegate = self.source
		
		reloadData()
	}
	
}
