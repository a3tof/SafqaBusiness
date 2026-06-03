import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/chat/view/chat_thread_view_args.dart';
import 'package:safqaseller/features/chat/view/widgets/chat_thread_view_body.dart';
import 'package:safqaseller/features/chat/view_model/chat_thread/chat_thread_view_model.dart';

class ChatThreadView extends StatelessWidget {
  const ChatThreadView({super.key, required this.args});

  static const String routeName = 'chatThread';

  final ChatThreadViewArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final vm = getIt<ChatThreadViewModel>();
        if (args.disputeId != null) {
          vm.initDisputeConversation(args.disputeId!);
        } else {
          vm.loadMessages(args.conversationId);
        }
        return vm;
      },
      child: ChatThreadViewBody(args: args),
    );
  }
}
