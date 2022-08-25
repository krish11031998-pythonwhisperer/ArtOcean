//
//  PresentationViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 14/08/2022.
//

import Foundation
import UIKit


extension UIBarButtonItem {
	
	static func leftTitle(title: RenderableText) -> UIBarButtonItem {
		let label = UILabel()
		title.renderInto(target: label)
		return .init(customView: label)
	}
	
}

//MARK: - Type

class PresentationViewController: UIPresentationController {
	
	private lazy var dimmingView: UIView = {
		let view = UIView()
		view.backgroundColor = .black.withAlphaComponent(0.5)
		return view
	}()
	
	private var clickOnDismiss: Bool
	
	
	init(
		target presentedViewController: UIViewController,
		from presentingViewController: UIViewController?,
		clickOnDismiss: Bool
	) {
		self.clickOnDismiss = clickOnDismiss
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		setupDimmingView()
	}

	private func setupDimmingView() {
		if clickOnDismiss {
			dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture)))
		}
	}
	
	@objc private func tapGesture() {
		presentingViewController.dismiss(animated: true)
	}
	
	override var frameOfPresentedViewInContainerView: CGRect{
		let pSize = presentedViewController.preferredContentSize
		let origin: CGPoint = .init(x: .zero, y: .totalHeight - pSize.height)
		let size: CGSize = preferredContentSize
		return .init(origin: origin, size: size)
	}
	
	override func presentationTransitionWillBegin() {
		containerView?.insertSubview(dimmingView, at: 0)
		containerView?.setConstraintsToChild(dimmingView, edgeInsets: .zero)
		
		guard let coordinator = presentedViewController.transitionCoordinator else {
			dimmingView.alpha = 1.0
			return
		}
		
		coordinator.animate { [weak self] _ in
			self?.dimmingView.alpha = 1
		}
	}
	
	override func dismissalTransitionWillBegin() {
		guard let coordinator = presentedViewController.transitionCoordinator else {
			dimmingView.alpha = 0
			return
		}
		
		coordinator.animate { [weak self] _ in
			self?.dimmingView.alpha = 0
		} completion: { [weak self] _ in
			self?.dimmingView.removeFromSuperview()
		}
	}
	
	
	override func containerViewWillLayoutSubviews() {
		presentedView?.frame = frameOfPresentedViewInContainerView
	}
	
	override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
		super.preferredContentSizeDidChange(forChildContentContainer: container)
		print("(DEBUG) called the preferredContentSizeDidChange")
		guard let containerView = containerView else { return }
//		UIView.animate(withDuration: .defaultAnimationDuration, delay: 0, options: .curveEaseInOut) {
		containerView.setNeedsLayout()
		containerView.layoutIfNeeded()
//		}
	}
}

//MARK: - PresentationViewController

extension PresentationViewController: UIViewControllerTransitioningDelegate {
	
	func presentationController(
		forPresented presented: UIViewController,
		presenting: UIViewController?,
		source: UIViewController) -> UIPresentationController? {
		self
	}
	
	func animationController(
		forPresented presented: UIViewController,
		presenting: UIViewController,
		source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		self
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		self
	}
	
}

//MARK: - PresentationViewController UIViewAnimatorTransitioningDelegate

extension PresentationViewController: UIViewControllerAnimatedTransitioning {
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let isPresented = presentedViewController.isBeingPresented
		let key: UITransitionContextViewControllerKey = isPresented ? .to : .from
		
		guard let controller = transitionContext.viewController(forKey: key) else { return }
		
		if isPresented {
			transitionContext.containerView.addSubview(controller.view)
		}
		
		let presented = transitionContext.finalFrame(for: controller)
		var dismissed = presented
		dismissed.origin.y = transitionContext.containerView.frame.height
		
		controller.view.frame = isPresented ? dismissed : presented
		UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut) {
			controller.view.frame = isPresented ? presented : dismissed
		} completion: { status in
			if !isPresented {
				controller.view.removeFromSuperview()
			}
			transitionContext.completeTransition(status)
		}
	}
	
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.35 }
}
