public class Utils {

    public static String getObjectType(Object obj){
		String result = 'DateTime';
        
		try {
			DateTime typeCheck = (DateTime)obj;
		} catch(System.TypeException ex){
			String message = ex.getMessage().substringAfter('Invalid conversion from runtime type ');
			result = message.substringBefore(' to Datetime');
		}

		return result;
	}
}