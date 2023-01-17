import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafi_menu/screens/menu_catagory_screen.dart';
import 'package:mafi_menu/widgets/text_widget.dart';

class MenuScreen extends StatefulWidget {
  final String id;
  final String collection;

  const MenuScreen({
    super.key,
    required this.id,
    required this.collection,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  TextEditingController NameController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController PriceController = TextEditingController();

  Future<void> _update([DocumentSnapshot? data]) async {
    if (data != null) {
      NameController.text = data['name'];
      DescriptionController.text = data['ingredients'];
      PriceController.text = data['price'];
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
                  controller: DescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: PriceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = NameController.text;
                    final String price = PriceController.text;
                    final String Description = DescriptionController.text;
                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc(widget.id)
                        .collection(widget.collection)
                        .doc(data!.id)
                        .update({
                      "name": name,
                      "ingredients": Description,
                      "price": price,
                    });
                    NameController.text = '';
                    DescriptionController.text = '';
                    PriceController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

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
                  controller: DescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: PriceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    final String name = NameController.text;
                    final String price = PriceController.text;
                    final String Description = DescriptionController.text;
                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc(widget.id)
                        .collection(widget.collection)
                        .doc()
                        .set({
                      "name": name,
                      "ingredients": Description,
                      "price": price,
                    });
                    NameController.text = '';
                    DescriptionController.text = '';
                    PriceController.text = '';
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
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://i.pinimg.com/564x/33/3f/a8/333fa833c582f8a375c57ff5703e1a88.jpg'))),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 45, 0, 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .doc(widget.id)
                        .collection(widget.collection)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamsnapshot) {
                      if (!streamsnapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          itemCount: streamsnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = streamsnapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(164, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            _update(data);
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          )),
                                    ],
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: data['name'],
                                        fontsize: 18,
                                        fontWeight: FontWeight.bold,
                                        textcolor: Colors.amber,
                                      ),
                                      TextWidget(
                                        text: data['ingredients'],
                                        textcolor:
                                            Color.fromARGB(255, 219, 219, 219),
                                        fontsize: 12,
                                      ),
                                    ],
                                  ),
                                  subtitle: Center(
                                    child: TextWidget(
                                      text: data['price'] + " birr",
                                      fontWeight: FontWeight.bold,
                                      textcolor: Colors.white,
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection('categories')
                                            .doc(widget.id)
                                            .collection(widget.collection)
                                            .doc(data.id)
                                            .delete();
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      )),
                                ),
                              ),
                            );
                          });
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
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MenuCatagoryScreen();
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _add();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          color: Colors.white,
                          fontSize: 20,
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
