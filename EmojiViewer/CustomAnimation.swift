//
//  CustomAnimation.swift
//  EmojiViewer
//
//  Created by Colin Reisterer on 12/15/18.
//  Copyright © 2018 FullyTyped. All rights reserved.
//

import UIKit

class EmojiTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return EmojiAnimationController(isPresenting: true)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return EmojiAnimationController(isPresenting: false)
  }

}

class EmojiAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

  init(isPresenting: Bool) {
    self.isPresenting = isPresenting
  }

  private let isPresenting: Bool

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to)
      else {
        transitionContext.completeTransition(true)
        return
    }

    let containerView = transitionContext.containerView

    // add toVC.view as subview. If dismissing, make sure it is under the presented view!
    if isPresenting {
      containerView.addSubview(toVC.view)
    } else {
      containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
    }
    toVC.view.frame = containerView.bounds

    let emojiVC = (isPresenting ? fromVC : toVC) as! EmojiViewController
    let bigEmojiVC = (isPresenting ? toVC : fromVC) as! BigEmojiViewController

    guard let initialFrame = emojiVC.selectedEmojiFrame else {
      assertionFailure("Selected emoji frame not set before presentation")
      transitionContext.completeTransition(true)
      return
    }

    // ensure views laid out for snapshots and positioning
    containerView.layoutIfNeeded()

    let emojiSnapshot = bigEmojiVC.label.snapshotView(afterScreenUpdates: true)!
    containerView.addSubview(emojiSnapshot)
    emojiSnapshot.frame = bigEmojiVC.label.frame

    let initialPosition = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
    let initialScale = initialFrame.height / emojiSnapshot.bounds.height

    // setup for animation
    bigEmojiVC.label.isHidden = true  // snapshot stands in for this view
    if isPresenting {
      emojiSnapshot.center = initialPosition
      emojiSnapshot.transform = CGAffineTransform.identity.scaledBy(x: initialScale, y: initialScale)
      bigEmojiVC.view.alpha = 0.0
    }

    // define animations
    let animations: () -> ()
    if isPresenting {
      animations = {
        emojiSnapshot.center = bigEmojiVC.label.center
        emojiSnapshot.transform = .identity
        bigEmojiVC.view.alpha = 1.0
      }
    } else {
      animations = {
        emojiSnapshot.center = initialPosition
        emojiSnapshot.transform = CGAffineTransform.identity.scaledBy(x: initialScale, y: initialScale)
        bigEmojiVC.view.alpha = 0.0
      }
    }

    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: animations) { _ in
      bigEmojiVC.label.isHidden = false
      emojiSnapshot.removeFromSuperview()
      transitionContext.completeTransition(true)
    }

  }

}

