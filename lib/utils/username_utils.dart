abstract class UsernameUtils {

  static const String FAKE_EMAIL_ENDING = "@fake.com";
  
  static String convertEmailToUsername(String email) {
    return email.substring(0, email.length - FAKE_EMAIL_ENDING.length);
  }

  static String convertUsernameToEmail(String username) {
    return username + FAKE_EMAIL_ENDING;
  }
}