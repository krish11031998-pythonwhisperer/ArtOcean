//
//  TopCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import UIKit

class TopCollectionView: UITableView {

    private let collection:[Any]? = nil
    
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(TopCollectionTableCellViewTableViewCell.self, forCellReuseIdentifier: TopCollectionTableCellViewTableViewCell.identifier)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    init(frame:CGRect = .zero) {
        super.init(frame: frame, style: .plain)
        
        self.register(TopCollectionTableCellViewTableViewCell.self, forCellReuseIdentifier: TopCollectionTableCellViewTableViewCell.identifier)
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.isScrollEnabled = false
        self.delegate = self
        self.dataSource = self
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLayout(){
        self.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.heightAnchor.constraint(equalTo:self.heightAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopCollectionTableCellViewTableViewCell.identifier, for: indexPath) as? TopCollectionTableCellViewTableViewCell else {
            return UITableViewCell()
        }
        return cell 
    }
    
}
