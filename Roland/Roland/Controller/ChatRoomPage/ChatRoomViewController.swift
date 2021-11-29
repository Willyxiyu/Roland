//
//  ChatRoomViewController.swift
//  Roland
//
//  Created by 林希語 on 2021/10/23.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import FirebaseStorage
import SDWebImage

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text:
            return "text"
        case .attributedText:
            return "attributed_text"
        case .photo:
            return "photo"
        case .video:
            return "video"
        case .location:
            return "location"
        case .emoji:
            return "emoji"
        case .audio:
            return "emoji"
        case .contact:
            return "contact"
        case .custom:
            return "custom"
        case .linkPreview:
            return "linkPreview"
        }
    }
}

class ChatRoomViewController: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        dateFormatter.locale = .current
        return dateFormatter
    }()
    
    var currentUserInfo: UserInfo?
    
    var otherUserInfo: UserInfo?
    
    var selectedChatroomId: String?
    
    var userInChatRoom: [String]?
    
    var otherUserId: String?
    
    var isNewConversation = false
    
    var accepterId: String?
    
    var messages = [Message]()

    let storage = Storage.storage().reference()
    
    var profilePhoto = UIImage()
    
    var selfSender: Sender?
    
    var otherSender: Sender?
    
    var eventUrlString = String() {
        
        didSet {
            
            guard let selfSender = self.selfSender,
                  let url = URL(string: self.eventUrlString),
                  let placeholder = UIImage(systemName: "plus"),
                  let selectedChatroomId = selectedChatroomId,
                  let accepterId = accepterId else { return }
            
            let media = Media(url: url, image: nil, placeholderImage: placeholder, size: .zero)
            
            let photoMessage = Message(sender: selfSender, messageId: "", sentDate: Date(), kind: .photo(media))
            
            FirebaseManger.shared.sendMessage(chatRoomId: selectedChatroomId, accepterId: accepterId, newMessage: photoMessage)
            
            self.messagesCollectionView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        getCurrentUserInfo {
                        
            self.getOtherUserId()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    private func getCurrentUserInfo(completion: @escaping () -> Void) {
        
        FirebaseManger.shared.fetchUserInfobyUserId { result in
            
            guard let photoURL = result?.photo,
                  let senderId = result?.userId,
                  let displayName = result?.name else { return }
            
            self.selfSender = Sender(photoURL: photoURL, senderId: senderId, displayName: displayName)
            
            self.currentUserInfo = result
            completion()
        }
    }
    
    private func getOtherUserInfo(completion: @escaping () -> Void) {
        
        if let otherUserId = self.accepterId {
            
            FirebaseManger.shared.fetchOtherUserInfo(otherUserId: otherUserId) { result in
                
                guard let photoURL = result?.photo,
                      let senderId = result?.userId,
                      let displayName = result?.name else { return }
                
                self.otherUserInfo = result
                
                self.otherSender = Sender(photoURL: photoURL, senderId: senderId, displayName: displayName)
                completion()
            }
        }
    }
// 直接拿前一頁的使用者資料
    private func getOtherUser() {
        
        if let otherUserInfo = self.otherUserInfo {
            
            guard let photoURL = otherUserInfo.photo,
                  let senderId = otherUserInfo.userId else { return }
      
            self.otherSender = Sender(photoURL: photoURL, senderId: senderId, displayName: otherUserInfo.name)
        }
        
    }
    
    private func getOtherUserId() {
        
        if let userInChatRoom = self.userInChatRoom {
            
            for user in userInChatRoom where user != self.currentUserInfo?.userId {
            
                    self.accepterId = user
            }
            getOtherUserInfo {
                
                self.messageListener()
            }
        }
    }
    
    private func messageListener() {
        
        guard let selectedChatroomId = self.selectedChatroomId else {
            fatalError("error")
        }
        
        FirebaseManger.shared.messageListener(chatRoomId: selectedChatroomId) { messages in
            
            self.messages.removeAll()
            
            messages.forEach { message in
                
                guard let sentDate = message.createTime?.dateValue() else {
                    return
                }
                var kind: MessageKind?
                
                if message.photoMessage != "" {
                    
                    guard let imageUrl = URL(string: message.photoMessage ?? ""),
                          let placeHolder = UIImage(systemName: "plus") else {
                              return
                          }
                    
                    let media = Media(url: imageUrl, image: nil, placeholderImage: placeHolder, size: CGSize(width: 300, height: 300))
                    kind = .photo(media)
                    
                } else if message.text != "" {
                    
                    kind = .text(message.text ?? "")
                }
                
                guard let finalKind = kind else {
                    return
                }
                
                if self.selfSender?.senderId == message.senderId {
                    
                    let message = Message(sender: self.selfSender!, messageId: "", sentDate: sentDate, kind: finalKind)
                    
                    self.messages.append(message)
                    
                } else {
                    
                    let message = Message(sender: self.otherSender!, messageId: "", sentDate: sentDate, kind: finalKind)
                    
                    self.messages.append(message)
                }
                
            }
            
            self.messagesCollectionView.reloadData()
            //            self.messagesCollectionView.reloadDataAndKeepOffset()
        }
    }
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "取用多媒體", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "照片", style: .default, handler: { [weak self] _ in
            self?.presentPhotoInputActionSheet()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "影片", style: .default, handler: { [weak self] _ in
            self?.presentVideoInputActionSheet()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func presentPhotoInputActionSheet() {
        let actionSheet = UIAlertController(title: "取用照片", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "相機", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "相簿", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func presentVideoInputActionSheet() {
        let actionSheet = UIAlertController(title: "取用影片", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "相機", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "相簿", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
}
extension ChatRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        profilePhoto = editedImage
        
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        profilePhoto = originalImage
        
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
                self.eventUrlString = urlString
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        }
    }
}
// 決定是從左還是右
extension ChatRoomViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        
        if let sender = selfSender {
            
            return sender
        }
        
        fatalError("Self Sender is nil, email should be catched ")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }
    
    // color of the text label
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        
        if sender.senderId == selfSender?.senderId {
            return .link
        }
        
        return .secondarySystemBackground
    }
    
    // get both user's profile photo
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let sender = message.sender
        
        guard let currentUserPhotoString = currentUserInfo?.photo,
                  let otherUserPhotoString = otherUserInfo?.photo else { return }
        
        if sender.senderId == currentUserInfo?.userId {
            
            if let currentUserImageURL = URL(string: currentUserPhotoString) {
                
                avatarView.sd_setImage(with: currentUserImageURL, completed: nil)
            }
            
        } else {
            
            if let otherUserImageURL = URL(string: otherUserPhotoString) {
                
                avatarView.sd_setImage(with: otherUserImageURL, completed: nil)
            }
        }
    }
}

// send and update message
extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let message = Message(sender: currentSender(), messageId: "", sentDate: Date(), kind: .text(text))
        
        guard let selectedChatroomId = selectedChatroomId  else {
            fatalError("error")
        }
        
        guard let accepterId = self.accepterId else { fatalError("error") }
        
        FirebaseManger.shared.sendMessage(chatRoomId: selectedChatroomId, accepterId: accepterId, newMessage: message)
        
        FirebaseManger.shared.updateLastestMessage(docId: selectedChatroomId, message: text, accepterId: accepterId)
        
        self.messagesCollectionView.reloadData()
        
        self.messageInputBar.inputTextView.text.removeAll()
        
    }
}

// go to photo detail page
extension ChatRoomViewController: MessageCellDelegate {
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            
            return
        }
        
        let message = messages[indexPath.section]
        
        switch message.kind {
            
        case .photo(let media):
            
            guard let imageUrl = media.url else {
                
                return
            }
            
            let viewController = PhotoViewerViewController(with: imageUrl)
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}
