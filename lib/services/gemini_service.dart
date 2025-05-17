import 'dart:async';
import 'dart:convert';
import 'query_handler.dart';
import 'prompt_response_service.dart';
import 'package:http/http.dart' as http;
import 'api_keys.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class GeminiServiceHttpStream {
  // Stream controller for chat messages
  final StreamController<String> _responseStreamController =
      StreamController<String>.broadcast();
  Stream<String> get responseStream => _responseStreamController.stream;

  // Stream controller for completion events
  final StreamController<bool> _responseCompleteController =
      StreamController<bool>.broadcast();
  Stream<bool> get responseCompleteStream => _responseCompleteController.stream;

  // Flag to control streaming
  bool _isCancelled = false;

  // A method to get the response stream (used by ai_page.dart and ai_travel_chat.dart)
  Stream<String> getResponseStream(String prompt,
      {List<Map<String, Object>>? history,
      Map<String, dynamic>? generationConfig}) {
    // Reset cancellation flag
    _isCancelled = false;

    // In real implementation, this would call the Gemini API with history and generation config
    // Here we just call the existing demo implementation
    sendMessage(prompt, generationConfig: generationConfig);

    // Return the stream
    return responseStream;
  }

  // Method to stop an ongoing response
  void stopResponse() {
    _isCancelled = true;
  }

  // A simplified response generator for demo purposes
  Future<void> sendMessage(String message,
      {Map<String, dynamic>? generationConfig}) async {
    // In real implementation, this would call the Gemini API
    // For now, generate sample responses based on keywords in the message

    // Add a slight delay to simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));

    // Handle family activities in Paris with special combined response
    if ((message.toLowerCase().contains('family') ||
            message.toLowerCase().contains('kid')) &&
        (message.toLowerCase().contains('paris') ||
            message.toLowerCase().contains('france')) &&
        (message.toLowerCase().contains('activit') ||
            message.toLowerCase().contains('things to do'))) {
      _startStreamingResponse(
          PromptResponseService.getParisWithFamilyResponse());
    }
    // Use structured JSON when requested
    else if (generationConfig != null &&
        generationConfig['response_mime_type'] == 'application/json') {
      _startStreamingResponse(
          _generateStructuredResponse(message, generationConfig));
    }
    // Use Markdown for all other responses
    else {
      _startStreamingResponse(_generateDemoResponse(message));
    }
  }

  // Stream the response to simulate a real-time API response
  void _startStreamingResponse(String response) async {
    // For JSON responses, send the entire string at once to prevent malformed JSON
    if (response.trim().startsWith('{') && response.trim().endsWith('}')) {
      _responseStreamController.add(response);
      _responseCompleteController.add(true);
      return;
    }

    // For non-JSON responses, stream word by word
    final words = response.split(' ');
    for (var word in words) {
      if (_isCancelled) {
        _responseCompleteController.add(true);
        return;
      }

      _responseStreamController.add('$word ');
      await Future.delayed(Duration(
          milliseconds: 12 + (30 * DateTime.now().millisecond % 3).round()));
    }

    _responseCompleteController.add(true);
  }

  // Generate structured JSON responses based on the schema
  String _generateStructuredResponse(
      String message, Map<String, dynamic> config) {
    // Detect intent from the query
    final intent = QueryHandler.detectIntent(message);

    // Get structured response from our service
    final responseData =
        PromptResponseService.getStructuredResponse(message, intent);

    // Convert Map to JSON string
    return jsonEncode(responseData);
  }

  // Generate demo responses based on keywords in the user's message with Markdown formatting
  String _generateDemoResponse(String message) {
    // Get Markdown response from our service
    return PromptResponseService.getMarkdownResponse(message);
  }

  // Close the stream controllers when done
  void dispose() {
    _responseStreamController.close();
    _responseCompleteController.close();
  }
}

class GeminiService {
  final String _apiKey; // Store API key securely in a real app
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  final String _model = 'gemini-2.0-flash';

  GeminiService(this._apiKey);

  // Method to generate content with Gemini API via REST
  Future<Map<String, dynamic>> generateContent({
    required String prompt,
    Map<String, Object>? structuredOutputConfig,
    double temperature = 1.0,
    int maxOutputTokens = 800,
  }) async {
    final Uri uri = Uri.parse('$_baseUrl/$_model:streamGenerateContent?alt=sse&key=$_apiKey');

    // Build the request body
    final Map<String, dynamic> requestBody = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': temperature,
      }
    };

    // Add structured output configuration if provided
    if (structuredOutputConfig != null) {
      requestBody['generationConfig']['structuredOutputSchema'] =
          structuredOutputConfig['response_schema'];

      // Add other generation config parameters if they exist
      if (structuredOutputConfig.containsKey('temperature')) {
        requestBody['generationConfig']['temperature'] =
            structuredOutputConfig['temperature'];
      }

      if (structuredOutputConfig.containsKey('maxOutputTokens')) {
        requestBody['generationConfig']['maxOutputTokens'] =
            structuredOutputConfig['maxOutputTokens'];
      }

      if (structuredOutputConfig.containsKey('topK')) {
        requestBody['generationConfig']['topK'] =
            structuredOutputConfig['topK'];
      }

      if (structuredOutputConfig.containsKey('topP')) {
        requestBody['generationConfig']['topP'] =
            structuredOutputConfig['topP'];
      }
    }

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print('Error from Gemini API: ${response.body}');
        throw Exception('Failed to generate content: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when calling Gemini API: $e');
      throw Exception('Failed to connect to Gemini API: $e');
    }
  }
  // Streaming text generation using Gemini API (see docs)
  Stream<String> streamContent({
    required String prompt,
    Map<String, Object>? structuredOutputConfig,
    double temperature = 1.0,
    int maxOutputTokens = 800,
  }) async* {
    try {
      print('Starting stream request for prompt: '
          '${prompt.length > 50 ? prompt.substring(0, 50) + "..." : prompt}');
      final Uri uri = Uri.parse('$_baseUrl/$_model:streamGenerateContent?alt=sse&key=$_apiKey');
      
      // Build the request body with proper configuration
      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': temperature,
          'maxOutputTokens': maxOutputTokens,
          'topK': 40,
          'topP': 0.95,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };
      
      // Add structured output configuration if provided
      if (structuredOutputConfig != null) {
        requestBody['generationConfig']['structuredOutputSchema'] = structuredOutputConfig['response_schema'];
      }
      
      print('Sending streaming request to Gemini API');
      final request = http.Request('POST', uri)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode(requestBody);
      
      final response = await request.send();
      print('Stream response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        // Process SSE (Server-Sent Events) format
        await for (final line in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
          if (line.trim().isEmpty) continue;
          
          // Handle data events from SSE format
          if (line.startsWith('data: ')) {
            final dataString = line.substring(6).trim();
            
            // Handle special "[DONE]" message that indicates the end of the stream
            if (dataString == '[DONE]') {
              print('Stream completed with [DONE] marker');
              break;
            }
            
            if (dataString.isEmpty) continue;
            
            try {
              final Map<String, dynamic> data = jsonDecode(dataString);
              
              // Check for errors or blockReasons in the response
              if (data.containsKey('promptFeedback') && 
                  data['promptFeedback'].containsKey('blockReason')) {
                final blockReason = data['promptFeedback']['blockReason'];
                yield 'Sorry, I cannot respond to that request due to safety concerns. (Reason: $blockReason)';
                break;
              }
              
              // Extract text from the SSE chunk
              if (data.containsKey('candidates')) {
                final candidates = data['candidates'];
                if (candidates is List && candidates.isNotEmpty) {
                  final candidate = candidates[0];
                  
                  // Check for finish reason
                  if (candidate.containsKey('finishReason') && 
                      candidate['finishReason'] != null && 
                      candidate['finishReason'] != 'STOP') {
                    print('Stream finished with reason: ${candidate['finishReason']}');
                    yield '\n\n[Generated response was cut off due to: ${candidate['finishReason']}]';
                    break;
                  }
                  
                  // Process content if available
                  if (candidate is Map && candidate.containsKey('content')) {
                    final content = candidate['content'];
                    if (content is Map && content.containsKey('parts')) {
                      final parts = content['parts'];
                      if (parts is List && parts.isNotEmpty) {
                        for (var part in parts) {
                          if (part is Map) {
                            // Handle text content
                            if (part.containsKey('text')) {
                              final text = part['text'];
                              if (text is String && text.isNotEmpty) {
                                yield text;
                              }
                            } 
                            // Handle inline data (like images) if needed
                            else if (part.containsKey('inlineData')) {
                              // We could extract and yield image data here if needed
                              yield '[Image data available but not displayed]';
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            } catch (e) {
              print('Error parsing SSE data chunk: $e');
              // Just log and continue - don't yield error messages that would appear in the chat
            }
          }
        }
      } else {
        // Handle API errors with meaningful messages
        String errorMessage;
        try {
          final errorBody = await response.stream.transform(utf8.decoder).join();
          print('Error response from Gemini API: $errorBody');
          
          // Try to parse the error JSON if available
          final Map<String, dynamic> errorData = jsonDecode(errorBody);
          if (errorData.containsKey('error') && errorData['error'].containsKey('message')) {
            errorMessage = errorData['error']['message'];
          } else {
            errorMessage = 'API Error: ${response.statusCode}';
          }
        } catch (e) {
          errorMessage = 'API Error: ${response.statusCode}. Could not parse error details.';
        }
        
        yield 'I apologize, but I encountered an error while processing your request. Please try again later.\n\n[$errorMessage]';
      }
    } catch (e) {
      print('Exception in streamContent: $e');
      yield 'I apologize, but I encountered a technical issue while processing your request. Please try again later.';
    }
  }
  // Parse a streamed chunk for text, markdown, images, etc.
  String? _parseGeminiStreamChunk(Map<String, dynamic> data) {
    try {
      // Only print condensed chunk info to avoid log spam
      print('Parsing chunk of size: ${jsonEncode(data).length} bytes');
      
      // Handle candidates content
      if (data.containsKey('candidates')) {
        if (data['candidates'].isEmpty) {
          print('Info: Empty candidates array in response');
          return null;
        }
        
        final candidate = data['candidates'][0];
        
        // Check for finish reason other than STOP
        if (candidate.containsKey('finishReason') && 
            candidate['finishReason'] != null && 
            candidate['finishReason'] != 'STOP') {
          print('Generation stopped: ${candidate['finishReason']}');
          return '\n\n[Response was cut off due to: ${candidate['finishReason']}]';
        }
        
        // No content available
        if (!candidate.containsKey('content')) {
          print('Info: No content in candidate');
          return null;
        }
        
        final content = candidate['content'];
        if (content == null ||
            !content.containsKey('parts') ||
            content['parts'] == null ||
            content['parts'].isEmpty) {
          print('Info: Invalid content structure in response');
          return null;
        }
        
        // Extract text from all parts
        StringBuffer textBuffer = StringBuffer();
        for (var part in content['parts']) {
          if (part.containsKey('text')) {
            final text = part['text'];
            if (text is String && text.isNotEmpty) {
              textBuffer.write(text);
            }
          } else if (part.containsKey('inlineData')) {
            print('Found inline data in response (possibly an image)');
            
            // For images, we'll just add a placeholder that the UI can replace
            if (part['inlineData'].containsKey('mimeType') && 
                part['inlineData']['mimeType'].toString().startsWith('image/')) {
              textBuffer.write('[IMAGE]');
            }
          }
        }
        
        if (textBuffer.isNotEmpty) {
          print('Successfully parsed text chunk: ${textBuffer.length} characters');
          return textBuffer.toString();
        }
      } 
      // Handle safety feedback
      else if (data.containsKey('promptFeedback')) {
        print('Received prompt feedback from Gemini');
        if (data['promptFeedback'].containsKey('blockReason')) {
          return 'I apologize, but I cannot provide a response to that query due to content safety policies. [Reason: ${data['promptFeedback']['blockReason']}]';
        }
        
        // Check safety ratings
        if (data['promptFeedback'].containsKey('safetyRatings')) {
          final safetyRatings = data['promptFeedback']['safetyRatings'];
          for (var rating in safetyRatings) {
            if (rating.containsKey('probability') && 
                rating['probability'] != 'NEGLIGIBLE' &&
                rating['probability'] != 'LOW') {
              print('Safety concern detected: ${rating['category']} - ${rating['probability']}');
            }
          }
        }
      } 
      // Handle unrecognized format
      else {
        // Just log this, don't emit to the user
        print('Info: Skipping unrecognized response chunk format');
      }
      
      // Return null to skip this chunk
      return null;
    } catch (e) {
      print('Error parsing Gemini chunk: $e');
      // Skip this chunk instead of returning an error string to the user
      return null;
    }
  }

  // Method to parse the Gemini response into a simpler format
  Map<String, dynamic>? parseGeminiResponse(Map<String, dynamic> response) {
    try {
      // First check if there's any content
      if (!response.containsKey('candidates') ||
          response['candidates'].isEmpty ||
          !response['candidates'][0].containsKey('content')) {
        return null;
      }

      final content = response['candidates'][0]['content'];

      // Check if this is a structured output response (JSON format)
      if (content.containsKey('parts') &&
          content['parts'].isNotEmpty &&
          content['parts'][0].containsKey('text')) {
        final String textContent = content['parts'][0]['text'];

        // Try to extract JSON from the response
        try {
          // Look for JSON pattern in the text (in case there's text before or after the JSON)
          final RegExp jsonRegex = RegExp(r'(\{.*\})', dotAll: true);
          final match = jsonRegex.firstMatch(textContent);

          if (match != null) {
            final jsonString = match.group(1);
            return jsonDecode(jsonString!);
          }

          // If no match with regex, try parsing the full text as JSON
          return jsonDecode(textContent);
        } catch (e) {
          // If not valid JSON, return the text as is
          return {'text': textContent};
        }
      }

      return null;
    } catch (e) {
      print('Error parsing Gemini response: $e');
      return null;
    }  }
    // Helper method to handle search grounding via REST API
  Future<Map<String, dynamic>> performSearchGrounding(String query) async {
    try {
      // Import API keys directly from the api_keys.dart file
      final String customSearchApiKey = ApiKeys.searchApiKey;
      final String searchEngineId = ApiKeys.searchEngineId;
      
      // Check if search engine ID is provided and API key is valid
      if (searchEngineId.isEmpty) {
        print('Warning: Search engine ID not configured in api_keys.dart - will return empty results');
        return {'searchQuery': query, 'results': []};
      }
      
      if (customSearchApiKey.isEmpty || customSearchApiKey.contains('Replace with your key')) {
        print('Warning: Valid search API key not provided in api_keys.dart - will return empty results');
        return {'searchQuery': query, 'results': []};
      }

      final Uri searchUri = Uri.parse(
          'https://customsearch.googleapis.com/customsearch/v1?key=$customSearchApiKey&cx=$searchEngineId&q=${Uri.encodeComponent(query)}');
      
      print('Sending search request to: $searchUri');
      final response = await http.get(searchUri);
      
      if (response.statusCode == 200) {
        print('Search request successful, parsing results');
        final rawData = jsonDecode(response.body);

        // Extract and structure the most relevant information from the search results
        final List<dynamic> items = rawData['items'] ?? [];
        final results = items
            .map((item) => {
                  'title': item['title'],
                  'snippet': item['snippet'],
                  'link': item['link'],
                  'source': item['displayLink'] ?? '',
                  // Handle potential nulls in the image path
                  'image': item['pagemap']?['cse_image'] != null && 
                          item['pagemap']['cse_image'].isNotEmpty ? 
                          item['pagemap']['cse_image'][0]['src'] : null,
                })
            .toList();

        return {
          'searchQuery': query, 
          'results': results,
          'totalResults': rawData['searchInformation']?['totalResults'] ?? '0',
          'searchTime': rawData['searchInformation']?['searchTime'] ?? 0.0,
        };
      } else {
        print('Search API error: ${response.statusCode} - ${response.body}');
        // Rather than throwing an exception, return an error in the results
        return {
          'searchQuery': query, 
          'error': 'API error: ${response.statusCode}', 
          'results': []
        };
      }
    } catch (e) {
      print('Search grounding error: $e');
      return {'searchQuery': query, 'error': e.toString(), 'results': []};
    }
  }

}
