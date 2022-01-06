//
//  CommentInputAccessoryView.swift
//  InstagramClone
//
//  Created by Mitko on 28.04.21.
//

import UIKit

class CommentInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    private let commentTextView: InputTextView = {

        let tv = InputTextView()
        tv.placeholderText = "Enter comment"
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {

        super.init(frame: frame)
        configureViews()
    }
    
    private func configureViews() {

        // for when the keyboard pops up and the input view gets smaller
        
        autoresizingMask = .flexibleHeight

        backgroundColor = .white
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)

        addSubview(commentTextView)
        commentTextView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: safeAreaLayoutGuide.bottomAnchor,
            right: postButton.leftAnchor,
            paddingTop: 8,
            paddingLeft: 8,
            paddingBottom: 8,
            paddingRight: 8
        )
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // figures the size according to the components inside the view

    override var intrinsicContentSize: CGSize {
        return .zero
    }

    // MARK: - Actions
        
    @objc private func handlePostTapped() {}
}

