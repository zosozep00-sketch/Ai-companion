import SwiftUI

// Modello per i messaggi della chat
struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp = Date()
}

struct ContentView: View {
    @State private var messages: [Message] = [
        Message(text: "Ciao! Come posso aiutarti oggi?", isUser: false)
    ]
    @State private var inputText: String = ""
    @State private var isTyping: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                // Lista dei messaggi della chat
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { message in
                                ChatBubble(message: message)
                            }
                            if isTyping {
                                HStack {
                                    Text("L'assistente sta scrivendo...")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .italic()
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages) { _ in
                        if let lastMessage = messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Barra di input dei messaggi
                HStack(spacing: 12) {
                    TextField("Scrivi un messaggio...", text: $inputText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        .submitLabel(.send)
                        .onSubmit(sendMessage)

                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("AI Companion")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func sendMessage() {
        let userText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userText.isEmpty else { return }

        messages.append(Message(text: userText, isUser: true))
        inputText = ""
        isTyping = true

        // Simulazione di risposta automatica (sostituibile con una chiamata API)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isTyping = false
            messages.append(Message(text: generateBotResponse(for: userText), isUser: false))
        }
    }

    func generateBotResponse(for input: String) -> String {
        let lowercased = input.lowercased()
        if lowercased.contains("ciao") || lowercased.contains("salve") {
            return "Ciao! È un piacere parlarti. Di cosa vorresti discutere?"
        } else if lowercased.contains("come stai") {
            return "Io sono un'intelligenza artificiale, quindi sto sempre alla grande! E tu come ti senti?"
        } else {
            return "È davvero interessante quello che dici su \"\(input)\". Raccontami di più!"
        }
    }
}

// Vista personalizzata per i fumetti della chat
struct ChatBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isUser { Spacer() }

            Text(message.text)
                .padding(12)
                .background(message.isUser ? Color.blue : Color(.systemGray5))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(16)
                .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)

            if !message.isUser { Spacer() }
        }
    }
}

@main
struct AICompanionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
