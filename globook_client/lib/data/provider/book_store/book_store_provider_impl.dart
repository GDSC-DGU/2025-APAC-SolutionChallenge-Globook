import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/book_store/book_store_provider.dart';
import 'package:globook_client/domain/model/book.dart';

class BookStoreProviderImpl extends BaseConnect implements BookStoreProvider {
  @override
  Future<ResponseWrapper<List<Book>>> getTodayBooks() async {
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
  Future<ResponseWrapper<List<Book>>> getNonFictionBooks() async {
    return ResponseWrapper(success: true, data: [
      const Book(
        id: '4',
        title: '1984',
        author: 'George Orwell',
        imageUrl: 'assets/books/1984.jpg',
        description: '조지 오웰의 디스토피아 소설',
        category: 'non-fiction',
      ),
      const Book(
        id: '5',
        title: 'Brave New World',
        author: 'Aldous Huxley',
        imageUrl: 'assets/books/brave_new_world.jpg',
        description: '올더스 헉슬리의 대표작',
        category: 'non-fiction',
      ),
    ]);
  }

  @override
  Future<ResponseWrapper<List<Book>>> getPhilosophyBooks() async {
    return ResponseWrapper(success: true, data: [
      const Book(
        id: '6',
        title: 'The Boy in the Striped Pyjamas',
        author: 'John Boyne',
        imageUrl: 'assets/books/the_boy.jpg',
        description: '존 보인의 대표작',
        category: 'philosophy',
      ),
      const Book(
        id: '7',
        title: 'Foster',
        author: 'Claire Keegan',
        imageUrl: 'assets/books/foster.jpg',
        description: 'A small miracle',
        category: 'philosophy',
      ),
    ]);
  }
}
