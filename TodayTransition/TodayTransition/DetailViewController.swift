//
//  DetailViewController.swift
//  TodayTransition
//
//  Created by wf on 2018/11/30.
//  Copyright © 2018 sohu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailIndex: IndexPath?
    
    private lazy var navTransition: NavInteractiveTransition = {
        let nav = NavInteractiveTransition()
        
        return nav
    }()
    
    var panGesture: UIPanGestureRecognizer!

    lazy var table: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.rowHeight = 360
        table.tag = 100
//        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.table)
        
        
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage(named: "btn_close"), for: .normal)
        btn.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: 30, width: 30, height: 30)
        btn.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
        btn.tag = 99
        view.addSubview(btn)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = false
//    }
    
    @objc private func closeAction(_ btn: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        
        var scale = percentForGesture(pan)
//        print(scale)
        
        switch pan.state {
        case .possible, .began:
//            self.navigationController?.delegate = self.navTransition
//            self.navTransition.gesture = panGesture
            break
        case .changed:
            
            let btn = view.viewWithTag(99)
            
            if scale >= 0.85 {
                self.table.transform = CGAffineTransform(scaleX: scale, y: scale)

                btn?.alpha =  1 - (1 - scale) * 1 / 0.15
                
                self.table.layer.masksToBounds = true
                self.table.layer.cornerRadius = (1 - scale) * 10 / 0.15
                
            }else {
                scale = 0.85
                self.navigationController?.popViewController(animated: true)
                self.table.transform = CGAffineTransform.identity
                btn?.alpha = 0
                btn?.removeFromSuperview()

            }
            
            break
            
        case .cancelled, .ended, .failed:
            UIView.animate(withDuration: 0.3) {
                self.table.transform = CGAffineTransform.identity
                let btn = self.view.viewWithTag(99)
                
                btn?.alpha = 1
            }
        }
        
    }
    
    private func percentForGesture(_ ges: UIPanGestureRecognizer) -> CGFloat {
        
        let transition = ges.translation(in: ges.view)
        
        var scale = 1 - transition.x / UIScreen.main.bounds.width
        
        scale = scale < 0 ? 0 : scale
        
        scale = scale > 1 ? 1 : scale
        
        return scale
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text = "若无法全局掌控，就指派专人负责这是我在项目中做的最错误的地方。由于种种原因，我无法掌握到项目的每个要点和细节。而项目中有三个开发。我并没指明其中某一个来负责整个项目，所有事情都让他们自己商量。从客户对接来的问题，我也是仅告知对应的开发。整个项目中，没有一个人对项目中的每个要点了如指掌。反思：1.手里捏着管理的权利，却没有做到管理的事情。是我在这个项目里最大的问题2.授权！授权！授权！如果自己无法亲力亲为投入项目管理工作，就授权给团队某个成员管理权限，让他代替你去做管理工作3.管理一人，总比管理多个人轻松，也更有效"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.navigationController?.popViewController(animated: true)
    }
    
}
