@IsTest
private class ContactsRestServiceTest {

    @IsTest
    static void getRecordsSuccess() {
        List<Contact> contacts = new List<Contact>{
                new Contact(FirstName = 'John', LastName = 'Nilson'),
                new Contact(FirstName = 'Bob', LastName = 'Martin')
        };

        StubMockProvider stubProvider = new StubMockProvider();

        ContactsRestService.contactDao = (ContactDAO) stubProvider.createStub(ContactDAO.class);

        StubMockProvider.MockedMethod getContactsWithLimitMock = new StubMockProvider.MockedMethod('getContactsWithLimit')
                .withParam(new StubMockProvider.Param(Integer.class, 'maxRecords', 2))
                .returning(contacts);

        stubProvider.mockMethod(getContactsWithLimitMock);

        Test.startTest();
            List<Contact> result = ContactsRestService.getRecords();
        Test.stopTest();

        System.assert(!result.isEmpty());
        System.assertEquals(contacts[0], result[0]);
        System.assertEquals(contacts[1], result[1]);
    }

    @IsTest
    static void getRecordsShouldBeError() {
        ContactsRestService.NUMBER_OF_RECORDS_TO_QUERY = null;

        StubMockProvider stubProvider = new StubMockProvider();
        ContactsRestService.contactDao = (ContactDAO) stubProvider.createStub(ContactDAO.class);

        String errorMessage = 'Custom Error message';

        StubMockProvider.MockedMethod getContactsWithLimitMock = new StubMockProvider.MockedMethod('getContactsWithLimit')
                .withParam(new StubMockProvider.Param(Integer.class, 'maxRecords', null))
                .throwing(errorMessage);

        stubProvider.mockMethod(getContactsWithLimitMock);

        String result;

        Test.startTest();
            try {
                ContactsRestService.getRecords();
            } catch (StubMockProvider.MockedException error) {
                result = error.getMessage();
            }
        Test.stopTest();

        System.assert(!String.isBlank(result));
        System.assertEquals(errorMessage, result);
    }
}