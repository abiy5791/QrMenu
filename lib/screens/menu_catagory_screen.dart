import 'package:flutter/material.dart';
import 'package:mafi_menu/screens/menu_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/text_widget.dart';

class MenuCatagoryScreen extends StatefulWidget {
  const MenuCatagoryScreen({super.key});

  @override
  State<MenuCatagoryScreen> createState() => _MenuCatagoryScreenState();
}

class _MenuCatagoryScreenState extends State<MenuCatagoryScreen> {
  TextEditingController NameController = TextEditingController();
  TextEditingController ChoicesController = TextEditingController();
  TextEditingController ImageController = TextEditingController();
  
  Future<void> _add() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: NameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: ChoicesController,
                  decoration: const InputDecoration(labelText: 'Choices'),
                ),
                TextField(
                  controller: ImageController,
                  decoration: const InputDecoration(
                    labelText: 'Image',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    final String name = NameController.text;
                    final String Image = ImageController.text;
                    final String Choices = ChoicesController.text;
                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc()
                        .set({
                      "categoryName": name,
                      "choices": Choices,
                      "categoryImage": Image,
                    });
                    NameController.text = '';
                    ChoicesController.text = '';
                    ImageController.text = '';
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? data]) async {
    if (data != null) {
      NameController.text = data['categoryName'];
      ChoicesController.text = data['choices'];
      ImageController.text = data['categoryImage'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: NameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: ImageController,
                  decoration: const InputDecoration(labelText: 'Image'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: ChoicesController,
                  decoration: const InputDecoration(
                    labelText: 'Choices',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = NameController.text;
                    final String choices = ChoicesController.text;
                    final String image = ImageController.text;
                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc(data!.id)
                        .update({
                      "categoryName": name,
                      "choices": choices,
                      "categoryImage": image,
                    });
                    NameController.text = '';
                    ChoicesController.text = '';
                    ImageController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://i.pinimg.com/564x/6c/12/a1/6c12a1e789b141109340e8398971fe62.jpg'))),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamsnapshot) {
                      if (!streamsnapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: streamsnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = streamsnapshot.data!.docs[index];
                          return CategoriesWidget(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MenuScreen(
                                        id: streamsnapshot.data!.docs[index].id,
                                        collection: data['categoryName']);
                                  },
                                ),
                              );
                            },
                            onTapDelete: () {
                              FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(data.id)
                                  .delete();
                            },
                            onTapEdit: () {
                              _update(data);
                            },
                            image: data['categoryImage'],
                            CategoryName: data['categoryName'],
                            amount: data['choices'] +
                                " choices of " +
                                data['categoryName'],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _add();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    Text("Mafi Burger Menu",
                        style: GoogleFonts.yeonSung(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  final String image;
  final String CategoryName;
  final String amount;
  final Function()? onTap;
  final Function()? onTapEdit;
  final Function()? onTapDelete;
  const CategoriesWidget({
    super.key,
    required this.onTap,
    required this.image,
    required this.CategoryName,
    required this.amount,
    required this.onTapDelete,
    required this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(126, 0, 0, 0),
        ),
        child: ListTile(
          leading: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black45,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(image),
              ),
            ),
          ),
          title: Text(CategoryName,
              style: GoogleFonts.yeonSung(
                color: Colors.amber,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: amount,
                textcolor: Color.fromARGB(255, 219, 219, 219),
                fontsize: 12,
              ),
              GestureDetector(
                onTap: onTapDelete,
                child: Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 255, 133, 124),
                ),
              )
            ],
          ),
          trailing: GestureDetector(
            onTap: onTapEdit,
            child: Icon(
              Icons.edit,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
