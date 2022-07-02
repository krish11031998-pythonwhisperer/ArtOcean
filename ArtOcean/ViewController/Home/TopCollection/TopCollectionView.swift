//
//  TopCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import UIKit

class TopCollectionView: UITableView {

    private let collection:[Any]? = nil

    init(frame:CGRect = .zero) {
        super.init(frame: frame, style: .plain)
        
        self.register(TopCollectionTableCell.self, forCellReuseIdentifier: TopCollectionTableCell.identifier)
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.isScrollEnabled = false
        self.delegate = self
        self.dataSource = self
        
        self.translatesAutoresizingMaskIntoConstraints = false

    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension TopCollectionView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collection?.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopCollectionTableCell.identifier, for: indexPath) as? TopCollectionTableCell else {
            return UITableViewCell()
        }
        
        return cell 
    }
    
}
