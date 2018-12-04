//
//  NavInteractiveTransition.swift
//  TodayTransition
//
//  Created by wf on 2018/12/3.
//  Copyright © 2018 sohu. All rights reserved.
//

import Foundation
import UIKit

enum NavOperation {
    case pushOperation
    case popOperation
    case none
}

class NavInteractiveTransition: NSObject, UINavigationControllerDelegate {
    
    var gesture: UIPanGestureRecognizer?
    
    private lazy var percentIntractive: DrivePercentAnimation = {
        let percentIntractive = DrivePercentAnimation(self.gesture!)
        return percentIntractive
    }()
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return CustomAnimation(.pushOperation)
        }
        
        if operation == .pop {
            return CustomAnimation(.popOperation)
        }
        
        return nil
        
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard let _ = gesture else {
            return nil
        }
        
        return self.percentIntractive
        
    }
    
}

class CustomAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: NavOperation = .none
    
    lazy var blurEffectView: UIVisualEffectView = {
        let beffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: beffect)
        blurView.frame = UIScreen.main.bounds
        return blurView
    }()
    
    convenience init(_ operation: NavOperation) {
        self.init()
        self.operation = operation
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 1.1
        
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

//        let fromViewController = transitionContext.viewController(forKey: .from)
        
        if self.operation == .pushOperation {
            
            pushAnimation(using: transitionContext)
            
        }else if self.operation == .popOperation {
            popAnimation(using: transitionContext)
        }
        
    }
    
    private func pushAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from)
        
        let toView = transitionContext.view(forKey: .to)
        
        toView?.backgroundColor = UIColor.white
        
        let toViewController = transitionContext.viewController(forKey: .to)
        
        containerView.addSubview(blurEffectView)
        
        containerView.addSubview(toView!)
        
        toView?.backgroundColor = UIColor.clear
        
        guard let fromV = fromView, let toVc = toViewController as? DetailViewController ,let cell = getCellFrom(from: fromV, viewController: toVc) else {
            return
        }
        
        guard let imgView = cell.viewWithTag(999) as? UIImageView, let detailTable = toView?.viewWithTag(100) as? UITableView else {
            return
        }
        
        if #available(iOS 11, *) {
            detailTable.contentInsetAdjustmentBehavior = .never
        }else {
            toViewController?.automaticallyAdjustsScrollViewInsets = false
        }
        
        let convertFrame = cell.convert((imgView.frame), to: fromView)
        
//        let tableHeaderImg = UIImageView(image: imgView.image)
//        tableHeaderImg.contentMode = .scaleAspectFill
//        imgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: convertFrame.height)
        imgView.layer.cornerRadius = 0
        detailTable.tableHeaderView = imgView
        
        detailTable.frame = convertFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            detailTable.frame = (fromView?.frame)!
            
            DispatchQueue.main.async {
                detailTable.reloadData()
            }
            
        }) { (complete) in
            
//            self.blurEffectView.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
        
    }
    
    private func popAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        
        let toView = transitionContext.view(forKey: .to)
        
        let fromView = transitionContext.view(forKey: .from)
        
        guard let toV = toView, let fromVc = fromViewController as? DetailViewController ,let cell = getCellFrom(from: toV, viewController: fromVc), let fromV = fromView else {
            return
        }
        
        containerView.addSubview(toV)
        containerView.addSubview(fromV)
        
        guard let detailTable = fromV.viewWithTag(100) as? UITableView, let imgView = detailTable.tableHeaderView as? UIImageView else {
            return
        }
        
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 10
        
        detailTable.layer.masksToBounds = true
        detailTable.layer.cornerRadius = 10
        
        let convertFrame = cell.convert(CGRect(x: 20, y: 20, width: cell.frame.width - 40, height: cell.frame.height - 40), to: fromV)
        
//        detailTable.transform = CGAffineTransform.identity
        
        DispatchQueue.main.async {
            detailTable.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            detailTable.frame = convertFrame
            
        }) { (complete) in
            
            cell.addSubview(imgView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
        
    }
    
    
    private func getCellFrom(from view: UIView, viewController: UIViewController) -> UITableViewCell? {
        
        if let detailVc = viewController as? DetailViewController {
            
            for v in view.subviews {
                if let table = v as? UITableView {
                    return table.cellForRow(at: detailVc.detailIndex!)
                }
            }
        }
        
        return nil
        
    }
    
    
}

class DrivePercentAnimation: UIPercentDrivenInteractiveTransition {
    
    var panGesture: UIPanGestureRecognizer!
    
    convenience init(_ gesture: UIPanGestureRecognizer) {
        self.init()
        
        panGesture = gesture
        
        panGesture.addTarget(self, action: #selector(gestureRecognizeDidUpdate(_:)))
        
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        super.startInteractiveTransition(transitionContext)
        
    }
    
    @objc func gestureRecognizeDidUpdate(_ pan: UIPanGestureRecognizer) {
        
        let scale = percentForGesture(pan)
        print(scale)
        switch pan.state {
        case .began:
            break
        case .changed:
//            update(1 - scale)
            
            if scale > 0.9 {
                pan.view?.transform = CGAffineTransform(scaleX: scale, y: scale)
            }else {
                finish()
            }
            
        case .ended:
            if scale < 0.9 {
                finish()
            }else {
                UIView.animate(withDuration: 0.3) {
                    pan.view?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                cancel()
            }
        default:
            cancel()
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
