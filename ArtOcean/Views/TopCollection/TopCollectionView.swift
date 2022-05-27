//
//  TopCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import UIKit

class TopCollectionView: UIView {

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
    
    private lazy var titleView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 15
        
        let title:UILabel = self.labelBuilder(text: "Top Collection", size: 16, weight: .bold, color: .appBlackColor, numOfLines: 1)
        
        let seeAll:UILabel = self.labelBuilder(text: "View All", size: 14, weight: .medium, color: .appGrayColor, numOfLines: 1)
        seeAll.textAlignment = .right
        
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(seeAll)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleView)
        self.addSubview(self.tableView)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    
    func setupLayout(){
        self.titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:15).isActive = true
        self.titleView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30).isActive = true
        self.titleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.titleView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor,constant: 10).isActive = true
        self.tableView.heightAnchor.constraint(equalTo: self.heightAnchor,constant: -30).isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30).isActive = true
    }

}

extension TopCollectionView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height * 0.3
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
