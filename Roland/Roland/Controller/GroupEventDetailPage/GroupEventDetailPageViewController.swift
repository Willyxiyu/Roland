////
////  GroupEventCEPFEPVC.swift
////  Roland
////
////  Created by 林希語 on 2021/10/27.
////
//
import Foundation
import Firebase
import UIKit
import FirebaseStorage
import Kingfisher

class GroupEventDetailPageViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let tableView = UITableView()
    var selectedGroupEvent: GroupEvent? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(shareNewEvent))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.themeColor
        setupTableView()
        tableView.register(GEPhotoCell.self, forCellReuseIdentifier: String(describing: GEPhotoCell.self))
        tableView.register(GEDetailPageTitleCell.self, forCellReuseIdentifier: String(describing: GEDetailPageTitleCell.self))
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
extension GroupEventDetailPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let gEDetailCell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEDetailCell.self)"), for: indexPath) as? GEDetailCell else { fatalError("Error") }
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEPhotoCell.self)"), for: indexPath) as? GEPhotoCell else { fatalError("Error") }
            
            guard let photo = selectedGroupEvent?.eventPhoto else { fatalError("Error") }
            cell.photoImageView.kf.setImage(with: URL(string: photo))
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEDetailPageTitleCell.self)"),
                                                           for: indexPath) as? GEDetailPageTitleCell else { fatalError("Error") }
            cell.titleLabel.text = selectedGroupEvent?.title
            
            cell.cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
            
            return cell
        case 2:
            gEDetailCell.eventDetailTitleLabel.text = "活動開始時間"
            gEDetailCell.eventDetailLabel.text = selectedGroupEvent?.startTime
            
            return gEDetailCell
            
        case 3:
            gEDetailCell.eventDetailTitleLabel.text = "活動結束時間"
            gEDetailCell.eventDetailLabel.text = selectedGroupEvent?.endTime
            
            return gEDetailCell
            
        case 4:
            gEDetailCell.eventDetailTitleLabel.text = "活動地點"
            gEDetailCell.eventDetailLabel.text = selectedGroupEvent?.location
            
            return gEDetailCell
            
        case 5:
            
            guard let people = selectedGroupEvent?.maximumOfPeople else { fatalError("error")  }
            gEDetailCell.eventDetailTitleLabel.text = "活動人數"
            gEDetailCell.eventDetailLabel.text = String("\(people)")
            
            return gEDetailCell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEIntroCell.self)"), for: indexPath) as? GEIntroCell else { fatalError("Error") }
            cell.eventIntroTitleLabel.text = "活動說明"
            cell.eventIntroLabel.text = selectedGroupEvent?.info
            
            return cell
            
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(GEMessageCell.self)"), for: indexPath) as? GEMessageCell else { fatalError("Error") }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    @objc func cancelEvent() {
        
        guard let eventId = selectedGroupEvent?.eventId else {
            
            return
        }
        
        let alert = UIAlertController(title: "刪除活動", message: "刪除後無法回復", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "敵不動我不動", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "確認刪除", style: .default, handler: { [weak self] _ in
            
            guard let self = self else { return }
            FirebaseManger.shared.deleteGroupEventCreatingInfo(docId: eventId)
            self.navigationController?.popViewController(animated: true)
            
        })
        alert.addAction(confirm)
        alert.addAction(cancel)
    
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

// extension GroupEventDetailPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func showImagePickerControllerActionSheet() {
//        let actionSheet = UIAlertController(title: "Attach Photo", message: "where would you like to attach a photo from", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
//
//            let picker = UIImagePickerController()
//            picker.sourceType = .camera
//            picker.delegate = self
//            picker.allowsEditing = true
//            self?.present(picker, animated: true)
//
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
//
//            let picker = UIImagePickerController()
//            picker.sourceType = .photoLibrary
//            picker.delegate = self
//            picker.allowsEditing = true
//            self?.present(picker, animated: true)
//
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        present(actionSheet, animated: true)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
//
//        eventPhoto = editedImage
//
//        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//
//        eventPhoto = originalImage
//
//        guard let imageData = editedImage.pngData() else {
//            return
//        }
//
//        storage.child("imgae/file.png").putData(imageData, metadata: nil) { _, error in
//            guard error == nil else {
//                print("Failed to upload")
//                return
//            }
//            self.storage.child("imgae/file.png").downloadURL(completion: { url, error in
//                guard let url = url, error == nil else {
//                    return
//                }
//                let urlString = url.absoluteString
//                print("Download URL: \(urlString)")
//                self.eventUrlString = urlString
//                UserDefaults.standard.set(urlString, forKey: "url")
//            })
//        }
//    }
// }