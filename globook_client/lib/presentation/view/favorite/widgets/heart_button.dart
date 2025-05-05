import 'package:flutter/material.dart';
import 'package:globook_client/app/config/color_system.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/core/view/base_widget.dart';
import 'package:globook_client/presentation/view_model/favorite/favorite_view_model.dart';

class HeartButton extends BaseWidget<FavoriteViewModel> {
  final Book book;

  const HeartButton({super.key, required this.book});

  @override
  Widget buildView(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: ColorSystem.light,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          viewModel.removeFavoriteBook(book.id);
        },
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.favorite, size: 20),
      ),
    );
  }
}
