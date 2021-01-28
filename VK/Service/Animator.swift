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
        1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to) else { return }

        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)

//        let containerFrame = transitionContext.containerView.frame

//        let startY = isPresenting ? containerFrame.height : -containerFrame.height
        let rotationAngle: CGFloat = (isPresenting ? .pi : -.pi) / 2
//        let anchorPoint = CGPoint(x: <#T##Int#>, y: <#T##Int#>)
        
        source.view.setAnchorPoint(CGPoint(x: 0, y: 0))
        destination.view.setAnchorPoint(CGPoint(x: 1, y: 0))

//        let frames = (
//            sourceEnd: CGRect(
//                x: 0,
//                y: startY,
//                width: containerFrame.width,
//                height: containerFrame.height),
//            destinationStart: CGRect(
//                x: 0,
//                y: -startY,
//                width: containerFrame.width,
//                height: containerFrame.height),
//            destinationEnd:
//                source.view.frame)

//        let transformes = (
//            sourceStart:
//                CGAffineTransform(rotationAngle: 0),
//            sourceEnd:
//                CGAffineTransform(rotationAngle: rotationAngle),
//            destinationStart:
//                CGAffineTransform(rotationAngle: -rotationAngle),
//            destinationEnd:
//                CGAffineTransform(rotationAngle: 0))

//        let rotateTransform =

//        let sourceFrame = CGRect(
//            x: 0,
//            y: startY,
//            width: containerFrame.width,
//            height: containerFrame.height)

//        let destinationFrame =
//            source.view.frame

//        destination.view.frame = frames.destinationStart
//        let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
//        let translate = CGAffineTransform(translationX: -400, y: 0)
//        translate.concatenating(transformes.destinationStart)
        
//        source.view.transform.translatedBy(x: 0, y: 0)
        destination.view.transform = CGAffineTransform(rotationAngle: -rotationAngle)
//        destination.view.transform
//            .translatedBy(x: containerFrame.width, y: 0)
//            .rotated(by: -rotationAngle)
//
//        destination.view.setAnchorPoint(CGPoint(x: 200, y: 0))
//        destination.view.transform  = transformes.destinationStart
//        destination.view.bounds.origin.x = 0
//        destination.view.bounds.origin.y = containerFrame.width
        print("destination: \(destination.view.frame)")
//        destination.view.transform = transformes.destinationStart
//        destination.view.frame = CGRect(
//                        x: containerFrame.width,
//                        y: 0,
//                        width: containerFrame.height,
//                        height: containerFrame.width)
//        destination.view.transform = CGAffineTransform
//            CGRect(
//            x: 0,
//            y: -startY,
//            width: containerFrame.width,
//            height: containerFrame.height)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            source.view.transform = CGAffineTransform(rotationAngle: rotationAngle)
            destination.view.transform = CGAffineTransform(rotationAngle: 0)
//           source.view.transform = transformes.sourceEnd
//            destination.view.transform = transformes.destinationEnd

//            source.view.frame = frames.sourceEnd
//            destination.view.frame = frames.destinationEnd
        }, completion: { isComplete in
            print("transitionContext: \(transitionContext.containerView.frame)")
            print("source: \(source.view.frame)")
            print("destination: \(destination.view.frame)")
//            source.view.transform = transformes.sourceStart
//            transitionContext.containerView.transform = .identity
//            destination.view.transform = .identity
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
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

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
