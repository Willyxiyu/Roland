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

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "emoji"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "custom"
        case .linkPreview(_):
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
    
    public var isNewConversation = false
    
    public let accepterId: String = ""
    
    private var messages = [Message]() {
        didSet {
            self.messagesCollectionView.reloadData()
        }
    }
    
    private var selfSender: Sender? {
      
//        guard let currentUserId = UserDefaults.standard.value(forKey: "userId") as? String else {
//            return nil
//        }
        return Sender(photoURL: "",
                      senderId: "DoIscQXJzIbQfJDTnBVm",
                      displayName: "Willy Boy")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
        
        FirebaseManger.shared.messageListener(chatRoomId: "TMTKJhNE2z0u4FyLoDsu") { results in
            
            self.messages.removeAll()
            
            results.forEach { result in
                
                print(result)
                
                guard let sentDate = result.createTime?.dateValue() else {
                    return
                }
                
                guard let senderId = result.senderId else {
                    return
                }
                
                guard let displayName = result.senderId else {
                    return
                }
                guard let resultText = result.text  else {
                    return
                }
                let kind = MessageKind.text(resultText)
                
                let message = Message(sender: Sender(photoURL: "", senderId: senderId, displayName: displayName), messageId: "", sentDate: sentDate, kind: kind)
                
                self.messages.append(message)
                
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
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        guard let messageId = createMessageId(),
//              let image =  info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
//              let imageData = image.pngData() else {
//                  return
//              }
        // upload image
        
        // send Message
        
    }
}

extension ChatRoomViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        
        if let sender = selfSender {
            
            return sender
        }
        fatalError("Self Sender is nil, email should be catched ")
        return Sender(photoURL: "", senderId: "DoIscQXJzIbQfJDTnBVm", displayName: "Willy Boy")
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}
extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    
     func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let message = Message(sender: Sender(photoURL: "", senderId: "", displayName: ""), messageId: "", sentDate: Date(), kind: .text("YEEE"))
        
        FirebaseManger.shared.sendMessage(chatRoomId: "TMTKJhNE2z0u4FyLoDsu", newMessage: message)
        
        self.messagesCollectionView.reloadData()
        
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
// extension ChatRoomViewController: MessageCellDelegate {
//
//    func didTapImage(in cell: MessageCollectionViewCell) {
//
//        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
//
//            return
//        }
//
//        let message = messages[indexPath.section]
//
//        switch message.kind {
//
//        case .photo(let media):
//
//            guard let imageUrl = media.url else {
//
//                return
//            }
//
//            let viewController = PhotoViewerViewController(with: imageUrl)
//            self.navigationController?.pushViewController(viewController, animated: true)
//        default:
//            break
//        }
//    }
// }
