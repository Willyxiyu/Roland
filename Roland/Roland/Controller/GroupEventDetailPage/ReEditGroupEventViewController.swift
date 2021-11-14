//
//  ReeditGroupEventViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/11/12.
//

import UIKit
import Kingfisher
import FirebaseStorage
import FirebaseFirestore

class ReEditGroupEventViewController: UIViewController {
    
    let storage = Storage.storage().reference()
    let tableView = UITableView()
    var selectedGroupEvent: GroupEvent?
    var eventPhotoString: String?
    var eventTitle: String?
    var eventMOP: Int?
    var eventStartTime: String?
    var eventEndTime: String?
    var eventlocation: String?
    var eventIntro: String?
    var photoChange = false
    var eventPhoto = UIImage() {
        
        didSet {
            photoChange = true
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "編輯活動"
        tableView.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        tableView.allowsSelection = false
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(closeReEditPage))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(sendTheUpdate))
        
        setupTableView()
        tableView.register(ReEditGEPhotoCell.self, forCellReuseIdentifier: String(describing: ReEditGEPhotoCell.self))
        
        tableView.register(ReEditGECell.self, forCellReuseIdentifier: String(describing: ReEditGECell.self))
        
        tableView.register(ReEditGETimeCell.self, forCellReuseIdentifier: String(describing: ReEditGETimeCell.self))
        
        tableView.register(ReEditGEIntroCell.self, forCellReuseIdentifier: String(describing: ReEditGEIntroCell.self))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func closeReEditPage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendTheUpdate() {
        
        guard let docId = selectedGroupEvent?.eventId else { fatalError("Error") }
        
        guard let eventPhoto = selectedGroupEvent?.eventPhoto else { fatalError("Error") }
        
        guard let title = selectedGroupEvent?.title else { fatalError("Error") }
        
        guard let maximumOfPeople = selectedGroupEvent?.maximumOfPeople else { fatalError("Error") }
        
        guard let location = selectedGroupEvent?.location else { fatalError("Error") }
        
        guard let info = selectedGroupEvent?.info else { fatalError("Error") }
        
        guard let startTime = selectedGroupEvent?.startTime else { fatalError("Error") }
        
        guard let endTime = selectedGroupEvent?.endTime else { fatalError("Error") }
        
        FirebaseManger.shared.updateGroupEventInfo(
            docId: docId,
            eventPhoto: eventPhotoString ?? eventPhoto,
            title: eventTitle ?? title,
            maximumOfPeople: eventMOP ?? maximumOfPeople,
            startTime: eventStartTime ?? startTime,
            endTime: eventEndTime ?? endTime,
            location: eventlocation ?? location,
            info: eventIntro ?? info
        )
        self.navigationController?.popViewController(animated: true)
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

extension ReEditGroupEventViewController: UITableViewDataSource, UITableViewDelegate, DetailPageCellDelegate, DetailPageDatePickerCellDelegate {
    func stimeUpdate(startTime: String) {
        eventStartTime = startTime
    }
    
    func etimeUpdate(endTime: String) {
        eventEndTime = endTime
    }
    
    func titleUpdate(title: String) {
        eventTitle = title
    }
    
    func locationUpdate(location: String) {
        eventlocation = location
    }
    
    func MOPeopleUpdate(MOP: String) {
        
        if let MOP = Int(MOP) {
            eventMOP = MOP
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let infoCell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(ReEditGECell.self)"), for: indexPath) as? ReEditGECell else { fatalError("Error") }
        
        switch indexPath.row {
        case 0: // photo
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(ReEditGEPhotoCell.self)"), for: indexPath) as? ReEditGEPhotoCell else { fatalError("Error") }
            
            guard let photo = selectedGroupEvent?.eventPhoto else {
                fatalError("error")
            }
            
            if photoChange == true {
                
                cell.photoImageView.image = eventPhoto
                
            } else {
                
                cell.photoImageView.kf.setImage(with: URL(string: photo))
                
                }
            
            cell.addNewPhoto = { [weak self] in
                guard let self = self else { return }
                self.showImagePickerControllerActionSheet()
            }
            
            return cell
            
        case 1: // event title
            
            guard let title = selectedGroupEvent?.title else {
                fatalError("error")
            }
            
            infoCell.titleLabel.text = "活動名稱"
            infoCell.textField.text = title
            infoCell.updateInfo = .titleUpdateCell
            infoCell.delegate = self
            
            return infoCell
            
        case 2: // people number
            
            guard let MOP = selectedGroupEvent?.maximumOfPeople else {
                fatalError("error")
            }
            
            infoCell.titleLabel.text = "活動人數"
            infoCell.textField.text = String(MOP)
            infoCell.updateInfo = .MOPeopleUpdateCell
            infoCell.delegate = self
            
            return infoCell
            
        case 3: // eventTime
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(ReEditGETimeCell.self)"), for: indexPath) as? ReEditGETimeCell else { fatalError("Error") }
            
            cell.delegate = self
            
            return cell
            
        case 4: // eventlocation
            guard let location = selectedGroupEvent?.location else {
                fatalError("error")
            }
            
            infoCell.titleLabel.text = "活動地點"
            infoCell.textField.text = location
            infoCell.updateInfo = .locationUpdateCell
            infoCell.delegate = self
            
            return infoCell
            
        case 5: // Event Info
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "\(ReEditGEIntroCell.self)"), for: indexPath) as? ReEditGEIntroCell else { fatalError("Error") }
            
            guard let info = selectedGroupEvent?.info else {
                fatalError("error")
            }
            
            cell.titleLabel.text = "活動簡介"
            cell.textView.text = info
            
            return cell
            
        default:
            break
        }
        
        return UITableViewCell()
    }
}

extension ReEditGroupEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        eventPhoto = editedImage
        
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        eventPhoto = originalImage
        
        guard let imageData = editedImage.jpegData(compressionQuality: 0.25) else {
            return
        }
        
        let uniqueString = NSUUID().uuidString
        storage.child("imgae/\(uniqueString)").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            self.storage.child("imgae/\(uniqueString)").downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                self.eventPhotoString = urlString
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        }
    }
}
