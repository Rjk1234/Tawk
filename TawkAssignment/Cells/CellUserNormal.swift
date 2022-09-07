//
//  CellUserNormal.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 02/09/22.
//

import UIKit

class CellUserNormal: UITableViewCell {
    
    @IBOutlet weak var viewCardBG: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var imgProfileIcon: UIImageView!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        configUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configUI(){
        imgProfileIcon.layer.cornerRadius = imgProfileIcon.frame.size.height/2
        imgProfileIcon.layer.borderWidth = 2
        imgProfileIcon.layer.borderColor = UIColor(named: "TawkColorShadow")?.cgColor
        viewCardBG.layer.cornerRadius = 5
        viewCardBG.MakeShadow()
    }
}

extension CellUserNormal: TableViewCellProtocol {
    func populate(with data: TableViewCellModelProtocol) {
        if let data = data as? CellUserNormalModel {
            lblName.text = data.object.login
            lblBlog.text = data.object.gistsURL
            if let url = data.object.avatarURL {
                self.imgProfileIcon.loadcacheImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
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



