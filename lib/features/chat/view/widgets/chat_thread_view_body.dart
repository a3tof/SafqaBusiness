import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/chat/view/chat_thread_view_args.dart';
import 'package:safqaseller/features/chat/view/widgets/chat_input_bar.dart';
import 'package:safqaseller/features/chat/view/widgets/other_message_bubble.dart';
import 'package:safqaseller/features/chat/view/widgets/system_message_bubble.dart';
import 'package:safqaseller/features/chat/view/widgets/user_message_bubble.dart';
import 'package:safqaseller/features/chat/view_model/chat_thread/chat_thread_view_model.dart';
import 'package:safqaseller/features/chat/view_model/chat_thread/chat_thread_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class _ChatMessage {
  final String id;
  final String text;
  final bool isSystem;
  final bool isMe;
  final DateTime? createdAt;
  final bool isSeen;
  final bool isSending;
  final bool isFailed;

  _ChatMessage({
    required this.id,
    required this.text,
    required this.isSystem,
    this.isMe = false,
    this.createdAt,
    this.isSeen = false,
    this.isSending = false,
    this.isFailed = false,
  });

  _ChatMessage copyWith({bool? isSending, bool? isFailed}) {
    return _ChatMessage(
      id: id,
      text: text,
      isSystem: isSystem,
      isMe: isMe,
      createdAt: createdAt,
      isSeen: isSeen,
      isSending: isSending ?? this.isSending,
      isFailed: isFailed ?? this.isFailed,
    );
  }
}

class ChatThreadViewBody extends StatefulWidget {
  const ChatThreadViewBody({super.key, required this.args});

  final ChatThreadViewArgs args;

  @override
  State<ChatThreadViewBody> createState() => _ChatThreadViewBodyState();
}

class _ChatThreadViewBodyState extends State<ChatThreadViewBody> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  List<_ChatMessage> _messages = [];

  void _sendMessage() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    context.read<ChatThreadViewModel>().sendMessage(text.trim());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = Breakpoints.isTabletOrUp(context)
        ? 700.0
        : double.infinity;
    final kHorizontalPadding = Breakpoints.isTabletOrUp(context) ? 24.0 : 16.0;

    // In the seller app, dynamic title handling based on args
    final title = widget.args.disputeId != null
        ? S.of(context).chatTitle
        : widget.args.buyerName;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.primary,
            size: Breakpoints.isTabletOrUp(context) ? 22.0 : 22.0,
          ),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.bold22(
            context,
          ).copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: BlocConsumer<ChatThreadViewModel, ChatThreadState>(
        listenWhen: (previous, current) {
          if (previous is! ChatThreadSuccess && current is ChatThreadSuccess)
            return true;
          if (previous is ChatThreadSuccess && current is ChatThreadSuccess) {
            return previous.messages != current.messages ||
                previous.isSending != current.isSending ||
                previous.sendErrorMessage != current.sendErrorMessage;
          }
          return current is ChatThreadFailure;
        },
        listener: (context, state) {
          if (state is ChatThreadSuccess) {
            _messages.clear();

            final reason = state.disputeReason;
            if (reason != null && reason.isNotEmpty) {
              _messages.add(
                _ChatMessage(
                  id: 'system_init',
                  text:
                      'User opened a dispute: The item does not match the description/is damaged.: $reason',
                  isSystem: true,
                  createdAt: DateTime.now().subtract(const Duration(days: 1)),
                ),
              );
            }

            final sellerId = state.currentSellerId;
            final reversed = state.messages.reversed.toList();
            for (final msg in reversed) {
              final isMyMessage = (msg.senderName != null && sellerId != null)
                  ? msg.senderName == sellerId
                  : msg.isMine;

              _messages.add(
                _ChatMessage(
                  id: msg.id.toString(),
                  text: msg.content,
                  isSystem: false,
                  isMe: isMyMessage,
                  createdAt: msg.sentAt,
                  isSeen: false,
                  isSending: msg.isPending,
                  isFailed: false,
                ),
              );
            }

            if (state.sendErrorMessage != null) {
              for (int i = _messages.length - 1; i >= 0; i--) {
                if (_messages[i].isMe && _messages[i].isSending) {
                  _messages[i] = _messages[i].copyWith(
                    isSending: false,
                    isFailed: true,
                  );
                  break;
                }
              }
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.sendErrorMessage!)));
            }

            setState(() {});

            Future.delayed(const Duration(milliseconds: 100), () {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(
                  _scrollController.position.maxScrollExtent,
                );
              }
            });
          } else if (state is ChatThreadFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ChatThreadFailure && _messages.isEmpty) {
            return Center(
              child: Text(
                state.message.toLowerCase().contains('not found')
                    ? S.of(context).chatNotFound
                    : state.message,
                style: TextStyles.medium16(
                  context,
                ).copyWith(color: Theme.of(context).hintColor),
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Skeletonizer(
                          enabled: state is ChatThreadLoading,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                              horizontal: kHorizontalPadding,
                              vertical: 16.0,
                            ),
                            itemCount: state is ChatThreadLoading
                                ? 6
                                : _messages.length,
                            itemBuilder: (context, index) {
                              if (state is ChatThreadLoading) {
                                final isMe = index % 2 == 0;
                                final fakeText = isMe
                                    ? "This is a mocked message"
                                    : "This is another mocked message";

                                if (isMe) {
                                  return UserMessageBubble(
                                    text: fakeText,
                                    createdAt: DateTime.now(),
                                    isSeen: true,
                                  );
                                } else {
                                  return OtherMessageBubble(
                                    text: fakeText,
                                    createdAt: DateTime.now(),
                                  );
                                }
                              }

                              final msg = _messages[index];
                              Widget child;

                              if (msg.isSystem) {
                                child = SystemMessageBubble(text: msg.text);
                              } else if (msg.isMe) {
                                child = UserMessageBubble(
                                  text: msg.text,
                                  createdAt: msg.createdAt,
                                  isSeen: msg.isSeen,
                                  isSending: msg.isSending,
                                  isFailed: msg.isFailed,
                                  onResend: msg.isFailed
                                      ? () {
                                          context
                                              .read<ChatThreadViewModel>()
                                              .sendMessage(msg.text);
                                        }
                                      : null,
                                );
                              } else {
                                child = OtherMessageBubble(
                                  text: msg.text,
                                  createdAt: msg.createdAt,
                                );
                              }

                              final isNew =
                                  msg.createdAt != null &&
                                  DateTime.now().difference(msg.createdAt!) <
                                      const Duration(milliseconds: 500);
                              final double begin = isNew ? 0.0 : 1.0;

                              return TweenAnimationBuilder<double>(
                                key: ValueKey(msg.id),
                                tween: Tween<double>(begin: begin, end: 1.0),
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, _) {
                                  return Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Opacity(
                                      opacity: value.clamp(0.0, 1.0),
                                      child: child,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      ChatInputBar(
                        controller: _controller,
                        onSend: _sendMessage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
