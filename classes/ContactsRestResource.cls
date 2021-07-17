@RestResource(UrlMapping='/contacts')
global class ContactsRestResource {

    @TestVisible static Integer numberOfRecordsToQuery = 2;
    @TestVisible static ContactDao contactDao = new ContactDao();

    @HttpGet
    global static List<Contact> getRecords() {
        return contactDao.getContactsWithLimit(numberOfRecordsToQuery);
    }
}