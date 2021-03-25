import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/model/contact_model.dart';
import 'package:krushapp/repositories/block_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = List();
  TextEditingController searchController = TextEditingController();
  List<Contact> from_contacts = List();
  List<ContactModel> from_contacts_list = List();

  BlockRepository blockRepository = BlockRepository();

  @override
  void initState() {
    getContacts();
    searchController.addListener(() {
      if (searchController.text.isEmpty)
        getContacts();
      else
        searchContact(searchController.text);
    });
    super.initState();
  }

  sendAllContactsToDatabase(from_contacts_list) async {
    if (await UserSettingsManager.getUserContactsUpdateDate() == null) {
      var result = await ApiClient.apiClient.sendAllContacts(from_contacts_list);
      if (result) {
        UserSettingsManager.setUserContactsUpdateDate(
            DateTime.now().toIso8601String());
      }
    } else {
      DateTime lastUpdateDate =
          DateTime.parse(await UserSettingsManager.getUserContactsUpdateDate());
      if (lastUpdateDate.add(Duration(days: 30)).isBefore(DateTime.now())) {
        var result = await ApiClient.apiClient.sendAllContacts(from_contacts_list);
        if (result) {
          UserSettingsManager.setUserContactsUpdateDate(
              DateTime.now().toIso8601String());
        }
      }
    }
  }

  void getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      await ContactsService.getContacts(withThumbnails: false)
          .then((value) async {
        contacts.clear();
        await contacts.addAll(value);
      });

      setState(() {
        contacts = contacts;
      });
from_contacts_list.clear();
      from_contacts.forEach((contact) => {
            from_contacts_list.add(ContactModel(
                name: contact.displayName,
                phone: contact.phones.toList().length > 0
                    ? contact.phones.toList()[0].value
                    : ""))
          });

      sendAllContactsToDatabase(from_contacts_list);
    }
  }

  void searchContact(String query) async {
    if (await Permission.contacts.request().isGranted)
      ContactsService.getContacts(query: query, withThumbnails: false)
          .then((value) {
        contacts.clear();
        setState(() {
          contacts.addAll(value);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Select Contact'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Search Contacts'),
              ),
            ),
          ),
          contacts == null
              ? Container()
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pop(contacts[index].phones.toList()[0].value);
                    },
                    title: Text(
                        contacts == null || contacts[index].displayName == null
                            ? ""
                            : contacts[index].displayName),
                    subtitle: Text(contacts == null ||
                            contacts[index].phones == null ||
                            contacts[index].phones.toList()[0].value == null
                        ? ""
                        : contacts[index].phones.toList()[0].value),
                  );
                }, childCount: contacts.length))
        ],
      ),
    );
  }
}
