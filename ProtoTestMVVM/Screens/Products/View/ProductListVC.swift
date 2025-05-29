//
//  ProductListVC.swift
//  MVVM-withClosure
//
//  Created by Jaimini Shah on 19/05/25.
//

import UIKit

class ProductListVC: UIViewController {

    @IBOutlet weak var tblProduct: UITableView!
    
    private var productViewModel : ProductViewModel
    weak var coordinator: ProductCoordinator?

    required init?(coder: NSCoder) {
        self.productViewModel = ProductViewModel()
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productViewModel.delegate = self
        initUI()
        bindData()
    }
    func initUI(){
        tblProduct.register(UINib(nibName: "ProductTVC", bundle: nil), forCellReuseIdentifier: "ProductTVC")
        tblProduct.delegate = self
        tblProduct.dataSource = self
    }
    func bindData(){
        productViewModel.fetchProducts()
    }

}
extension ProductListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTVC") as? ProductTVC else {
            return UITableViewCell()
        }
        cell.product = productViewModel.products[indexPath.row]
        cell.layoutIfNeeded()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
extension ProductListVC: ProductViewModelDelegate {
    func didStartLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.showLoading(message: "Loading products...")
        }
    }
    
    func didStopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoading()
        }
    }
    
    func didLoadProducts() {
        DispatchQueue.main.async { [weak self] in
            self?.tblProduct.reloadData()
        }
    }
    
    func didFailWithError(_ error: NetworkServiceError) {
        DispatchQueue.main.async { [weak self] in
            self?.showError(.custom(error.localizedDescription))
        }
    }
}
