import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ordering_system_fe/components/header_widget.dart';
import 'package:ordering_system_fe/models/item.dart';
import 'package:ordering_system_fe/templates/base_widget.dart';

class ReadyScreen extends StatefulWidget {
  static const String screenName = 'ready_screen';

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  List<Item> items = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      fetchOrders(); // Gọi phương thức fetchOrders để làm mới giao diện sau mỗi 10 giây
    });
  }

  void fetchOrders() async {
    List<Item> orders = await getOrders();
    List<Item> filteredOrders = filterOrders(orders);
    List<Item> updatedOrders = updateOrders(filteredOrders);
    updateUI(updatedOrders);
  }

  void updateOrder(orderId, status) async {
    int responseStatus = await updateStatus(orderId, status);
    if (responseStatus == 200) {
      fetchOrders();
    } else {
      print('FAIL');
    }
  }

  List<Item> filterOrders(List<Item> orders) {
    return orders.where((item) => item.isReady && !item.isDelivered).toList();
  }

  void updateUI(orders) {
    setState(() {
      if (orders == null) {
        print('There is no oder');
        return;
      }
      items = orders;
    });
  }

  Future<List<Item>> getOrders() async {
    return await Item.fetchItemsFromUrl();
  }

  Future<int> updateStatus(orderId, status) async {
    return await Item.updateOrderStatus(orderId, status);
  }

  List<Item> updateOrders(List<Item> orders) {
    Map<String, int> productAmounts = {};

    for (var order in orders) {
      for (var product in order.products) {
        final title = product['title'];
        final amount = int.parse(product['amount']);

        if (product.containsKey('subProducts')) {
          for (var subProduct in product['subProducts']) {
            final subTitle = subProduct['title'];
            final subAmount = int.parse(subProduct['amount']);

            if (productAmounts.containsKey(subTitle)) {
              productAmounts[subTitle] = (productAmounts[subTitle] ?? 0) + subAmount;
            } else {
              productAmounts[subTitle] = subAmount;
            }
          }
        }

        if (!product.containsKey('subProducts')) {
          if (productAmounts.containsKey(title)) {
            productAmounts[title] = (productAmounts[title] ?? 0) + amount;
          } else {
            productAmounts[title] = amount;
          }
        }
      }
    }

    List<Item> updatedOrders = [];
    for (var order in orders) {
      List<Map<String, dynamic>> updatedProducts = [];
      for (var product in order.products) {
        final title = product['title'];

        if (!product.containsKey('subProducts') && productAmounts.containsKey(title)) {
          final updatedAmount = productAmounts[title];
          updatedProducts.add({
            'title': title,
            'amount': updatedAmount.toString(),
          });
          productAmounts.remove(title);
        }
      }

      updatedOrders.add(
        Item(
          id: order.id,
          timestamp: order.timestamp,
          isPreparation: order.isPreparation,
          isReady: order.isReady,
          isDelivered: order.isDelivered,
          products: updatedProducts,
        ),
      );
    }

    return updatedOrders;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderWidget(),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    FutureBuilder<List<Item>>(
                      future: Future.value(items),
                      // Đặt giá trị future cho FutureBuilder
                      builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Xử lý trạng thái đang chờ
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Xử lý khi có lỗi xảy ra
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Xử lý khi dữ liệu đã sẵn sàng
                          List<Widget> itemWidgets = snapshot.data!.map((item) {
                            return Container(
                              margin: EdgeInsets.only(right: 20),
                              width: MediaQuery.of(context).size.width / 5,
                              color: Color(0xffEAF8D7),
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  DateFormat("dd/MM/yyyy").format(
                                                    DateTime.parse(item.timestamp),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat("HH:mm:ss").format(
                                                    DateTime.parse(item.timestamp),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Text(
                                              '#' + item.id,
                                              style: TextStyle(
                                                fontSize: 40,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('ID: 1234-5678-9101'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: item.products.length,
                                        itemBuilder: (context, index) {
                                          final product = item.products[index];
                                          bool isLastRow = index == item.products.length - 1;
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 20.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 10.0),
                                                    Text(
                                                      '${product['amount']}x',
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                      ),
                                                    ),
                                                    SizedBox(width: 30.0),
                                                    Text(
                                                      '${product['title']}',
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (!isLastRow) Divider(color: Colors.black),
                                                // Thêm Divider nếu không phải dòng cuối cùng
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                                          backgroundColor: MaterialStateProperty.all(Color(0xff241417)),
                                        ),
                                        onPressed: () {
                                          // Xử lý sự kiện khi nút được nhấn
                                          updateOrder(item.id, 'delivered');
                                        },
                                        child: Text(
                                          'Delivery',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList();

                          return Wrap(
                            alignment: WrapAlignment.start,
                            children: itemWidgets,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
