public inherited sharing class ContactDAO {
    
    public List<Contact> getContactsWithLimit(Integer maxRecords) {
        return [SELECT FirstName, LastName, Phone FROM Contact LIMIT :maxRecords];
    }
}