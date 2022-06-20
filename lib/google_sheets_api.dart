import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "nimble-ally-353016",
  "private_key_id": "38cde079473bc925594e615dec51d2ae6acf0e97",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDV1QxBlVPFLNxu\ntxTaRYthvP4QRWxiEEosnG2Pa6g14WUmowT20WBxi/z3P7+zV2LrsanTxLmOk8HY\npOeEEpDc/jm4U7xQn8u91/r2UV77c4yV9Zy91NHtrdJ7kh5gBf94T+1P1TdN7Wfy\npjJrIuf45DrOQcKkvRHDC5VDg5/OOA9vWlwKzYneSBYJOxyVLsSz8h6CCzM/ufmz\nYXemYXA6beMMwH3wWKXATgUq/WqqTnPbXP1NlzOStwvfsi5YdrTSFNbnqu6NiGms\nbA6UHlRNgLOWFLMss2Pb3LhcgAA6S0gvAkCzGO3Hf3VhOgqAprhgxCat+blhyQL+\nBZ0DQGI9AgMBAAECggEAMTqLR84JKyvY0+RyeI3qOOY516Uj/q+hZAPfdVVjtIPf\ntbVyPyCVA48m/gU/LRrBO2H7pzVzQs/hoO7WHiHoF/ivcTBV+nnPfjVrIao6I8nG\nY//Xxhxo+D88ZhaNx62Z0ykTiX2c7ePqOoLouKGgpjxlDXc2SJb+r9jK1HBJKkBy\nCQ/btw2xqbuk2gPxTeXLo5/PvTkdv6TI7uo0CcTOvZZzVWLDKBnUqTTtGA78mgUL\nYNv7JIGvdAlVdbsJrbbXATiYUYqn3r5afVZCs7t5k1cKBvjBNC8e/0WRSphSRYXn\ngWAmibL6AN/t8962jhHG5qIvgdlO9Ghx8oLdVdMyQQKBgQDwF6xFWXN3XypCKgRu\n2xl9hTJDRg3LXhnhIt96G18/7zUAQ9JdJpu4uWq77nvGvzFD4+RW59jUFooJSPUN\nXGb3mhB9m7Gey35vOAcW+xscAsjMMXsLc9E/jiOW1I0yw8fh7KpCRCvc8Yt0nnGS\nyXT33s34Ocm/Bb0BMC6y6qTnZwKBgQDj//Y4PQBWgrD9lTkziEhswfcuFY/QywzP\nvyXpHXRVt3PHtUfXTkS3xDbLDVYgGceU2td2VphMqAFpw8uG6QysQCsB+0uuEkop\nOKhKxUs0yGaBn7v+X9WZm48K/vZiieuyJfsD95ZnGWGyyIplCdpAxa0M/n1VnRM6\noLF0IQOWuwKBgBqLo4JvZ3LVVMjH+IGBPApCxdHmVvQbTWU1A9xuVlOtUQDcfs/J\nywHbjk+FCK5qyTmmYsKxE6ova8enB2EYzFGn+RbKNhNGkI4fdbk2vkKUlDrvZZlY\njtQmFQ1CJvJr7xetoQ1+mBLvqemU8x21pHcbbU56pTG3orQU7bTeeKkVAoGBAJLf\nztNHqLISGsYgnOqvfkhhY0QSq8SLKUOjFV7olIqrVTBvfUobp3TiN5Hyk2q2cLVZ\njLc07YNkLxTdBn1wH7PO2mW6ZnRKX+/SCcew9NOZzT7vkYE6ZzU+2pTwzfOIeYcX\npG5XzlG4LhGn0k9oW2qibOoT/tVqDHsWDXqL0e4FAoGAQmKk69DneDRY5R7rkELX\nvOclCKANi+BbfDTB9WYHRxMM6ZQChZk7ydFIv1EBckcrsn6HDyjyRZojNnLaBtQm\nPaAtRPHb+PRnKdhRAq6BI5mPyvotpXiMRBsBc2ttrx3OTqh4Ra2RixLTYz/2xagW\noBLTAIbL5oOK1w1FVKqTMg8=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets-note@nimble-ally-353016.iam.gserviceaccount.com",
  "client_id": "105852473260001116004",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets-note%40nimble-ally-353016.iam.gserviceaccount.com"
  }
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1YPzRaAZSTSGUvIXKrIEAbFNRVbzhZ75BV08qDKi_n9o';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfNotes = 0;
  static List<String> currentNotes = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }
    // now we know how many notes to load, now let's load them!
    loadNotes();
  }

  // insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add(note);
    await _worksheet!.values.appendRow([note]);
  }

  // load existing notes from the spreadsheet
  static Future loadNotes() async {
    if (_worksheet == null) return;

    for (int i = 0; i < numberOfNotes; i++) {
      final String newNote =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add(newNote);
      }
    }
    // this will stop the circular loading indicator
    loading = false;
  }
}
