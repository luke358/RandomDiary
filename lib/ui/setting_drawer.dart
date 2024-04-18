import 'package:flutter/material.dart';

class SettingDrawer extends StatelessWidget {
  const SettingDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      width: MediaQuery.of(context).size.width * 0.80,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: MediaQuery.removePadding(
        context: context,
        // 移除顶部 padding.
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(), //构建抽屉菜单头部
            Expanded(child: _buildMenus()), //构建功能菜单
            _buildFooter()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black),
                borderRadius: BorderRadius.circular(50.0)),
            child: IconButton(
                icon: const Icon(Icons.edit),
                iconSize: 60,
                onPressed: () => {}),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            child: const Text('name'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: const ButtonStyle(),
            child: const Text('开通会员'),
          )
        ],
      ),
    );
  }

  // 构建菜单项
  Widget _buildMenus() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: ListView(
        children: [
          ListTile(
            title: Container(
              height: 80,
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  Text('搜索'),
                ],
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Container(
              height: 80,
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.calendar_month), Text('日历')],
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Container(
                height: 80,
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome_mosaic_outlined),
                    Text('分类')
                  ],
                )),
            onTap: () {},
          ),
          ListTile(
            title: Container(
                height: 80,
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none_outlined),
                    Text('消息')
                  ],
                )),
            onTap: () {},
          ),
          ListTile(
            title: Container(
                height: 80,
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.delete_outline_sharp), Text('垃圾箱')],
                )),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton(Function onTap, IconData icon, String text) {
    return InkWell(
        borderRadius: BorderRadius.circular(50.0),
        onTap: () {
          onTap();
        },
        child: Container(
          alignment: Alignment.center,
          width: 100,
          height: 100,
          color: Colors.transparent, // 设置按钮颜色

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(text)
            ],
          ),
        ));
  }

  Widget _buildFooter() {
    return Stack(
      children: [
        Positioned(
            child: Container(
          alignment: Alignment.center,
          height: 150,
          padding: const EdgeInsets.only(left: 40, right: 40, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFooterButton(() {}, Icons.home, '设置'),
              _buildFooterButton(() {}, Icons.light_mode_outlined, '夜间'),
            ],
          ),
        ))
      ],
    );
  }
}
