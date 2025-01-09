import 'package:bookshop/models/book.dart';
import 'package:bookshop/providers/auth_provider.dart';
import 'package:bookshop/providers/book_provider.dart';
import 'package:bookshop/screens/admin/edit_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class DetailBook extends StatefulWidget {
  final Book book;
  const DetailBook(this.book, {super.key});

  @override
  State<DetailBook> createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> with RestorationMixin {
  @override
  void deactivate() {
    context.read<BookProvider>().detailBook = null;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(builder: (context, provider, child) {
      final detail = provider.detailBook ?? widget.book;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      detail.image,
                      height: context.height * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  detail.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('Description: ',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  detail.author,
                ),
                Text(
                  'Category: ${context.read<BookProvider>().categoryList.firstWhere(
                        (e) => e.id == detail.categoryId,
                        orElse: () => Category(id: 'id', name: 'N/A'),
                      ).name}',
                  style: TextStyle(fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<AuthProvider>(builder: (context, provider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: provider.user?.role == 'admin'
                  ? [
                      OutlinedButton.icon(
                        onPressed: () {
                          Get.to(() => EditBookScreen(book: detail));
                        },
                        icon: Icon(Icons.edit_document),
                        label: Text('Chỉnh sửa'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final success = await context
                              .read<BookProvider>()
                              .deleteBook(detail.id!);
                          if (success) {
                            Get.back();
                            Get.snackbar(
                                "Thành công", "Đã xóa sách ra khỏi thư viện");
                          } else {
                            Get.snackbar("Thất bại",
                                "Không thể xóa sách ra khỏi thư viện");
                          }
                        },
                        icon: Icon(Icons.delete_forever),
                        label: Text('Xóa sách'),
                      ),
                    ]
                  : [
                      OutlinedButton.icon(
                        onPressed: () =>
                            _borrowBook(context, detail, provider.user!),
                        icon: Icon(Icons.bookmark),
                        label: Text('Mượn sách'),
                      ),
                    ],
            );
          }),
        ),
      );
    });
  }

  _borrowBook(BuildContext context, Book book, User? user) async {
    _restorableDateRangePickerRouteFuture.present();
  }

  @override
  String? get restorationId => 'main';

  final _startDate = RestorableDateTimeN(DateTime.now());
  final _endDate = RestorableDateTimeN(DateTime.now().add(Duration(days: 7)));
  late final _restorableDateRangePickerRouteFuture =
      RestorableRouteFuture<DateTimeRange?>(
    onComplete: _selectDateRange,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator
          .restorablePush(_dateRangePickerRoute, arguments: <String, dynamic>{
        'initialStartDate': _startDate.value?.millisecondsSinceEpoch,
        'initialEndDate': _endDate.value?.millisecondsSinceEpoch,
      });
    },
  );

  void _selectDateRange(DateTimeRange? newSelectedDate) {
    if (newSelectedDate != null) {
      _startDate.value = newSelectedDate.start;
      _endDate.value = newSelectedDate.end;
      showDialog(
          context: context,
          builder: (dialogContext) {
            final detail =
                context.read<BookProvider>().detailBook ?? widget.book;
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Text('Tên sách: ${detail.name}'),
                  Text('Tác giả: ${detail.author}'),
                  Text(
                      'Ngày mượn: ${DateFormat('dd/MM/yyyy').format(_startDate.value!)}'),
                  Text(
                      'Ngày trả: ${DateFormat('dd/MM/yyyy').format(_endDate.value!)}'),
                ],
              ),
              actions: [
                OutlinedButton(onPressed: () => Get.back(), child: Text('Hủy')),
                FilledButton(
                    onPressed: () async {
                      Get.showOverlay<bool>(
                          asyncFunction: () => context
                              .read<BookProvider>()
                              .borrowBook(
                                bookId: detail.id!,
                                userId: context.read<AuthProvider>().user!.id,
                                borrowDate: _startDate.value!,
                                returnDate: _endDate.value!,
                              ),
                          loadingWidget:
                              Center(child: CircularProgressIndicator()));
                      Get.back();
                      context.read<BookProvider>().getBorrowedBooks(
                          context.read<AuthProvider>().user!.id);
                    },
                    child: Text('Mượn sách')),
              ],
            );
          });
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_startDate, 'start_date');
    registerForRestoration(_endDate, 'end_date');
    registerForRestoration(
        _restorableDateRangePickerRouteFuture, 'date_picker_route_future');
  }

  @pragma('vm:entry-point')
  static Route<DateTimeRange?> _dateRangePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTimeRange?>(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerDialog(
          restorationId: 'date_picker_dialog',
          initialDateRange:
              _initialDateTimeRange(arguments! as Map<dynamic, dynamic>),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
      },
    );
  }

  static DateTimeRange? _initialDateTimeRange(Map<dynamic, dynamic> arguments) {
    if (arguments['initialStartDate'] != null &&
        arguments['initialEndDate'] != null) {
      return DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialStartDate'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialEndDate'] as int),
      );
    }
    return null;
  }
}
