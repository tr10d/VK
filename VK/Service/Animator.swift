//
//  Animator.swift
//  VK
//
//  Created by  Sergei on 27.01.2021.
//

import UIKit

// MARK: Enumes

enum Direction {
    case back, forward
}

enum DirectionPresenting {
    case forPresented, forDismissed
    func isPresented() -> Bool {
        self == .forPresented
    }
}

// MARK: Animator

final class Animator: NSObject {

    private var animatorPhotoSlide: (left: UIViewPropertyAnimator?, right: UIViewPropertyAnimator?)
    private var isPresenting: Bool

    override init() {
        isPresenting = true
    }

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }

}

// MARK: Photo slider

extension Animator {

    func began(view: UIView) {
        let width = view.bounds.width
        let duration: TimeInterval = 0.5
        let curve = UIView.AnimationCurve.linear

        animatorPhotoSlide.left = UIViewPropertyAnimator(duration: duration, curve: curve) {
            view.frame = view.frame.offsetBy(dx: -width, dy: 0)
        }
        animatorPhotoSlide.left?.pauseAnimation()

        animatorPhotoSlide.right = UIViewPropertyAnimator(duration: duration, curve: curve) {
            view.frame = view.frame.offsetBy(dx: width, dy: 0)
       }
        animatorPhotoSlide.right?.pauseAnimation()
    }

    func changed(recognizer: UIPanGestureRecognizer, view: UIView) {
        let translation = recognizer.translation(in: view).x
        let fractionComplete = (left: -translation / 100, right: translation / 100)

        animatorPhotoSlide.left?.fractionComplete =  fractionComplete.left
        animatorPhotoSlide.right?.fractionComplete = fractionComplete.right
    }

    func ended(view: UIView, backPhoto: Photo?, forwardPhoto: Photo?) -> Direction? {

        let fractionLeft = animatorPhotoSlide.left?.fractionComplete ?? 0
        let fractionRight = animatorPhotoSlide.right?.fractionComplete ?? 0

        let isMoved = max(fractionLeft, fractionRight) > 0.5
        let isRight = fractionRight > fractionLeft
        let isCanMove = isRight ? backPhoto != nil : forwardPhoto != nil

        let animation = (master: isRight ? animatorPhotoSlide.right : animatorPhotoSlide.left,
                         slave: isRight ? animatorPhotoSlide.left : animatorPhotoSlide.right)

        if isMoved && isCanMove {

            animation.master?.addCompletion {_ in
                animation.slave?.stopAnimation(true)
                self.continueAnimations(view: view, newPhoto: isRight ? backPhoto : forwardPhoto)
            }
            animation.master?.continueAnimation(withTimingParameters: nil, durationFactor: 0)

            return isRight ? .back : .forward
        }

        animation.master?.stopAnimation(true)
        animation.slave?.stopAnimation(true)

        animation.master?.addAnimations {
            view.frame.origin.x = 0
        }
        animation.master?.startAnimation()

        return nil
    }

    func continueAnimations(view: UIView, newPhoto: Photo?) {
        if let view = view as? UIImageView,
           let newPhoto = newPhoto {
            view.image = newPhoto.image.image
        }
        view.frame.origin.x = 0

        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.1
        fadeIn.toValue = 1

        let scaleX = CABasicAnimation(keyPath: "transform.scale.x")
        scaleX.fromValue = 0.7
        scaleX.toValue = 1

        let scaleY = CABasicAnimation(keyPath: "transform.scale.y")
        scaleY.fromValue = 0.7
        scaleY.toValue = 1

        let animationsGroup = CAAnimationGroup()
        animationsGroup.duration = 0.5
        animationsGroup.fillMode = .backwards
        animationsGroup.animations = [fadeIn, scaleX, scaleY]

        view.layer.add(animationsGroup, forKey: nil)

    }

}

// MARK: Transition between view controllers

extension Animator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.75
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to) else { return }

        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.backgroundColor = UIColor(named: "VK_ColorBlue")

        let rotationAngle = (isPresenting ? .pi : -.pi) / CGFloat(2)
        let anchorPoint = (
            source: isPresenting ? CGPoint(x: 0, y: 0) : CGPoint(x: 1, y: 0),
            destination: isPresenting ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0))

        source.view.setAnchorPoint(anchorPoint.source)
        destination.view.setAnchorPoint(anchorPoint.destination)
        destination.view.transform = CGAffineTransform(rotationAngle: -rotationAngle)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            source.view.transform = CGAffineTransform(rotationAngle: rotationAngle)
            destination.view.transform = CGAffineTransform(rotationAngle: 0)
        }, completion: { isComplete in
           transitionContext.completeTransition(isComplete)
        })
    }

}

// MARK: Service

extension Animator {

    static func getViewController(_ withIdentifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
    }

}

extension UIView {

    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }

}
