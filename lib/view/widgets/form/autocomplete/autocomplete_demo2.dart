import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: 'TolyAutocomplete 泛型使用',
  desc: '使用 itemBuilder 可根据泛型自定义浮层条目构建、',
)
class AutocompleteDemo2 extends StatelessWidget {
  const AutocompleteDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SizedBox(
            width: 240,
            child: TolyAutocomplete<User>(
              optionsBuilder: buildOptions,
              itemBuilder: _itemBuilder,
              fieldViewBuilder: _fieldViewBuilder,
              onSelected: _onSelected,
            )),
      ],
    );
  }

  void _onSelected(User value) {
    $message.success(message: '当前选择了 $value');
  }

  Future<Iterable<User>> buildOptions(
    TextEditingValue textEditingValue,
  ) async {
    if (textEditingValue.text == '') {
      return const Iterable<User>.empty();
    }
    return searchByArgs(textEditingValue.text);
  }

  Future<Iterable<User>> searchByArgs(String args) async {
    // 模拟网络请求
    await Future.delayed(const Duration(milliseconds: 200));
    const List<User> data = [
      User('toly', true, 'icon_5.webp'),
      User('toly49', false, 'icon_6.webp'),
      User('toly42', true, 'icon_7.webp'),
      User('toly56', false, 'icon_8.webp'),
      User('card', true, 'icon_5.webp'),
      User('ls', true, 'icon_6.webp'),
      User('alex', true, 'icon_7.webp'),
      User('fan sha', false, 'icon_8.webp'),
    ];
    return data.where((User user) => user.name.contains(args));
  }

  Widget _fieldViewBuilder(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
    return TolyInput(
      focusNode: focusNode,
      controller: textEditingController,
      hintText: 'search(eg. to)',
    );
  }

  Widget _itemBuilder(
    BuildContext context,
    TextEditingController textEditingController,
    User data,
    SelectEvent event,
  ) {
    return UserMenuItem(
      onTap: () => event(() => data.name),
      user: data,
      args: textEditingController.text,
    );
  }
}

class UserMenuItem extends StatefulWidget {
  final bool selected;
  final User user;
  final String args;
  final VoidCallback? onTap;

  const UserMenuItem({
    super.key,
    required this.user,
    this.selected = false,
    this.onTap,
    required this.args,
  });

  @override
  State<UserMenuItem> createState() => _UserMenuItemState();
}

class _UserMenuItemState extends State<UserMenuItem> with HoverActionMix {
  Color? get color {
    if (widget.selected) {
      return Color(0xfff5f5f5);
    }
    if (hovered) {
      return Color(0xfff5f5f5);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return wrap(
      Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              foregroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/head_icon/${widget.user.image}'),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(formSpan(widget.user.name, widget.args)),
                Text(
                  '性别: ${widget.user.man ? '男' : '女'}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(4))),
      ),
      onTap: widget.onTap,
    );
  }
}

final TextStyle lightTextStyle = const TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
);

InlineSpan formSpan(String src, String pattern) {
  List<TextSpan> span = [];
  List<String> parts = src.split(pattern);
  if (parts.length > 1) {
    for (int i = 0; i < parts.length; i++) {
      span.add(TextSpan(text: parts[i]));
      if (i != parts.length - 1) {
        span.add(TextSpan(text: pattern, style: lightTextStyle));
      }
    }
  } else {
    span.add(TextSpan(text: src));
  }
  return TextSpan(children: span);
}

class User {
  final String name;
  final bool man;
  final String image;

  const User(this.name, this.man, this.image);

  @override
  String toString() {
    return 'User{name: $name, man: $man, image: $image}';
  }
}
