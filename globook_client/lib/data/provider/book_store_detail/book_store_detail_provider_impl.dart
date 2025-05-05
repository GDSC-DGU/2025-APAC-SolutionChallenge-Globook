import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/data/provider/book_store_detail/book_store_detail_provider.dart';
import 'package:globook_client/domain/model/book.dart';

class BookStoreDetailProviderImpl extends BaseConnect
    implements BookStoreDetailProvider {
  @override
  Future<ResponseWrapper<Book>> getBookStoreDetail(String bookId) async {
    return ResponseWrapper<Book>(
      success: true,
      data: const Book(
        id: '1',
        title: '데미안',
        author: '헤르만 헤세',
        imageUrl: 'assets/books/demian.jpg',
        description:
            '『데미안』은 노벨문학상 수상 작가 헤르만 헤세가 1919년에 에밀 싱클레어라는 가명으로 발표한 소설로, 부모님의 품처럼 온화하고 밝은 세계에만 속해 있던 주인공 싱클레어가 처음으로 어둡고 악한 세계에 발을 들이며 겪는 내면의 갈등과 변화를 그린 작품입니다.',
        category: 'fiction',
      ),
    );
  }

  @override
  Future<ResponseWrapper<void>> addFavoriteBook(String bookId) async {
    return ResponseWrapper<void>(
      success: true,
      data: null,
    );
  }

  @override
  Future<ResponseWrapper<List<Book>>> getCategoryBooks() async {
    return ResponseWrapper<List<Book>>(
      success: true,
      data: [
        const Book(
          id: '2',
          title: '싯다르타',
          author: '헤르만 헤세',
          imageUrl: 'assets/books/siddhartha.jpg',
          description: '인도의 왕자 싯다르타가 깨달음을 얻기까지의 여정을 담은 소설',
          category: 'fiction',
        ),
        const Book(
          id: '3',
          title: '수레바퀴 아래서',
          author: '헤르만 헤세',
          imageUrl: 'assets/books/beneath_the_wheel.jpg',
          description: '교육 제도에 대한 비판과 개인의 정신적 성장을 그린 소설',
          category: 'fiction',
        ),
      ],
    );
  }

  @override
  Future<ResponseWrapper<void>> removeFavoriteBook(String bookId) async {
    return ResponseWrapper<void>(
      success: true,
      data: null,
    );
  }

  @override
  Future<ResponseWrapper<void>> downloadBook(String bookId) async {
    return ResponseWrapper<void>(
      success: true,
      data: null,
    );
  }
}
