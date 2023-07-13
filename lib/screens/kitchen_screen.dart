import 'package:flutter/material.dart';
import 'package:ordering_system_fe/components/header_widget.dart';
import 'package:ordering_system_fe/components/legend_item_widget.dart';
import 'package:ordering_system_fe/templates/base_widget.dart';
import 'package:ordering_system_fe/models/item.dart';
import 'package:intl/intl.dart';

class KitchenScreen extends StatefulWidget {
  static const String screenName = 'kitchen_screen';

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    List<Item> orders = await getOrders();
    List<Item> filteredOrders = filterOrders(orders);
    updateUI(filteredOrders);
  }

  List<Item> filterOrders(List<Item> orders) {
    return orders.where((item) => !item.isReady && !item.isDelivered).toList();
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

  List<Item> items = [];

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
                                      color: getStatus(item),
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
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat("HH:mm:ss").format(
                                                    DateTime.parse(item.timestamp),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Text(
                                              '#' + item.id,
                                              style: TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
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
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 20.0),
                                            child: IgnorePointer(
                                              child: ExpansionTile(
                                                initiallyExpanded: true,
                                                backgroundColor: Colors.black,
                                                iconColor: Colors.white,
                                                title: ListTile(
                                                  title: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${product['amount']}x',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.0),
                                                      Text(
                                                        '${product['title']}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  tileColor: Colors.black,
                                                ),
                                                children: product.containsKey('subProducts')
                                                    ? [
                                                        Container(
                                                          color: Color(0xFFEAF8D7),
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemCount: product['subProducts'].length,
                                                            itemBuilder: (context, index) {
                                                              final subProduct = product['subProducts'][index];
                                                              return Padding(
                                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      '${subProduct['amount']}x',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 22,
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 20.0),
                                                                    Text(
                                                                      '${subProduct['title']}',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 22,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ]
                                                    : [],
                                              ),
                                            ),
                                          );
                                        },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LegendItemWidget(color: Color(0xffF24E40), text: 'PRIORITY'),
              LegendItemWidget(color: Color(0xff389B3A), text: 'BUMP'),
              LegendItemWidget(color: Color(0xffD9D228), text: 'NEW'),
              LegendItemWidget(color: Color(0xff3E83A2), text: 'COOKING'),
            ],
          ),
        ],
      ),
    );
  }

  getStatus(Item item) {
    if (item.isPreparation) {
      return Color(0xff3E83A2); // is cooking
    } else {
      return Color(0xffD9D228); // NEW
    }
  }
}
