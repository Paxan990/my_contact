import 'package:flutter/material.dart';
import 'package:my_contact/db/cached_contact.dart';
import 'package:my_contact/db/local_database.dart';

class ContactAddScreen extends StatefulWidget {
  const ContactAddScreen({Key? key, required this.listenerCallBack}) : super(key: key);
  final ValueChanged<bool> listenerCallBack;

  @override
  State<ContactAddScreen> createState() => _ContactAddScreenState();
}

class _ContactAddScreenState extends State<ContactAddScreen> {
  List<CachedContact> cachedContact = [];

  Future<void> _init() async {
    cachedContact = await LocalDatabase.getAllCachedUser();
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contact"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.text,
                controller: fullNameController,
                decoration: const InputDecoration(hintText: "Write Full Name"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: "Write Phone"),
              ),
              const SizedBox(height: 30),
              TextButton(
                  onPressed: () async {
                    String fullNameText = fullNameController.text;
                    String phoneText = phoneController.text;
                    CachedContact cachedContact = CachedContact(fullName: fullNameText, phone: phoneText);
                    await LocalDatabase.insertCachedContact(cachedContact);
                    widget.listenerCallBack.call(true);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: const [Text("Add contact"), SizedBox(width: 10), Icon(Icons.add_box)],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
