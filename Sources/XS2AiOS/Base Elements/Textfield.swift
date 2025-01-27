import UIKit

enum TextFieldStyles {
	case error
	case normal
}

class Textfield: UITextField, UITextFieldDelegate {
	let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15)
	var parentDelegate: TextfieldParentDelegate?

	func setupStyling() {
		self.clipsToBounds = true
		self.tintColor = XS2AiOS.shared.styleProvider.tintColor
		self.backgroundColor = XS2AiOS.shared.styleProvider.inputBackgroundColor
		self.layer.cornerRadius = XS2AiOS.shared.styleProvider.inputBorderRadius
		self.font = XS2AiOS.shared.styleProvider.font.getFont(ofSize: 20, ofWeight: nil)
		self.textColor = XS2AiOS.shared.styleProvider.inputTextColor
		self.heightAnchor.constraint(equalToConstant: 50).isActive = true
	}
	
	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: insets)
	}

	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: insets)
	}

	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: insets)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let shouldReturn = parentDelegate?.textFieldShouldReturn(textField)
		
		return shouldReturn ?? false
	}

	
	override init(frame: CGRect) {
		super.init(frame: frame)
		delegate = self
		setupStyling()
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		delegate = self
		setupStyling()
	}
	
	func styleTextfield(style: TextFieldStyles) {
		switch style {
		case .error:
			self.layer.borderWidth = 2
			self.layer.borderColor = XS2AiOS.shared.styleProvider.errorStyle.backgroundColor.cgColor
			self.layer.add(getBorderWidthAnimation(type: .didStart), forKey: "Width")
		case .normal:
			if self.layer.borderWidth != 0 {
				self.layer.borderWidth = 0
				self.layer.add(getBorderWidthAnimation(type: .didEnd), forKey: "Width")
			}
		}
	}
	
	func styleDisabledState() {
		UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut) {
			self.backgroundColor = self.backgroundColor?.darker()
		}
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if self.layer.borderWidth != 2 {
			self.layer.borderWidth = 2
			self.layer.add(getBorderWidthAnimation(type: .didStart), forKey: "Width")
		}

		self.layer.borderColor = XS2AiOS.shared.styleProvider.tintColor.cgColor
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		self.layer.borderWidth = 0
		self.layer.add(getBorderWidthAnimation(type: .didEnd), forKey: "Width")
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return parentDelegate?.shouldBeginEditing() ?? true
	}
}
