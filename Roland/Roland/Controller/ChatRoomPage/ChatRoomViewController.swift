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
    
    
    var selectedChatroomId: String?
    
    public var isNewConversation = false
    
    public let accepterId: String = ""
    
    private var messages = [Message]() {
        
        didSet {
            
            self.messagesCollectionView.reloadData()
        }
    }
    
    let storage = Storage.storage().reference()
    
    var profilePhoto = UIImage() {
        
        didSet {
            
            messagesCollectionView.reloadData()
        }
    }
    
    var eventUrlString = String() {
        
        didSet {
            
            guard let selfSender = self.selfSender  else {
                return
            }
            
            guard let url = URL(string: self.eventUrlString),
                  
                    let placeholder = UIImage(systemName: "plus")
                    
            else {
                
                return
            }
            
            guard let selectedChatroomId = selectedChatroomId  else {
                fatalError("error")
            }
            
            let media = Media(url: url, image: nil, placeholderImage: placeholder, size: .zero)
            
            let photoMessage = Message(sender: selfSender, messageId: "", sentDate: Date(), kind: .photo(media))
            
            FirebaseManger.shared.sendMessage(chatRoomId: selectedChatroomId, newMessage: photoMessage)
            
            self.messagesCollectionView.reloadData()
            
        }
    }
    
    var selfSender: Sender? {
        return Sender(photoURL: "",
                      senderId: "DoIscQXJzIbQfJDTnBVm",
                      displayName: "Willy Boy")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //        messagesCollectionView.delegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
        self.hideKeyboardWhenTappedAround()
        
        guard let selectedChatroomId = selectedChatroomId  else {
            fatalError("error")
        }
        
        FirebaseManger.shared.messageListener(chatRoomId: selectedChatroomId) { results in
            
            self.messages.removeAll()
            
            results.forEach { result in
                
                print(result)
                
                guard let sentDate = result.createTime?.dateValue() else {
                    return
                }
                var kind: MessageKind?
                
                if result.photoMessage != "" {
                    
                    guard let imageUrl = URL(string: result.photoMessage ?? ""),
                          let placeHolder = UIImage(systemName: "plus") else {
                              return
                          }
                    
                    let media = Media(url: imageUrl, image: nil, placeholderImage: placeHolder, size: CGSize(width: 300, height: 300))
                    kind = .photo(media)
                    
                } else if result.text != "" {
                    kind = .text(result.text ?? "")
                }
                
                guard let finalKind = kind else {
                    return
                }
                
                if let selfSender = self.selfSender {
                    
                    let message = Message(sender: selfSender, messageId: "", sentDate: sentDate, kind: finalKind)
                    
                    self.messages.append(message)
                    
                }
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
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
        let actionSheet = UIAlertController(title: "Attach Media", message: "What would you like to attach", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoInputActionSheet()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self] _ in
            self?.presentVideoInputActionSheet()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: { _ in
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func presentPhotoInputActionSheet() {
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
    
    private func presentVideoInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Video", message: "where would you like to attach a Video from?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
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
}
extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let message = Message(sender: Sender(photoURL: "", senderId: "", displayName: ""), messageId: "", sentDate: Date(), kind: .text(text))
        
        guard let selectedChatroomId = selectedChatroomId  else {
            fatalError("error")
        }
        
        FirebaseManger.shared.sendMessage(chatRoomId: selectedChatroomId, newMessage: message)
        
        self.messagesCollectionView.reloadData()
        
        self.messageInputBar.inputTextView.text.removeAll()
        
    }
    
    func createMessageId() -> String? {
        // date, otherUserEmail, senderEmail, randomInt
        
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") else {
            return nil
        }
        
        let dateString = Self.dateFormatter.string(from: Date())
        
        let newIdentifier = "\(accepterId)_\(currentUserEmail)_\(dateString)"
        
        print("create message id: \(newIdentifier)")
        
        return newIdentifier
        
    }
}
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
