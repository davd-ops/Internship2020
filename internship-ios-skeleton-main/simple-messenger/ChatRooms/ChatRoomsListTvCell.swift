//
//  UserListTVCell.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 09.06.2021.
//

import Foundation
import UIKit

public class ChatRoomsListTVCell: UITableViewCell {
    
    
    open class var reuseIdentifier: String {
        return String(describing: Self.self)
    }

    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var imageSource = UIImage(named: "chatroom_icon.png")
    
    var whyme = UIImage(named: "jj.png")
    var fml = UIImageView()
    
    var image = UIImageView()
    
    

    open var data: Any? {
        didSet {
            if data != nil{
                updateView()
            }
        }
    }

    override public init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func prepareView() {
        prepareTitleLabel()
        prepareDescriptionLabel()
        prepareImage()
        //prepareThatImage()
    }

    open func prepareThatImage() {
        fml.image = whyme
        
        contentView.addSubview(fml)
        fml.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.rightMargin.equalTo(15)
            
        }
        
    }
    open func updateView() {
        guard let dataUnwrapped = data as? Chatroom else {
            return
        }
        titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 22.5)
        descriptionLabel.text = " \(dataUnwrapped.description)"
        
        titleLabel.text = "\(dataUnwrapped.title)"
    }

    open func prepareTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(15)
            make.centerX.equalToSuperview()
        }
    }
    
    open func prepareImage() {
        image.image = imageSource
        
        contentView.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leftMargin.equalTo(15)
            
        }
    }
    
    open func prepareDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }


}
