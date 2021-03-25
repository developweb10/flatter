import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/model/contact_model.dart';
import 'package:krushapp/repositories/block_repository.dart';
import 'package:krushapp/utils/T.dart';
import '../../../repositories/block_contacts_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class BlockContactsPage extends StatefulWidget {
  List<ContactModel> blockedNumbers;
  Function addContact;
  Function removeContact;
  BlockContactsPage(this.blockedNumbers, this.addContact, this.removeContact);
  @override
  _BlockContactsPageState createState() => _BlockContactsPageState();
}

class _BlockContactsPageState extends State<BlockContactsPage> {
  List<ContactModel> contacts = List();
  List<Contact> from_contacts = List();
  List<ContactModel> from_contacts_list = List();

  TextEditingController searchController = TextEditingController();
  BlockContactsRepository blockContactsRepository = BlockContactsRepository();
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
    // blockedNumbers = blockContactsRepository.getBlockedContacts();
    super.initState();
  }

  sendAllContactsToDatabase() async {
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
        from_contacts.clear();
        from_contacts.addAll(value);
      });

  from_contacts_list.clear();
      from_contacts.forEach((contact) => {
            from_contacts_list.add(ContactModel(
                name: contact.displayName,
                phone: contact.phones.toList().length > 0
                    ? contact.phones.toList()[0].value
                    : ""))
          });

      setState(() {
        from_contacts_list = from_contacts_list;
      });

      sendAllContactsToDatabase();
    }

    
  }

  void searchContact(String query) async {
    if (await Permission.contacts.request().isGranted) {
      await ContactsService.getContacts(query: query, withThumbnails: false)
          .then((value) {
        from_contacts.clear();
        from_contacts.addAll(value);
      });
      from_contacts_list.clear();
      from_contacts.forEach((contact) => {
            from_contacts_list.add(ContactModel(
                name: contact.displayName,
                phone: contact.phones.toList().length > 0
                    ? contact.phones.toList()[0].value
                    : ""))
          });
      setState(() {
        from_contacts_list = from_contacts_list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Select Contacts', style: TextStyle(fontSize: 20)),
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back),
          )),
      body: CustomScrollView(
        slivers: <Widget>[
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
          from_contacts_list == null
              ? Container()
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                  List value = widget.blockedNumbers.where((element) {
                    return element.phone == from_contacts_list[index].phone;
                  }).toList();

                  bool blocked = value != null && value.length > 0;

                  return ListTile(
                    onTap: () {},
                    title: Text(from_contacts_list == null ||
                            from_contacts_list[index].name == null
                        ? ""
                        : from_contacts_list[index].name),
                    subtitle: Text(from_contacts_list == null ||
                            from_contacts_list[index].phone == null
                        ? ""
                        : from_contacts_list[index].phone),
                    trailing: IconButton(
                      icon: Icon(Icons.check_circle,
                          color: blocked ? Colors.red : Colors.grey),
                      onPressed: () {
                        setState(() {
                          if (!blocked) {
                            // widget.blockedNumbers.add(from_contacts_list[index]);
                            widget.addContact(
                                from_contacts_list[index].name ?? "",
                                from_contacts_list[index].phone ?? "");
                          } else {
                            // widget.blockedNumbers.remove(from_contacts_list[index]);
                            widget.removeContact(null,
                                number: from_contacts_list[index].phone);
                          }
                        });
                      },
                    ),
                  );
                }, childCount: from_contacts_list.length))
        ],
      ),
    );
  }
}
