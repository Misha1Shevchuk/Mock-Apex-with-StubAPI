@IsTest
public class StubMockProvider implements System.StubProvider {

    List<MockedMethod> mockedMethods = new List<MockedMethod>();

    public Object createStub(Type typeToMock) {
        return Test.createStub(typeToMock, this);
    }

    public void mockMethod(MockedMethod mockedMethod) {
        this.mockedMethods.add(mockedMethod);
    }

    public void mockMethods(List<MockedMethod> mockedMethods) {
        this.mockedMethods.addAll(mockedMethods);
    }

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType,
        List<System.Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs
    ) {

        for (MockedMethod mockedMethod : mockedMethods) {
            if (mockedMethod.methodName.toLowerCase() != stubbedMethodName.toLowerCase()
                || mockedMethod.paramsByNames.size() != listOfParamNames.size()
            ) {
                continue;
            }

            Boolean paramsMatch = true;

            for (Integer i = 0; i < listOfParamNames.size(); i++) {
                Type stubbedParamType = listOfParamTypes[i];
                String stubbedParamName = listOfParamNames[i];
                Object stubbedArg = listOfArgs[i];

                StubMockProvider.Param param;

                if (mockedMethod.paramsByNames.containsKey(stubbedParamName.toLowerCase())) {
                    param = mockedMethod.paramsByNames.get(stubbedParamName.toLowerCase());
                }
                if (stubbedParamType != param.type || stubbedParamName != param.name || stubbedArg != param.value) {
                    paramsMatch = false;
                    break;
                }
            }

            if (paramsMatch) {
                return mockedMethod.handleCall();
            }
        }

        String errorMessage = 'Method {0} is not mocked. Verify method name and parameters';
        throw new StubMockProviderException(String.format(errorMessage, new List<String>{ stubbedMethodName }));
    }

    public class MockedMethod {

        String methodName;
        Object valueToReturn;
        Boolean doThrowException = false;
        String errorMessage = '';

        Map<String, StubMockProvider.Param> paramsByNames = new Map<String, StubMockProvider.Param>();

        public MockedMethod(String methodName) {
            this.methodName = methodName;
        }

        public MockedMethod withParams(List<Param> params) {
            for (Param param : params) {
                this.withParam(param);
            }

            return this;
        }

        public MockedMethod withParam(Param param) {
            this.paramsByNames.put(param.name.toLowerCase(), param);

            return this;
        }

        public MockedMethod returning(Object returnValue) {
            this.valueToReturn = returnValue;

            return this;
        }

        public MockedMethod throwing(String errorMessage) {
            this.doThrowException = true;
            this.errorMessage = errorMessage;

            return this;
        }

        public Object handleCall() {
            if (doThrowException) {
                throw new MockedException(errorMessage);
            }

            return valueToReturn;
        }
    }

    public class Param {

        public Type type { public get; private set; }
        public String name { public get; private set; }
        public Object value { public get; private set; }

        public Param(Type type, String name, Object value) {
            this.type = type;
            this.name = name;
            this.value = value;
        }
    }

    public class MockedException extends Exception {
    }

    public class StubMockProviderException extends Exception {
    }
}