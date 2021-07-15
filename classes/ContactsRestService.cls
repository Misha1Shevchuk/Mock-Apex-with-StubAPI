@RestResource(UrlMapping='/contacts')
global class ContactsRestService {

    @TestVisible static Integer NUMBER_OF_RECORDS_TO_QUERY = 2;
    @TestVisible static ContactDAO contactDao = new ContactDAO();

    @HttpGet
    global static List<Contact> getRecords() {
        return contactDao.getContactsWithLimit(NUMBER_OF_RECORDS_TO_QUERY);
    }
}