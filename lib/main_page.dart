import 'package:dicoding_flutter_project/details_page.dart';
import 'package:dicoding_flutter_project/model/book_data.dart';
import 'package:flutter/material.dart';
import 'reusables.dart' as reusables;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Book> filteredBooks = books;
  String query = '';

  void _updateSearch(String value) {
    setState(() {
      query = value;
      filteredBooks = books.where((book) {
        return book.title.toLowerCase().startsWith(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusables.appBar,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Discover",
              style: TextStyle(
                
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "Temukan Buku Terbaik mu Sekarang !.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "mau cari apa?",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    onChanged: _updateSearch,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.grey),
                  onPressed: () {
                    _updateSearch(query);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (filteredBooks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/shock.png', width: 300), // Ganti dengan path gambar Anda
                          const Text(
                            'Tidak ada hasil',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'coolvetica',
                            ),
                          ),
                          SizedBox(height: 90),
                        ],
                      ),
                    );
                  } else if (constraints.maxWidth <= 600) {
                    return BooksListView(books: filteredBooks);
                  } else if (constraints.maxWidth <= 1200) {
                    return BooksGridView(books: filteredBooks, crossAxisCount: 4);
                  } else {
                    return BooksGridView(books: filteredBooks, crossAxisCount: 6);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BooksGridView extends StatelessWidget {
  final List<Book> books;
  final int crossAxisCount;

  const BooksGridView({
    super.key,
    required this.books,
    this.crossAxisCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      children: books.map((book) {
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DetailsPage(book);
            }));
          },
          child: BookGridItem(book),
        );
      }).toList(),
    );
  }
}

class BookGridItem extends StatelessWidget {
  final Book book;

  const BookGridItem(this.book, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        4.0
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 4.0
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withOpacity(0.25),
                    blurRadius: 2.0,
                    spreadRadius: 2.0
                  )
                ]
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Hero(
                    tag: '${book.title} (${book.isbn}) cover',
                    child: Image.asset(
                      book.cover,
                      height: constraints.maxHeight,
                      width: constraints.maxHeight * 2 / 3,
                      fit: BoxFit.fill
                    )
                  );
                }
              ),
            ),
          ),
          const SizedBox(
            height: 8.0
          ),
          Text(
            book.title,
            style: const TextStyle(
              fontSize: 20.0,
              height: 1.25,
              fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center
          ),
          const SizedBox(
            height: 8.0
          ),
          Text(
            book.author,
            style: const TextStyle(
              fontSize: 18.0,
              height: 1.2,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis
            ),
            softWrap: false,
            textAlign: TextAlign.center
          ),
          const SizedBox(
            height: 8.0
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                book.publicationDate,
                style: const TextStyle(
                  fontSize: 18.0,
                  height: 1.2,
                  fontWeight: FontWeight.w500
                )
              ),
              const SizedBox(
                width: 8.0
              ),
              const Icon(
                Icons.circle,
                size: 6.0
              ),
              const SizedBox(
                width: 8.0
              ),
              Text(
                book.genre,
                style: const TextStyle(
                  fontSize: 18.0,
                  height: 1.2,
                  fontWeight: FontWeight.w500
                )
              )
            ]
          )
        ]
      ),
    );
  }
}

class BooksListView extends StatelessWidget {
  final List<Book> books;

  const BooksListView({
    super.key,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index <= 0) {
          return SizedBox(
            height: (reusables.divider.thickness ?? 0) >= (reusables.divider.height ?? 0)
                ? (reusables.divider.thickness ?? 0)
                : (reusables.divider.height ?? 0),
          );
        } else if (index >= books.length + 1) {
          return const SizedBox(height: 256);
        }
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DetailsPage(books[index - 1]);
            }));
          },
          child: BookListItem(books[index - 1], index: index),
        );
      },
      separatorBuilder: (context, index) {
        return reusables.divider;
      },
      itemCount: books.length + 2,
    );
  }
}

class BookListItem extends StatelessWidget {
  static const double height = 200;
  final Book book;
  final int index;

  const BookListItem(this.book, {
    super.key,
    this.index = 0
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withOpacity(0.25),
              blurRadius: 2.0,
              spreadRadius: 2.0
            )
          ]
        ),
        child: Hero(
          tag: '${book.title} (${book.isbn}) cover',
          child: Image.asset(
            book.cover,
            height: height,
            width: height * 2 / 3,
            fit: BoxFit.fill
          )
        )
      ),
      const SizedBox(
        width: 16.0,
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 20.0,
                height: 1.25,
                fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.left
            ),
            const SizedBox(
              height: 8.0
            ),
            Text(
              book.author,
              style: const TextStyle(
                fontSize: 18.0,
                height: 1.2,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis
              ),
              softWrap: false,
              textAlign: TextAlign.left
            ),
            const SizedBox(
              height: 8.0
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  book.publicationDate,
                  style: const TextStyle(
                    fontSize: 18.0,
                    height: 1.2,
                    fontWeight: FontWeight.w500
                  )
                ),
                const SizedBox(
                  width: 8.0
                ),
                const Icon(
                  Icons.circle,
                  size: 6.0
                ),
                const SizedBox(
                  width: 8.0
                ),
                Text(
                  book.genre,
                  style: const TextStyle(
                    fontSize: 18.0,
                    height: 1.2,
                    fontWeight: FontWeight.w500
                  )
                )
              ]
            )
          ]
        )
      ),
      const SizedBox(
        width: 16.0,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 4.0
      ),
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children
      )
    );
  }
}
