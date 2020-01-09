import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/model/order_model.dart';
import 'package:intl/intl.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Future<Response> user;
  Future<OrderModel> orders;

  Future<Response> fetchUserData() async {
    try {
      var response = await Dio().get('$BASE_URL/api/user/info/$userId');
      if (response.data['status'] == 1) {
        return response;
      } else {
        throw Exception(response.data['message']);
      }
    } on DioError catch (ex) {
      print('Dio error: ' + ex.message);
      throw Exception(ex.toString());
    }
  }

  Future<OrderModel> fetchUserOrderHistory() async {
    try {
      var response = await Dio().get('$BASE_URL/api/order/user', queryParameters: {"token": token});
      if (response.data['status'] == 1) {
        return OrderModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (ex) {
      print(ex.toString());
      return null;
    }
  }

  @override
  void initState() {
    user = fetchUserData();
    orders = fetchUserOrderHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('User Profile'),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(title: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder<Response>(
              future: user,
              builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
                if (snapshot.hasData) {
                  return buildProfile(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text('Error getting data');
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            Text('Order History', style: titleStyle),
            buildUserOrderHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget buildProfile(Response response) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('$BASE_URL/uploads/${response.data['user']['profile_img']}'),
              ),
            ),
          ),
          SizedBox(height: 32),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Name'),
              subtitle: Text(response.data['user']['name']),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(response.data['user']['email']),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.call),
              title: Text('Phone Number'),
              subtitle: Text(response.data['user']['phone_number']),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserOrderHistoryList() {
    return FutureBuilder<OrderModel>(
      future: orders,
      builder: (BuildContext context, AsyncSnapshot<OrderModel> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            primary: false,
            itemCount: snapshot.data.order.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              Order order = snapshot.data.order[index];
              return buildOrderItem(order);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildOrderItem(Order order) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text('Order Date: ' + DateFormat().format(order.orderDate.toLocal()), style: titleStyle2),
          ),
          ...order.items.map((item) {
            return ListTile(
              leading: Icon(Icons.fastfood),
              trailing: Text('Price: ${item.food.price} \$'),
              title: Text(item.food.name),
              subtitle: Text('Quantity: ${item.quantity}'),
            );
          }).toList()
        ],
      ),
    );
  }
}
