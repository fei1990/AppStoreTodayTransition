//
//  ViewController.swift
//  TodayTransition
//
//  Created by wf on 2018/11/30.
//  Copyright © 2018 sohu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var navInteractive: NavInteractiveTransition = {
        let navInter = NavInteractiveTransition()
        
        return navInter
    }()
    
    var selectedIndex: IndexPath?

    lazy var table: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 450
//        table.delaysContentTouches = false
//        if #available(iOS 11, *) {
//            table.contentInsetAdjustmentBehavior = .never
//        }
        return table
    }()
    
    let arr = ["1","2","3","4","5","6","7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        
//        self.table.contentInset = UIEdgeInsets.zero
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.imgUrl = arr[indexPath.row]
        
        return cell
    }
    
//    // TODO: 即将进入高亮状态
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        
//        selectedIndex = indexPath
//        
//        let cell = tableView.cellForRow(at: indexPath)
//
//        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
//            cell?.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
//        }) { (complete) in
//            
//        }
//        
//        return true
//    }
//    
//    // TODO: 结束高亮状态
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        
//        if selectedIndex == indexPath {
//            UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//                cell?.transform = CGAffineTransform.identity
//            }) { (complete) in
//                
//            }
//        }
//        
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        self.navigationController?.delegate = self.navInteractive
        
        let detailVc = DetailViewController()
        
        detailVc.detailIndex = indexPath
        
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
}
