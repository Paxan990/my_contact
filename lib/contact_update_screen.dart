import 'package:flutter/material.dart';
import 'package:my_contact/db/cached_contact.dart';
import 'package:my_contact/db/local_database.dart';

class ContactUpdateScreen extends StatefulWidget {
  const ContactUpdateScreen({Key? key, required this.initialFullName, required this.initialPhone, required this.listenerCallBack, required this.id})
      : super(
          key: key,
        );
  final ValueChanged<bool> listenerCallBack;
  final String initialFullName;
  final String initialPhone;
  final int id;

  @override
  State<ContactUpdateScreen> createState() => _ContactUpdateScreenState();
}

class _ContactUpdateScreenState extends State<ContactUpdateScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void _init() async {
    fullNameController.text = widget.initialFullName;
    phoneController.text = widget.initialPhone;
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Contact"),
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
                    await LocalDatabase.updateCachedContact(

                        cachedContact: CachedContact(
                          id: widget.id,
                          fullName: fullNameController.text,
                          phone: phoneController.text,
                        ));
                    widget.listenerCallBack.call(true);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: const [Text("Update contact"), SizedBox(width: 10), Icon(Icons.edit)],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
