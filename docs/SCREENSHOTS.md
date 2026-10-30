# 界面截图

下表链接均为 Flutter 在 Android 模拟器中的实际运行截图。原始 Pixso 图见 [参考目录](../design_reference/README.md)。

## 18 个参考界面

| 启动 | 登录 | 注册 |
| --- | --- | --- |
| ![启动](screenshots/01_splash.png) | ![登录](screenshots/02_login.png) | ![注册](screenshots/03_sign_up.png) |

| 选择国家 | 评分 | 首页 |
| --- | --- | --- |
| ![选择国家](screenshots/04_country.png) | ![评分](screenshots/05_rate_us.png) | ![首页](screenshots/06_home.png) |

| 菜单 | 分类 | 筛选 |
| --- | --- | --- |
| ![菜单](screenshots/07_menu.png) | ![分类](screenshots/08_category.png) | ![筛选](screenshots/09_filters.png) |

| 商品详情 | 评价 | 空购物袋 |
| --- | --- | --- |
| ![商品详情](screenshots/10_product.png) | ![评价](screenshots/11_reviews.png) | ![空购物袋](screenshots/12_bag_empty.png) |

| 购物袋 | 搜索 | 收藏 |
| --- | --- | --- |
| ![购物袋](screenshots/13_bag.png) | ![搜索](screenshots/14_search.png) | ![收藏](screenshots/15_saved.png) |

| 账户 | 门店 | 设置 |
| --- | --- | --- |
| ![账户](screenshots/16_account.png) | ![门店](screenshots/17_map.png) | ![设置](screenshots/18_settings.png) |

## 长页面和补充状态

| 首页分类区 | 首页订阅与促销 | 尺码与价格 |
| --- | --- | --- |
| ![首页分类区](screenshots/06b_home_collections.png) | ![首页订阅与促销](screenshots/06c_home_newsletter.png) | ![尺码与价格](screenshots/09b_filters_sizes_price.png) |

| 商品规格与购买 | 购物袋结算 | 个人资料 |
| --- | --- | --- |
| ![商品规格与购买](screenshots/10b_product_options.png) | ![购物袋结算](screenshots/13b_bag_checkout.png) | ![个人资料](screenshots/19_settings_profile.png) |

| 深色模式 |
| --- |
| ![深色模式](screenshots/20_settings_dark.png) |

| 商品码查询（补充入口） |
| --- |
| ![商品码查询](screenshots/21_scan.png) |

## 重新生成

启动 Android 模拟器后，在项目根目录执行：

```bash
flutter drive --driver=test_driver/screenshots.dart --target=integration_test/app_test.dart -d emulator-5554
```

截图由自动化逐页导航、滚动后采集，覆盖 18 个原稿界面及 8 个长页/补充状态。正常应用首次启动购物袋为空；非空购物袋截图使用测试数据。更新界面后执行同一命令可覆盖生成新截图。
