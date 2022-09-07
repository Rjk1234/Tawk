//
//  CellUserInverted.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 02/09/22.
//

import UIKit

class CellUserInverted: UITableViewCell {
    @IBOutlet weak var viewCardBG: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var imgProfileIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    func configUI(){
        imgProfileIcon.layer.cornerRadius = imgProfileIcon.frame.size.height/2
        imgProfileIcon.layer.borderWidth = 2
        imgProfileIcon.layer.borderColor = UIColor(named: "TawkColorShadow")?.cgColor
        viewCardBG.layer.cornerRadius = 5
        viewCardBG.MakeShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
extension CellUserInverted: TableViewCellProtocol {
    func populate(with data: TableViewCellModelProtocol) {
        if let data = data as? CellUserInvertedModel {
            lblName.text = data.object.login
            lblBlog.text = data.object.gistsURL
            if let url = data.object.avatarURL {
                self.imgProfileIcon.loadcacheImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"), inverse: true)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                    self.imgProfileIcon.inverseImage()
//                })
               
            }
            UserListRepository().isViewed(id: data.object.id!){ success, err in
                if success == true {
                    self.viewCardBG.backgroundColor = UIColor(named: "TawkColorFaded")
                }else{
                    self.viewCardBG.backgroundColor = UIColor(named: "TawkColorCard")
                }
            }
        }
    }
}


