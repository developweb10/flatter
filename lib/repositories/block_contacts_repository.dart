



class BlockContactsRepository {

static List<String> blocked_contacts = [];

List<String> getBlockedContacts(){
return blocked_contacts;
}
 setBlockedContacts(String contacts){

   blocked_contacts.add(contacts);
}
}
