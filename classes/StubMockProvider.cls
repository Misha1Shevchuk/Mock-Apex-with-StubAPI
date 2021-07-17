@IsTest
public class StubMockProvider implements System.StubProvider {

    List<MockedMethod> mockedMethods = new List<MockedMethod>();

    public Object createStub(Type typeToMock) {
        return Test.createStub(typeToMock, this);
    }

    public void mockMethod(MockedMethod mockedMethod) {
        mockedMethods.add(mockedMethod);
    }

    public void mockMethods(List<MockedMethod> mockedMethods) {
        mockedMethods.addAll(mockedMethods);
    }

    public Object handleMethodCall( 
        Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, 
        List<String> listOfParamNames, List<Object> listOfArgs
    ) {
        for (MockedMethod mockedMethod : mockedMethods) {
            if (mockedMethod.methodName.toLowerCase() != stubbedMethodName.toLowerCase()
                || mockedMethod.params.size() != listOfParamNames.size()
            ) {
                continue;
            }

            Boolean paramsMatch = true;

            for (Integer i = 0; i < listOfParamNames.size(); i++) {
                Type stubbedParamType = listOfParamTypes[i];
                Object stubbedParamValue = listOfArgs[i];

                Param methodParam = mockedMethod.params[i];

                if (methodParam.type != stubbedParamType && methodParam.value != stubbedParamValue) {
                    paramsMatch = false;
                    break;
                }
            }

            if (paramsMatch) {
                return mockedMethod.handleCall();
            }
        }

        String errorMessage = 'Method {0} is not mocked correctly. Verify method name and parameters';
        throw new StubMockProviderException(String.format(errorMessage, new List<String>{ stubbedMethodName }));
    }

    public class MockedMethod {

        Integer calledNTimes = 0;
        String methodName;
        Object valueToReturn;
        Exception exceptionInstance;

        List<Param> params = new List<Param>();

        public MockedMethod(String methodName) {
            this.methodName = methodName;
        }

        public MockedMethod withParam(Type type, Object value) {
            params.add(new Param(type, value));

            return this;
        }

        public MockedMethod withParam(Object paramValue) {
            Type paramType = Type.forName(Utils.getObjectType(paramValue));
            
            withParam(paramType, paramValue);

            return this;
        }

        public MockedMethod withParams(List<Object> params) {
            for (Object param : params) {
                withParam(param);
            }

            return this;
        }

        public MockedMethod withParams(Object p1, Object p2) {
            withParams(new List<Object>{p1, p2});

            return this;
        }

        public MockedMethod withParams(Object p1, Object p2, Object p3) {
            withParams(new List<Object>{p1, p2, p3});

            return this;
        }

        public MockedMethod withParams(Object p1, Object p2, Object p3, Object p4) {
            withParams(new List<Object>{p1, p2, p3, p4});

            return this;
        }

        public MockedMethod withParams(Object p1, Object p2, Object p3, Object p4, Object p5) {
            withParams(new List<Object>{p1, p2, p3, p4, p5});

            return this;
        }

        public MockedMethod withParams(Object p1, Object p2, Object p3, Object p4, Object p5, Object p6) {
            withParams(new List<Object>{p1, p2, p3, p4, p5, p6});

            return this;
        }

        public MockedMethod returning(Object valueToReturn) {
            this.valueToReturn = valueToReturn;

            return this;
        }

        public MockedMethod throwing(Exception exceptionInstance) {
            this.exceptionInstance = exceptionInstance;

            return this;
        }

        public Object handleCall() {
            calledNTimes++;

            if (exceptionInstance != null) {
                throw exceptionInstance;
            }

            return valueToReturn;
        }

        public Integer getCalledNTimes() {
            return calledNTimes;
        }
    }

    public class Param {

        public Type type { public get; private set; }
        public Object value { public get; private set; }

        public Param(Type type, Object value) {
            this.type = type;
            this.value = value;
        }
    }

    public class StubMockProviderException extends Exception {
    }
}