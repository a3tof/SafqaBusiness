import 'dart:convert';
import 'dart:io';

void main() async {
  final categoryNames = {
    1: 'Electronics',
    2: 'Vehicles',
    3: 'Real Estate',
    4: 'Sports',
    5: 'Books & Media',
    6: 'Toys & Hobbies',
  };

  final client = HttpClient();

  for (int i = 1; i <= 6; i++) {
    try {
      final request = await client.getUrl(
        Uri.parse('https://e-safqa.runasp.net/api/Auction/Get-Attributes/$i'),
      );
      request.headers.add('x-api-key', 'abc123xyhgfhjgkiho3544351z');
      request.headers.add('Accept-Language', 'en');

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      print('--- ${categoryNames[i]} ---');
      if (response.statusCode == 200) {
        final List data = jsonDecode(body);
        final requiredAttrs = [];
        final optionalAttrs = [];

        for (var attr in data) {
          if (attr['isRequired'] == true) {
            requiredAttrs.add(attr['name']);
          } else {
            optionalAttrs.add(attr['name']);
          }
        }

        print(
          'Required: ${requiredAttrs.isEmpty ? "None" : requiredAttrs.join(', ')}',
        );
        print(
          'Not Required: ${optionalAttrs.isEmpty ? "None" : optionalAttrs.join(', ')}',
        );
      } else {
        print('Failed to load: ${response.statusCode} - $body');
      }
      print('');
    } catch (e) {
      print('Error fetching category $i: $e');
    }
  }
  client.close();
}
