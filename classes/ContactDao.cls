public inherited sharing class ContactDao {
    
    public List<Contact> getContactsWithLimit(Integer maxRecords) {
        return [SELECT FirstName, LastName, Phone FROM Contact LIMIT :maxRecords];
    }
}
