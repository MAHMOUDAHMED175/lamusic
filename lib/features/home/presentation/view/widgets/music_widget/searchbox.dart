import 'package:flutter/material.dart';
import 'package:lamusic/core/utils/colors.dart';

import '../../search_view.dart';


class SearchBox extends StatefulWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  var searchText = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    searchText.addListener(() {
      setState(() {});
    });
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // عندما يكون في حالة التركيز، نقم بالانتقال إلى SearchView
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchView(),
          ),
        );
        // حالة تركيز الـ TextField لن تبقى لأننا قد قمنا بالانتقال إلى صفحة أخرى، لذلك نقوم بإلغاء التركيز.
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchText,
      focusNode: _focusNode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        suffixIcon: searchText.text.isNotEmpty
            ? IconButton(
                onPressed: () => setState(() {
                  searchText.text = "";
                }),
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.black,
                ),
              )
            : const SizedBox.shrink(),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        fillColor: ColorsApp.orangeColor.withOpacity(0.8),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide:  BorderSide(
            color:  Colors.lightBlueAccent,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
