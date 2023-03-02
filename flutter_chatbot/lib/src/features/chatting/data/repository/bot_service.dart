import 'package:flutter_chatbot/src/constants/constants.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class ChatService {
  Future<AIResponse> getResponse(query) async {
    AuthGoogle authGoogle = await AuthGoogle(fileJson: credentialPath).build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);

    return response;
  }
}
