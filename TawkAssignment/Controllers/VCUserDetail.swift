//
//  VCUserDetail.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 02/09/22.
//

import UIKit


class VCUserDetail: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFollower: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var tvNote: UITextView!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblTwittername: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblHirable: UILabel!
    @IBOutlet weak var headerView: UIView!
    var userObject: UserModel! {
        didSet {
            self.configDetail(Object: userObject)
        }
    }
    var userName: String!
    var userId: Int!
    var viewModel : UserDetailViewModel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel = UserDetailViewModel(
            webservice: WebService(),
            notesRepository: NotesRepository(),
            userListRepository: UserListRepository(),
            userProfileRepository: UserProfileRepository())
        
        viewModel.view = self
        guard let userName = userName, let userId = userId else {return}
        viewModel.getDetailBy(id: userId, name: userName)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    func configDetail(Object: UserModel){
        self.lblBlog.text = Object.blog
        self.lblName.text = Object.name
        self.lblTwittername.text = Object.twitterUsername ?? Object.name
        self.lblFollower.text = "Followers: \(Object.followers ?? 0)"
        self.lblFollowing.text = "Following: \(Object.following ?? 0)"
        self.lblHirable.text = Object.hireable ?? "Not hirable"
        self.lblCompany.text = "Company: \(Object.company ?? "Not Available")"
        self.lblEmail.text = "Contact: \(Object.email ?? "Not Available")"
        
        if let url = Object.avatarURL {
            self.imgProfile.loadcacheImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
        }
    }
    
    func setupUI(){
        tvNote.delegate = self
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = UIColor(named: "TawkColorShadow")?.cgColor
        noteView.layer.cornerRadius = 5
        noteView.layer.borderWidth = 0.5
        noteView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func onTapEdit(_ sender: Any) {
        tvNote.becomeFirstResponder()
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapSave(_ sender: Any) {
        view.endEditing(true)
        viewModel.addNotesTo(id: self.userId, text: tvNote.text!)
    }
}

extension VCUserDetail: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            tvNote.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 200
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        tvNote.text = textView.text
        tvNote.resignFirstResponder()
        return true
    }
}

extension VCUserDetail {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
