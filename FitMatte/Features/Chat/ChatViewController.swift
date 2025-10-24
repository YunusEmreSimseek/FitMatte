//
//  ChatViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import UIKit

final class ChatViewController: BaseViewController<ChatViewModel> {
    init() { super.init(viewModel: ChatViewModel()) }

    // MARK: - UI Components
    private var rowItems: [BaseSectionRowProtocol] = []
    private var chatInputView = UIStackView()
    private var chatInputTextField = UITextField()
    private var suggestionRow = StackRow()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await viewModel.loadChat()
            setup()
        }
    }

    // MARK: - Setup
    private func setup() {
        configureNavigationBar()
        configureChatInputView()
        configureMessageBubbles()
        configureSuggestionRow()
        addSection(rowItems)
        addFooterView(chatInputView)
        scrollToBottom()
    }

    // MARK: - Reload
    private func reload() {
        cleanTable()
        rowItems = []
        chatInputView = .init()
        chatInputTextField = .init()
        suggestionRow = .init()
        configureChatInputView()
        configureMessageBubbles()
        configureSuggestionRow()
        addSection(rowItems)
        addFooterView(chatInputView)
        scrollToBottom()
    }
}

// MARK: - Component Configurations
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
//            messageBubbles.append(bubble)
            rowItems.append(bubble)
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
        let sendButton = LinkButton()
        sendButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            guard let messageText = chatInputTextField.text, !messageText.isEmpty else { return }
            chatInputTextField.resignFirstResponder()
            chatInputTextField.text = ""
            let response = viewModel.addUserMessage(messageText)
            reload()
            if response {
                Task {
                    await self.viewModel.sendMessage(messageText)
                    self.reload()
                }
            }
        }, for: .touchUpInside)

        chatInputTextField.placeholder = "Type a message"
        chatInputTextField.borderStyle = .roundedRect
        chatInputTextField.backgroundColor = .secondarySystemGroupedBackground
        chatInputTextField.returnKeyType = .send
        chatInputTextField.delegate = self

        chatInputView.addArrangedSubview(imageView)
        chatInputView.addArrangedSubview(chatInputTextField)
        chatInputView.addArrangedSubview(sendButton)
        chatInputView.distribution = .fill
        chatInputView.isLayoutMarginsRelativeArrangement = true
        chatInputView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        chatInputView.spacing = 16
    }

    private func configureNavigationBar() {
        let deleteChatButton: UIBarButtonItem = {
            let button = UIBarButtonItem(image: .init(systemName: "minus"))
            button.tintColor = .systemBlue
            button.primaryAction = UIAction { [weak self] _ in
                guard let self else { return }
                let alert = UIAlertController(
                    title: "Delete Chat",
                    message: "Are you sure you want to delete this chat? This action cannot be undone.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                    guard let self else { return }
                    Task {
                        await self.viewModel.deleteChat()
                        self.reload()
                    }
                })
                self.present(alert, animated: true)
            }
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

    private func configureSuggestionRow() {
        guard let suggestion = viewModel.suggestion else { return }
        let titleLabel = BaseLabel(suggestion.title, ThemeFont.defaultTheme.boldMediumText)
        let descriptionLabel = BaseLabel(suggestion.description, ThemeFont.defaultTheme.mediumText)
        let acceptButton: UIButton = {
            let button = UIButton(type: .system)
            var cfg = UIButton.Configuration.glass()
            cfg.title = "Accept"
            cfg.font(ThemeFont.defaultTheme.mediumText)
            button.configuration = cfg
            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                switch suggestion.action.type {
                case SuggestionActionType.setStepGoal.rawValue:
                    SuggestionActionType.setStepGoal.perform(with: suggestion.action.value)
                case SuggestionActionType.setCalorieGoal.rawValue:
                    SuggestionActionType.setCalorieGoal.perform(with: suggestion.action.value)
                case SuggestionActionType.setDietPlan.rawValue:
                    SuggestionActionType.setDietPlan.perform(with: suggestion.action.value)
                case SuggestionActionType.setWorkoutProgram.rawValue:
                    SuggestionActionType.setWorkoutProgram.perform(with: suggestion.action.value)
                default:
                    return
                }
                viewModel.suggestion = nil
                reload()
            }, for: .touchUpInside)
            return button
        }()
        let rejectButton: UIButton = {
            let button = UIButton(type: .system)
            var cfg = UIButton.Configuration.glass()
            cfg.title = "Reject"
            cfg.font(ThemeFont.defaultTheme.mediumText)
            button.configuration = cfg
            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                viewModel.suggestion = nil
                reload()
            }, for: .touchUpInside)
            return button
        }()
        let buttonStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [acceptButton, rejectButton, UIView()])
            stack.spacing = 16
            return stack
        }()

        suggestionRow.configureView { stack in
            stack.axis = .vertical
            stack.spacing = 8
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(descriptionLabel)
            stack.addArrangedSubview(buttonStack)
            stack.toCard()
        }
        rowItems.append(suggestionRow)
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
//        guard let messageText = textField.text, !messageText.isEmpty else {
//            textField.resignFirstResponder()
//            return false
//        }
//        print("Sending message: \(messageText)")
//        textField.resignFirstResponder()
//        textField.text = ""
//        let response = viewModel.addUserMessage(messageText)
//        reload()
//        if response {
//            Task {
//                await viewModel.sendMessage(messageText)
//                reload()
//            }
//        }
//        return true
    }
}

// MARK: - Preview
#Preview {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemBackground
    appearance.configureWithOpaqueBackground()
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().standardAppearance = appearance
    return MainTabBarViewController()
}
