//
//  GroupEventCEPFEPVC.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import Foundation
import UIKit

class GroupEventCEPFEPVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let tableView = UITableView()
    
    var eventPhoto = UIImage() {
        didSet {
            tableView.reloadData()
        }
    }
    
//    let groupEventCEPEIntroVC = GroupEventCEPEIntroVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.register(GEPhotoCell.self, forCellReuseIdentifier: String(describing: GEPhotoCell.self))
        tableView.register(GETitleCell.self, forCellReuseIdentifier: String(describing: GETitleCell.self))
        tableView.register(GEDetailCell.self, forCellReuseIdentifier: String(describing: GEDetailCell.self))
        tableView.register(GEIntroCell.self, forCellReuseIdentifier: String(describing: GEIntroCell.self))
        tableView.register(GEMessageCell.self, forCellReuseIdentifier: String(describing: GEMessageCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension GroupEventCEPFEPVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let gEDetailCell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEDetailCell.self)"), for: indexPath) as? GEDetailCell else { fatalError("Error") }
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEPhotoCell.self)"), for: indexPath) as? GEPhotoCell else { fatalError("Error") }
            cell.photoImageView.image = eventPhoto
            cell.addNewPhoto = { [weak self] in
                guard let self = self else { return }
                self.showImagePickerControllerActionSheet()
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GETitleCell.self)"), for: indexPath) as? GETitleCell else { fatalError("Error") }
            cell.titleLabel.text = "活動主題"
            
            return cell
        case 2:
            gEDetailCell.eventDetailTitleLabel.text = "活動開始時間"
            gEDetailCell.eventDetailLabel.text = "2021.10.28"
            
            return gEDetailCell
            
        case 3:
            gEDetailCell.eventDetailTitleLabel.text = "活動結束時間"
            gEDetailCell.eventDetailLabel.text = "2022.01.05"
            
            return gEDetailCell
            
        case 4:
            gEDetailCell.eventDetailTitleLabel.text = "活動地點"
            gEDetailCell.eventDetailLabel.text = "雪梨瓦樂比路42號"
            
            return gEDetailCell
           
        case 5:
            gEDetailCell.eventDetailTitleLabel.text = "活動人數"
            gEDetailCell.eventDetailLabel.text = "13"
            
            return gEDetailCell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEIntroCell.self)"), for: indexPath) as? GEIntroCell else { fatalError("Error") }
            cell.eventIntroTitleLabel.text = "活動說明"
            cell.eventIntroLabel.text = "ew;uhfweinudi37fhwkejdhuweygdfehfeuif6734y4unfjk4n4jcni4unck4u"
            
            return cell
            
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEMessageCell.self)"), for: indexPath) as? GEMessageCell else { fatalError("Error") }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
}

extension GroupEventCEPFEPVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Photo", message: "where would you like to attach a photo from", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            eventPhoto = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            eventPhoto = originalImage

        }
        
        dismiss(animated: true, completion: nil)
    }
}
