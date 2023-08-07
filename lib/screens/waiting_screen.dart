import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ordering_system_fe/models/item.dart';
import 'package:animated_loading_border/animated_loading_border.dart';

class WaitingScreen extends StatefulWidget {
  static const String screenName = 'waiting_screen';

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      fetchOrders(); // Gọi phương thức fetchOrders để làm mới giao diện sau mỗi 10 giây
    });
  }

  void fetchOrders() async {
    List<Item> orders = await getOrders();
    List<Item> filteredOrders = filterOrders(orders);
    updatePreparingOrders(filteredOrders);

    List<Item> readyOrders = filterReadyOrders(orders);
    updateReadyOrders(readyOrders);
  }

  List<Item> filterOrders(List<Item> orders) {
    return orders.where((item) => !item.isReady && !item.isDelivered).toList();
  }

  List<Item> filterReadyOrders(List<Item> orders) {
    return orders.where((item) => item.isReady && !item.isDelivered).toList();
  }

  void updatePreparingOrders(orders) {
    setState(() {
      if (orders == null) {
        print('There is no oder');
        return;
      }
      items = orders;
    });
  }

  void updateReadyOrders(orders) {
    setState(() {
      if (orders == null) {
        print('There is no oder');
        return;
      }
      readyItems = orders;
    });
  }

  Future<List<Item>> getOrders() async {
    return await Item.fetchItemsFromUrl();
  }

  List<Item> items = [];
  List<Item> readyItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Container(
          color: Color(0xffEAF8D7),
          alignment: Alignment.center,
          height: 50,
          child: Text(
            'When your order is ready, please proceed to the collection point',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xff241417),
            ),
          ),
        ),
        backgroundColor: Color(0xffEAF8D7),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'PREPARING',
                      style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        childAspectRatio: 16 / 9,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: [
                          for (int i = 0; i < items.length; i++)
                            AnimatedLoadingBorder(
                              cornerRadius: 8,
                              borderWidth: items[i].isPreparation ? 10 : 0,
                              borderColor: items[i].isPreparation ? Color(0xFF389B3A) : Color(0xffEAF8D7),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xFF241417),
                                ),
                                child: Center(
                                  child: Text(items[i].id,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                      )),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFF241417),
                child: SizedBox(
                  height: double.infinity,
                  width: 2,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'READY',
                      style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 16 / 9,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: [
                          for (int i = 0; i < readyItems.length; i++)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF389B3A),
                              ),
                              child: Center(
                                child: Text(readyItems[i].id,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 90,
                                    )),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
