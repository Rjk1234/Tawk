//
//  VCUserList.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 02/09/22.
//

import UIKit

class VCUserList: UIViewController {
    
    @IBOutlet weak var tblUserList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var viewModel: UserListViewModel!
    var isLoaded:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tblUserList.register(UINib(nibName: "CellUserNormal", bundle: nil), forCellReuseIdentifier: "CellUserNormal")
        tblUserList.register(UINib(nibName: "CellUserInverted", bundle: nil), forCellReuseIdentifier: "CellUserInverted")
        tblUserList.register(UINib(nibName: "CellUserNote", bundle: nil), forCellReuseIdentifier: "CellUserNote")
        tblUserList.delegate = self
        tblUserList.dataSource = self
        viewModel = UserListViewModel(webservice: WebService(), notesRepository: NotesRepository(), userListRepository: UserListRepository())
        viewModel.view = self
        bindViewModel()
        viewModel.getAllUsers(page: viewModel.pageNumber)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveConnection(_:)), name: .didReceiveConnection, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshList()
    }
    
    @objc func onDidReceiveConnection(_ notification:Notification) {
        // Do stuff
        if Utility.isInternetAvailable(){
            if self.isLoaded {return}
            viewModel.getAllUsers(page: viewModel.pageNumber)
         }else{
             print("network is not available")
         }
    }
}

extension VCUserList: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.isSearchActive = true
        viewModel.searchList(searchText: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearchActive = false
        view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearchActive = false
        view.endEditing(true)
    }
    
}

extension VCUserList: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.getItem(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIdentifier) as? TableViewCellProtocol
        cell?.populate(with: cellModel)
        return cell as? UITableViewCell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        if indexPath.row + 3 == viewModel.numberOfItems {
            viewModel.fetchNextPage()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapItem(at: indexPath.row)
    }
}

//Bind ViewController with ViewModel
extension VCUserList {
    func bindViewModel() {
        viewModel.output = { output in
            switch output {
            case .reloadData:
                DispatchQueue.main.async {
                    self.tblUserList.reloadData()
                }
            case .reloadRowAt(let index):
                DispatchQueue.main.async {
                    self.tblUserList.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
    }
}

