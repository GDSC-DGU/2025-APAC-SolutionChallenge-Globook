import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/data/provider/favorite/favorite_provider.dart';

class FavoriteProviderImpl extends BaseConnect implements FavoriteProvider {
  @override
  Future<ResponseWrapper<List<Book>>> getFavoriteBooks() async {
    return ResponseWrapper(success: true, data: [
      const Book(
        id: '1',
        title: 'Beneath the Wheel',
        author: '헤르만 헤세',
        imageUrl: 'assets/books/beneath_the_wheel.jpg',
        description: '헤르만 헤세의 대표작',
        category: 'fiction',
      ),
      const Book(
        id: '2',
        title: 'Crime and Punishment',
        author: '표도르 도스토예프스키',
        imageUrl: 'assets/books/crime_and_punishment.jpg',
        description: '도스토예프스키의 대표작',
        category: 'fiction',
      ),
      const Book(
        id: '3',
        title: 'Foster',
        author: 'Claire Keegan',
        imageUrl: 'assets/books/foster.jpg',
        description: 'A thing of finely honed beauty',
        category: 'fiction',
      ),
    ]);
  }

  @override
  Future<ResponseWrapper<void>> removeFavoriteBook(String bookId) async {
    return ResponseWrapper(success: true, data: null);
  }
}
