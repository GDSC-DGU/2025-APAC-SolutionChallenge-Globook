import 'package:globook_client/core/provider/base_connect.dart';
import 'package:globook_client/data/model/repsonse_wrapper.dart';
import 'package:globook_client/domain/model/book.dart';
import 'package:globook_client/data/provider/home/home_provider.dart';
import 'package:globook_client/app/utility/log_util.dart';

class HomeProviderImpl extends BaseConnect implements HomeProvider {
  // TODO: API 연동 후 수정
  @override
  Future<ResponseWrapper<Book>> getLastReadBook() async {
    const book = Book(
      id: '1',
      title: 'Today Book',
      author: 'Author',
      description: 'Description',
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Category',
    );
    return ResponseWrapper(success: true, data: book);
  }

  @override
  Future<ResponseWrapper<List<Book>>> getLibraryBooks() async {
    final books = [
      const Book(
        id: '1',
        title: 'Beneath the Wheel',
        author: '헤르만 헤세',
        imageUrl: 'https://via.placeholder.com/150',
        description: '',
        category: '',
        authorBooks: [],
      ),
      const Book(
        id: '2',
        title: 'Crime and Punishment',
        author: '표도르 도스토예프스키',
        imageUrl: 'https://via.placeholder.com/150',
        description: '',
        category: '',
        authorBooks: [],
      ),
      const Book(
        id: '3',
        title: 'Foster',
        author: 'Claire Keegan',
        imageUrl: 'https://via.placeholder.com/150',
        description: '',
        category: '',
        authorBooks: [],
      ),
    ];
    return ResponseWrapper(success: true, data: books);
  }
}
