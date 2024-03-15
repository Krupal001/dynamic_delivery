import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_delivery/src/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late DocumentSnapshot? mostRecentDocument;
  String merchantName = '';
  String merchantPhone = '';
  String firmName = '';
  String firmAddress = '';
  String parcelQTY = '';
  String description = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMostRecentDocument();
  }

  Future<void> fetchMostRecentDocument() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Parcels")
          .orderBy("Date Created", descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        mostRecentDocument = querySnapshot.docs[0];

        String? merchantId = mostRecentDocument?['Merchant_ID'];
        String? parcelId = mostRecentDocument?.id;
        print("-------$parcelId");
        print(mostRecentDocument?.data());

        CollectionReference merchants =
        FirebaseFirestore.instance.collection('Merchants');
        DocumentSnapshot merchantSnapshot =
        await merchants.doc(merchantId).get();
        CollectionReference subCollection =
        merchants.doc(merchantId).collection('Firm-Address');
        QuerySnapshot subCollectionSnapshot = await subCollection.get();

        DocumentSnapshot? subSnapshot =
        subCollectionSnapshot.docs.isNotEmpty
            ? subCollectionSnapshot.docs[0]
            : null;

        merchantName = merchantSnapshot['Name'] ?? '';
        merchantPhone = merchantSnapshot['Phone no'] ?? '';
        firmName = subSnapshot?['firm-name'] ?? '';
        firmAddress = subSnapshot?['address'] ?? '';
        parcelQTY = mostRecentDocument?['Items'] ?? '';
        description = mostRecentDocument?['Item Description'] ?? '';

        print('Merchant Name: $merchantName');
        print('Merchant Phone: $merchantPhone');
        print('Firm Name: $firmName');
        print('Firm Address: $firmAddress');
        print('Parcel QTY: $parcelQTY');
        print('Description: $description');
      } else {
        print('No documents found in the "Parcels" collection.');
      }
    } catch (e) {
      print("Error getting most recent document: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Details'),
        backgroundColor: tThemeMain,
        foregroundColor: Colors.white,

      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(
          color: tThemeMain,
        )
            : mostRecentDocument != null
            ? Container(
          height: 550,
          width: 350,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Merchant Name: $merchantName',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Merchant Phone: $merchantPhone',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Pickup: $firmName',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Pickup Address: $firmAddress',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Parcel QTY: $parcelQTY',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Item Description: $description',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 205,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: tThemeMain,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: tThemeMain),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50),
                  ),
                  child: const Text(
                    'ACCEPT',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
            : const Text('No most recent document found or an error occurred.'),
      ),
    );
  }
}
