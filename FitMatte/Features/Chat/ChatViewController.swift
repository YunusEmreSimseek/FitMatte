//
//  ChatViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import UIKit

final class ChatViewController: BaseViewController<ChatViewModel> {
    init() { super.init(viewModel: ChatViewModel()) }

    // MARK: Properties
    private var testLabel = LabelRow()
    private var messageBubble = MessageBubbleRow()
    private var messageBubbles: [MessageBubbleRow] = []

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await viewModel.loadChat()
            setup()
        }
    }

    // MARK: Setup
    private func setup() {
        configureNavigationBar()
        configureChatInputView()
        configureMessageBubbles()
        addSection(messageBubbles)

    }
}

// MARK: Components Configuration
extension ChatViewController {

    private func configureMessageBubbles() {
        guard let messages = viewModel.chat?.messages else { return }
        for message in messages {
            var bubble = MessageBubbleRow()
            bubble.configureView { messageBubble in
                if message.role == .user {
                    messageBubble.configureForUserMessage(message: message, userName: AppContainer.shared.userSessionManager.currentUser?.name ?? "User")
                }
                else {
                    messageBubble.configureForAIMessage(message)
                }
            }
            messageBubbles.append(bubble)
        }
    }

    private func configureChatInputView() {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = .init(systemName: "person")
            imageView.contentMode = .scaleAspectFill
            imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
            return imageView
        }()

        let textField: BaseTextField = {
            let textField = BaseTextField()
            textField.placeholder = "Type a message"
            textField.borderStyle = .roundedRect
            textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
            textField.card()
            return textField
        }()
        let sendButton = LinkButton()
        let stack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [imageView, textField, sendButton])
            stack.axis = .horizontal
            stack.spacing = 8
            stack.alignment = .center
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)

            return stack
        }()
        addFooterView(stack)
    }

    private func configureNavigationBar() {
        let deleteChatButton: UIBarButtonItem = {
            let button = UIBarButtonItem(image: .init(systemName: "minus"))
            button.tintColor = .systemBlue
            return button
        }()

        let aiMenuButton: UIBarButtonItem = {
            let button = UIBarButtonItem(image: .init(systemName: "wind"))
            button.tintColor = .systemBlue
            return button
        }()

        navigationItem.leftBarButtonItem = deleteChatButton
        navigationItem.rightBarButtonItem = aiMenuButton
        navigationItem.title = "OpenAI"
    }
}

// MARK: Preview
#Preview {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemBackground
    appearance.configureWithOpaqueBackground()
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().standardAppearance = appearance
    return MainTabBarViewController()
}
