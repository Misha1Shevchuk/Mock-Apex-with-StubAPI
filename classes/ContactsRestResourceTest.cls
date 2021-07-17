@IsTest
private class ContactsRestResourceTest {

    @IsTest
    static void getRecordsSuccess() {
        List<Contact> contacts = new List<Contact>{
                new Contact(FirstName = 'John', LastName = 'Nilson'),
                new Contact(FirstName = 'Bob', LastName = 'Martin')
        };

        StubMockProvider stubProvider = new StubMockProvider();

        ContactsRestResource.contactDao = (ContactDao) stubProvider.createStub(ContactDao.class);

        StubMockProvider.MockedMethod getContactsWithLimitMock = 
                new StubMockProvider.MockedMethod('getContactsWithLimit').withParam(2).returning(contacts);

        stubProvider.mockMethod(getContactsWithLimitMock);

        Test.startTest();
            List<Contact> result = ContactsRestResource.getRecords();
        Test.stopTest();

        System.assert(!result.isEmpty());
        System.assertEquals(contacts[0], result[0]);
        System.assertEquals(contacts[1], result[1]);
    }

    @IsTest
    static void getRecordsShouldBeError() {
        ContactsRestResource.numberOfRecordsToQuery = null;

        StubMockProvider stubProvider = new StubMockProvider();
        ContactsRestResource.contactDao = (ContactDao) stubProvider.createStub(ContactDao.class);

        String errorMessage = 'Custom Error message';

        StubMockProvider.MockedMethod getContactsWithLimitMock = 
                new StubMockProvider.MockedMethod('getContactsWithLimit')
                .withParam(Integer.class, null)
                .throwing(new CustomException(errorMessage));

        stubProvider.mockMethod(getContactsWithLimitMock);

        String result;

        Test.startTest();
            try {
                ContactsRestResource.getRecords();
            } catch (CustomException error) {
                result = error.getMessage();
            }
        Test.stopTest();

        System.assert(!String.isBlank(result));
        System.assertEquals(errorMessage, result);
    }

    class CustomException extends Exception {
    }
}