//
//  TransionAnimation.swift
//  WaterFlowCollectionView
//
//  Created by 西乡流水 on 17/5/5.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

protocol PresentAnimationDelegate : class
{
    func presentAnimationView() -> UIView
    
    func presentAnimationFromViewFrame() -> CGRect
    
    func presentAnimationToViewFrame() -> CGRect
}

protocol DismissAnimationDelegate : class
{
    func dismissAnimationView() -> UIView
    
    func dismissAnimationFromViewFrame() -> CGRect
    
    func dismissAnimationToViewFrame() -> CGRect
}

class TransitionAnimation: NSObject
{
    var dismissDelegate : DismissAnimationDelegate?
    
    var presentDelegate : PresentAnimationDelegate?
    
    fileprivate let duration : TimeInterval = 3
    
    fileprivate var isPresent : Bool = true
}



// MARK: -UIViewControllerAnimatedTransitioning
//UIViewControllerAnimatedTransitioning 主要是管转场的具体实现的,和UIViewControllerTransitioningDelegate 一起使用的
extension TransitionAnimation : UIViewControllerAnimatedTransitioning
{

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
        
        //present 的时候
        if isPresent
        {
           presentAnimation(transitionContext: transitionContext)
            
        }
        else //dismiss 的时候
        {
           dismissAnimation(transitionContext: transitionContext)
        }
        
    }
    
    
    private  func presentAnimation(transitionContext : UIViewControllerContextTransitioning ) -> Void
    {
        guard let delegate = presentDelegate else {
            return
        }
        
        let animationView = delegate.presentAnimationView()
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {return}
        
        //contaninerView 是专门来装做专场动画的容器
        let contaninerView = transitionContext.containerView
        
        //专场过程中是 animationView 在做动画
        animationView.frame = delegate.presentAnimationFromViewFrame()
        contaninerView.addSubview(animationView)
        
        //目标控制器的View需要手动添加在 contaninerView
        toView.frame = delegate.presentAnimationToViewFrame()
        
        UIView.animate(withDuration: duration, animations: { 
        
            animationView.frame = delegate.presentAnimationToViewFrame()
            
        }) { (finished) in
          
            animationView.removeFromSuperview()
            contaninerView.addSubview(toView)
            transitionContext.completeTransition(true)
            
        }
    
        
    }
    
    private func dismissAnimation(transitionContext : UIViewControllerContextTransitioning ) -> Void
    {
        guard let delegate = dismissDelegate else {
            return
        }
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {return}
        
        let contaninerView = transitionContext.containerView
        
        let animationView = delegate.dismissAnimationView()
        animationView.frame = delegate.dismissAnimationFromViewFrame()
        contaninerView.addSubview(animationView)
        
        fromView.frame = delegate.dismissAnimationToViewFrame()
        
        UIView.animate(withDuration: duration, animations: {
          
            animationView.frame = delegate.dismissAnimationToViewFrame()
            
        }){
          complete in
           
            //在动画完成的时候,要把中间专场的动画View移除,然后在把目标view加到containerView上
            contaninerView.addSubview(fromView)
            animationView.removeFromSuperview()
            //通知专场完成,可以跟用户交互了
            transitionContext.completeTransition(true)
        }
        
    }
    

}

//MARK : UIViewControllerTransitioningDelegate 
//主要是告诉是present 还是dismiss
extension TransitionAnimation : UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        
        return self
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        isPresent = false
        
        return self
    }

}
