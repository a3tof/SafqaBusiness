import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/chat/view/chat_thread_view.dart';
import 'package:safqaseller/features/chat/view/chat_thread_view_args.dart';
import 'package:safqaseller/features/notifications/model/models/notification_model.dart';
import 'package:safqaseller/features/notifications/view/widgets/notification_item.dart';
import 'package:safqaseller/features/notifications/view_model/notifications/notifications_view_model.dart';
import 'package:safqaseller/features/notifications/view_model/notifications/notifications_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';

class NotificationsViewBody extends StatefulWidget {
  const NotificationsViewBody({super.key});

  @override
  State<NotificationsViewBody> createState() => _NotificationsViewBodyState();
}

class _NotificationsViewBodyState extends State<NotificationsViewBody> {
  bool _selectionMode = false;
  final Set<int> _selectedIds = <int>{};

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final viewModel = context.read<NotificationsViewModel>();
    await viewModel.loadNotifications();
    await viewModel.markAllAsSeen();
  }

  void _exitSelection() {
    setState(() {
      _selectionMode = false;
      _selectedIds.clear();
    });
  }

  void _toggleSelectAll(List<NotificationModel> notifications) {
    setState(() {
      if (_selectedIds.length == notifications.length) {
        _selectedIds.clear();
      } else {
        _selectedIds
          ..clear()
          ..addAll(notifications.map((e) => e.id));
      }
    });
  }

  void _toggleItemSelected(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _startSelectionWith(int id) {
    setState(() {
      _selectionMode = true;
      _selectedIds
        ..clear()
        ..add(id);
    });
  }

  Future<void> _confirmDeleteSelected() async {
    if (_selectedIds.isEmpty) return;
    final count = _selectedIds.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(ctx).notificationsDelete),
        content: Text(S.of(ctx).notificationsDeleteSelectionConfirm(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(S.of(ctx).notificationsCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              S.of(ctx).notificationsDelete,
              style: TextStyle(color: Theme.of(ctx).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<NotificationsViewModel>().deleteNotifications(
        _selectedIds.toList(),
      );
      _exitSelection();
    }
  }

  void _onToolbarDismiss() {
    if (_selectedIds.isNotEmpty) {
      _confirmDeleteSelected();
    } else {
      _exitSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return BlocListener<NotificationsViewModel, NotificationsState>(
      listenWhen: (previous, current) => current is NotificationsLoading,
      listener: (context, state) {
        if (_selectionMode) _exitSelection();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context, scheme, isEnglish),
        body: RefreshIndicator(
          onRefresh: _loadNotifications,
          child: BlocBuilder<NotificationsViewModel, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                final isTabletOrUp = Breakpoints.isTabletOrUp(context);
                return Skeletonizer(
                  enabled: true,
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isTabletOrUp ? 16.0 : 16.rSp(context),
                        vertical: isTabletOrUp ? 16.0 : 16.rSp(context),
                      ),
                      child: ResponsiveFormShell(
                        enabled: isTabletOrUp,
                        maxWidth: 700,
                        child: ResponsiveFormSection(
                          child: _NotificationsList(
                            notifications: List.generate(
                      6,
                      (index) => NotificationModel(
                        id: index,
                        title: 'Loading Title for Skeleton',
                        message: 'Loading Message for Skeletonizer',
                        timeAgo: 'Now',
                        type: NotificationType.newAuction,
                        isRead: true,
                      ),
                    ),
                    selectionMode: false,
                    selectedIds: const {},
                    onToggleItem: (_) {},
                    onStartSelectionWith: (_) {},
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (state is NotificationsError) {
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48.rSp(context),
                              color: Theme.of(context).hintColor,
                            ),
                            SizedBox(height: 12.rSp(context)),
                            Text(
                              state.message,
                              style: TextStyles.regular14(
                                context,
                              ).copyWith(color: Theme.of(context).hintColor),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.rSp(context)),
                            TextButton(
                              onPressed: _loadNotifications,
                              child: Text(
                                S.of(context).retry,
                                style: TextStyles.medium16(
                                  context,
                                ).copyWith(color: scheme.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (state is NotificationsSuccess) {
                if (state.notifications.isEmpty) {
                  if (_selectionMode) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) _exitSelection();
                    });
                  }
                  return const _EmptyNotificationsPlaceholder();
                }

                final isTabletOrUp = Breakpoints.isTabletOrUp(context);
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTabletOrUp ? 16.0 : 16.rSp(context),
                      vertical: isTabletOrUp ? 16.0 : 16.rSp(context),
                    ),
                    child: ResponsiveFormShell(
                      enabled: isTabletOrUp,
                      maxWidth: 700,
                      child: ResponsiveFormSection(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_selectionMode)
                              _SelectionToolbar(
                                selectedCount: _selectedIds.length,
                                allSelected:
                                    _selectedIds.length == state.notifications.length,
                                onDismiss: _onToolbarDismiss,
                                onToggleSelectAll: () =>
                                    _toggleSelectAll(state.notifications),
                              ),
                            _NotificationsList(
                              notifications: state.notifications,
                              selectionMode: _selectionMode,
                              selectedIds: _selectedIds,
                              onToggleItem: _toggleItemSelected,
                              onStartSelectionWith: _startSelectionWith,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    ColorScheme scheme,
    bool isEnglish,
  ) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          if (_selectionMode) {
            _exitSelection();
          } else if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        icon: Icon(
          _selectionMode ? Icons.close : Icons.arrow_back_ios_new,
          color: scheme.primary,
          size: 22.rSp(context),
        ),
      ),
      title: Text(
        isEnglish
            ? S.of(context).notificationsTitle.toUpperCase()
            : S.of(context).notificationsTitle,
        style: TextStyles.bold22(context).copyWith(
          color: scheme.primary,
          fontFamily: Localizations.localeOf(context).languageCode == 'ar'
              ? 'Cairo'
              : 'AlegreyaSC',
        ),
      ),
      actions: [
        BlocBuilder<NotificationsViewModel, NotificationsState>(
          builder: (context, state) {
            if (state is! NotificationsSuccess) {
              return const SizedBox.shrink();
            }
            if (_selectionMode) {
              return const SizedBox.shrink();
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.notifications.any((n) => !n.isRead))
                  TextButton(
                    onPressed: () =>
                        context.read<NotificationsViewModel>().markAllAsRead(),
                    child: Text(
                      S.of(context).notificationsMarkAll,
                      style: TextStyles.medium14(
                        context,
                      ).copyWith(color: scheme.primary),
                    ),
                  ),
                if (state.notifications.isNotEmpty)
                  IconButton(
                    tooltip: S.of(context).notificationsSelect,
                    onPressed: () {
                      setState(() {
                        _selectionMode = true;
                        _selectedIds.clear();
                      });
                    },
                    icon: Icon(
                      Icons.checklist_rounded,
                      color: scheme.primary,
                      size: 26.rSp(context),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ── Selection toolbar (matches bulk-select action row) ───────────────────────

class _SelectionToolbar extends StatelessWidget {
  const _SelectionToolbar({
    required this.selectedCount,
    required this.allSelected,
    required this.onDismiss,
    required this.onToggleSelectAll,
  });

  final int selectedCount;
  final bool allSelected;
  final VoidCallback onDismiss;
  final VoidCallback onToggleSelectAll;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(8.rSp(context), 0, 16.rSp(context), 8.rSp(context)),
      child: Row(
        children: [
          IconButton(
            onPressed: onDismiss,
            icon: Icon(
              selectedCount > 0
                  ? Icons.delete_outline_rounded
                  : Icons.close_rounded,
              color: scheme.error,
              size: 28.rSp(context),
            ),
          ),
          Text(
            '$selectedCount',
            style: TextStyles.semiBold16(
              context,
            ).copyWith(color: Theme.of(context).hintColor),
          ),
          const Spacer(),
          Checkbox(
            value: allSelected,
            onChanged: (_) => onToggleSelectAll(),
            side: BorderSide(color: scheme.primary, width: 1.5),
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return scheme.primary;
              }
              return null;
            }),
            checkColor: scheme.onPrimary,
          ),
          GestureDetector(
            onTap: onToggleSelectAll,
            child: Text(
              S.of(context).notificationsAll,
              style: TextStyles.medium14(
                context,
              ).copyWith(color: Theme.of(context).hintColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notifications list ─────────────────────────────────────────────────────────

class _NotificationsList extends StatelessWidget {
  const _NotificationsList({
    required this.notifications,
    required this.selectionMode,
    required this.selectedIds,
    required this.onToggleItem,
    required this.onStartSelectionWith,
  });

  final List<NotificationModel> notifications;
  final bool selectionMode;
  final Set<int> selectedIds;
  final void Function(int id) onToggleItem;
  final void Function(int id) onStartSelectionWith;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: notifications.length,
      separatorBuilder: (_, _) => SizedBox(height: Breakpoints.isTabletOrUp(context) ? 12.0 : 12.rSp(context)),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final selected = selectedIds.contains(notification.id);
        return NotificationItem(
          notification: notification,
          selectionMode: selectionMode,
          selected: selected,
          onTap: () {
            if (selectionMode) {
              onToggleItem(notification.id);
              return;
            }
            context.read<NotificationsViewModel>().markNotificationSeenAndRead(
              notification.id,
            );
          },
          onLongPress: selectionMode
              ? null
              : () => onStartSelectionWith(notification.id),
          onActionTap: () {
            if (selectionMode) return;
            context.read<NotificationsViewModel>().markNotificationSeenAndRead(
              notification.id,
            );
            Navigator.pushNamed(
              context,
              ChatThreadView.routeName,
              arguments: ChatThreadViewArgs(
                conversationId: notification.id,
                buyerName: notification.title.isEmpty
                    ? S.of(context).chatTitle
                    : notification.title,
              ),
            );
          },
        );
      },
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyNotificationsPlaceholder extends StatelessWidget {
  const _EmptyNotificationsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64.rSp(context),
                  color: Theme.of(context).hintColor.withValues(alpha: 0.45),
                ),
                SizedBox(height: 16.rSp(context)),
                Text(
                  S.of(context).notificationsEmpty,
                  style: TextStyles.medium16(
                    context,
                  ).copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
