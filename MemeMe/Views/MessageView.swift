// 

import UIKit

struct Messages {
    static let noMemesTitle = "No memes yet"
    static let noMemesMessage = "Click + in the upper right corner\nto make the first meme"
}


class MessageView: UIView {
    
    private struct Const {
        static let fontColor: UIColor = .darkGray
        static let fontSize: CGFloat = 17.0
        
        struct padding {
            static let xsmall: CGFloat = 4.0
            static let small: CGFloat = 8.0
            static let medium: CGFloat = 16.0
            static let large: CGFloat = 32.0
        }
    }
    
    var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }

    var message: String? {
        set {
            messageLabel.text = newValue
        }
        get {
            return messageLabel.text
        }
    }
    
    lazy var titleLabel: UILabel = {
       let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.textAlignment = .center
        labelView.textColor = Const.fontColor
        labelView.font = UIFont.systemFont(ofSize: Const.fontSize, weight: .semibold)
        labelView.numberOfLines = 0
        return labelView
    }()
    
    lazy var messageLabel: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.textAlignment = .center
        labelView.textColor = Const.fontColor
        labelView.font = UIFont.systemFont(ofSize: Const.fontSize)
        labelView.numberOfLines = 0
        return labelView
    }()
    
    convenience init(title: String? = nil, message: String? = nil, frame: CGRect = .zero) {
        self.init(frame: frame)
        self.title = title
        self.message = message
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    private func initUI() {
        addSubview(titleLabel)
        addSubview(messageLabel)
        
        let constraints: [NSLayoutConstraint] = [
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -Const.padding.large),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Const.padding.medium),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Const.padding.medium),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Const.padding.xsmall),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Const.padding.medium),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Const.padding.medium)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
