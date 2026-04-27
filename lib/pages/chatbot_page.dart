import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String kGroqApiKey = dotenv.env['GROQ_API_KEY']!;
const String kGroqBaseUrl ='https://api.groq.com/openai/v1/chat/completions';
const String kGroqModel = 'llama-3.1-8b-instant';

const String kSystemPrompt = '''
You are BloodBot, an expert AI medical assistant embedded in BloodLink — a blood donation platform in India. 
You are highly specialized in:

1. BLOOD DONATION KNOWLEDGE:
   - Eligibility criteria (age 18–65, weight ≥45 kg, hemoglobin ≥12.5 g/dL for women, ≥13 g/dL for men)
   - Donation intervals (whole blood: 90 days, platelets: 7 days, plasma: 28 days)
   - Pre/post donation diet and care
   - Blood types: A+, A−, B+, B−, AB+, AB−, O+, O− and their compatibility
   - Universal donor (O−) and universal recipient (AB+) facts
   - Component donation vs. whole blood donation

2. MEDICAL KNOWLEDGE (blood-related):
   - Anemia, thalassemia, hemophilia, sickle cell disease
   - Iron deficiency and how to recover after donation
   - Hemoglobin levels, platelet counts, RBC/WBC significance
   - Blood pressure effects on donation eligibility
   - Medications that temporarily disqualify donors (aspirin 48hrs, antibiotics 7–14 days, etc.)

3. INDIA-SPECIFIC CONTEXT:
   - Tamil Nadu blood bank network
   - National Blood Transfusion Council guidelines
   - iDonate, eRaktKosh, and blood availability portals
   - Regional diseases affecting blood (dengue, malaria impact on donations)

4. EMERGENCY GUIDANCE:
   - How to find emergency blood in Coimbatore and Tamil Nadu
   - How to post urgent requests
   - What to say when contacting donors

PERSONALITY:
- Warm, empathetic, medically accurate
- Always speak in simple, clear language
- Use bullet points for lists, keep responses concise (max 200 words)
- If someone describes a medical emergency, always say "Please call 108 (ambulance) immediately"
- Never diagnose conditions — always recommend consulting a doctor for personal medical decisions
- Add relevant emojis sparingly to make responses friendly
- If asked non-medical questions, gently redirect: "I'm specialized in blood and donation topics. Let me help you with that!"

IMPORTANT: Always end responses related to medical advice with: "⚕️ This is general information. Please consult a doctor for personal medical advice."
''';

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
  });

  ChatMessage copyWith({String? content, bool? isTyping}) {
    return ChatMessage(
      id: id,
      content: content ?? this.content,
      isUser: isUser,
      timestamp: timestamp,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

const List<Map<String, String>> kSuggestedPrompts = [
  {'icon': '🩸', 'text': 'Am I eligible to donate blood today?'},
  {'icon': '⏳', 'text': 'How long after donation can I donate again?'},
  {'icon': '🍽️', 'text': 'What should I eat before donating?'},
  {'icon': '🅾️', 'text': 'Which blood type can donate to everyone?'},
  {'icon': '💊', 'text': 'Can I donate if I took aspirin yesterday?'},
  {'icon': '🚨', 'text': 'How to find emergency O− blood in Coimbatore?'},
];

const kRed = Color(0xFFD32F2F);
const kRedDark = Color(0xFF8B0000);
const kRedLight = Color(0xFFFFCDD2);
const kText = Color(0xFF1A0A0A);
const kTextSoft = Color(0xFF7B5B5B);
const kBotBubble = Color(0xFFFFFFFF);
const kUserBubble = Color(0xFFD32F2F);
const kBackground = Color(0xFFF7F2F2);

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage>
    with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isLoading = false;
  bool _showSuggestions = true;
  late AnimationController _typingCtrl;

  final List<Map<String, String>> _conversationHistory = [];

  @override
  void initState() {
    super.initState();
    _typingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    // Welcome message
    _addBotMessage(
      "Hello! I'm **BloodBot** 🩸\n\nI'm your specialized medical assistant for blood donation and health queries. I can help you with:\n\n• Donation eligibility & scheduling\n• Blood type compatibility\n• Pre & post-donation care\n• Finding emergency blood\n• Iron levels & hemoglobin info\n\nWhat can I help you with today?",
    );
  }

  @override
  void dispose() {
    _typingCtrl.dispose();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _addBotMessage(String content) {
    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
    );
    setState(() => _messages.add(msg));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userText = text.trim();
    _inputCtrl.clear();

    // Add user message
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: userText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isLoading = true;
      _showSuggestions = false;
    });
    _scrollToBottom();

    // Add typing indicator
    final typingId = 'typing_${DateTime.now().millisecondsSinceEpoch}';
    final typingMsg = ChatMessage(
      id: typingId,
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
      isTyping: true,
    );
    setState(() => _messages.add(typingMsg));
    _scrollToBottom();

    // Build conversation history
    _conversationHistory.add({'role': 'user', 'content': userText});

    try {
      final response = await _callGroqApi();

      // Remove typing indicator
      setState(() => _messages.removeWhere((m) => m.id == typingId));

      if (response != null) {
        _conversationHistory.add({'role': 'assistant', 'content': response});
        _addBotMessage(response);
      } else {
        _addBotMessage(
            "I'm having trouble connecting right now. Please check your internet connection and try again. 🔄");
      }
    } catch (e) {
      setState(() => _messages.removeWhere((m) => m.id == typingId));
      _addBotMessage(
          "Sorry, something went wrong. Please try again in a moment. 🙏");
    }

    setState(() => _isLoading = false);
  }

  Future<String?> _callGroqApi() async {
    try {
      final messages = [
        {'role': 'system', 'content': kSystemPrompt},
        ..._conversationHistory,
      ];

      final response = await http.post(
        Uri.parse(kGroqBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $kGroqApiKey',
        },
        body: jsonEncode({
          'model': kGroqModel,
          'messages': messages,
          'max_tokens': 512,
          'temperature': 0.4, // Lower = more factual/medical
          'top_p': 0.9,
          'stream': false,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String?;
      } else if (response.statusCode == 401) {
        return "⚠️ API key issue. Please contact support.";
      } else if (response.statusCode == 429) {
        return "⚠️ I'm receiving too many requests. Please wait a moment and try again.";
      } else {
        debugPrint('Groq error: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Groq exception: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _messages.length +
                        (_showSuggestions && _messages.length == 1 ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_showSuggestions &&
                          _messages.length == 1 &&
                          index == _messages.length) {
                        return _buildSuggestions();
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5C0A0A), Color(0xFFB71C1C), Color(0xFFD32F2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 14),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BloodBot AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF66BB6A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Medical AI • Blood Specialist',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Text('🤖', style: TextStyle(fontSize: 11)),
                    SizedBox(width: 4),
                    Text(
                      'Groq AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: kRedLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded, color: kRed, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ask BloodBot',
            style: TextStyle(
              color: kText,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Try asking:',
              style: TextStyle(
                color: kTextSoft,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kSuggestedPrompts.map((prompt) {
              return GestureDetector(
                onTap: () => _sendMessage(prompt['text']!),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kRedLight, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(prompt['icon']!,
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        prompt['text']!,
                        style: const TextStyle(
                          color: kText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.isTyping) return _buildTypingIndicator();

    final isUser = message.isUser;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kRedDark, kRed],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy_rounded,
                    color: Colors.white, size: 16),
              ),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.78,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isUser ? kUserBubble : kBotBubble,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isUser ? kRed : Colors.black).withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMessageText(message.content, isUser),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Spacer(),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            color: isUser
                                ? Colors.white.withOpacity(0.6)
                                : kTextSoft.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isUser) ...[
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFCDD2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded, color: kRed, size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageText(String content, bool isUser) {
    // Parse bold markdown (**text**) manually
    final spans = <TextSpan>[];
    final parts = content.split('**');
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        // Normal text — handle line breaks
        final lines = parts[i].split('\n');
        for (int j = 0; j < lines.length; j++) {
          if (j > 0) spans.add(const TextSpan(text: '\n'));
          spans.add(TextSpan(text: lines[j]));
        }
      } else {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.w800),
        ));
      }
    }
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: isUser ? Colors.white : kText,
          fontSize: 14,
          height: 1.5,
          fontFamily: 'Nunito',
        ),
        children: spans,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kRedDark, kRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: kBotBubble,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _typingCtrl,
                  builder: (context, _) {
                    final delay = i * 0.15;
                    final t = (_typingCtrl.value - delay).clamp(0.0, 1.0);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: kRed.withOpacity(0.3 + 0.7 * t),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildInputBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: kRedLight, width: 1.5),
                  ),
                  child: TextField(
                    controller: _inputCtrl,
                    maxLines: 4,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                      color: kText,
                      fontSize: 14,
                      fontFamily: 'Nunito',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask about blood donation...',
                      hintStyle: TextStyle(color: kTextSoft.withOpacity(0.6)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      suffixIcon: _inputCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close_rounded,
                                  color: kTextSoft, size: 18),
                              onPressed: () {
                                _inputCtrl.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_isLoading) ? null : (v) => _sendMessage(v),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _isLoading
                    ? null
                    : () => _sendMessage(_inputCtrl.text),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: _isLoading
                        ? const LinearGradient(
                            colors: [Color(0xFFBDBDBD), Color(0xFF9E9E9E)])
                        : const LinearGradient(
                            colors: [kRedDark, kRed],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    shape: BoxShape.circle,
                    boxShadow: _isLoading
                        ? []
                        : [
                            BoxShadow(
                              color: kRed.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded,
                          color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}