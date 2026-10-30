# Pixso 参考读取记录

来源：已连接 Pixso 当前打开的 **Marnie** 文件。

读取了文件全部页面分类：

- `Marnie`（`0:1`）：18 个顶层业务画板，逐页读取 Flutter 导出结构并获取截图。
- `Symbols`（`0:1891`）：组件分类，无独立顶层业务画板；通过组件实例随业务画板读取。

| 序号 | 原稿画板 | Pixso 节点 | 对应路由 | 原稿截图 |
| --- | --- | --- | --- | --- |
| 01 | Splash | `0:1831` | `/` | [查看](screenshots/01_splash.png) |
| 02 | Login | `0:1780` | `/login` | [查看](screenshots/02_login.png) |
| 03 | Sign up | `0:1720` | `/signup` | [查看](screenshots/03_sign_up.png) |
| 04 | Choose a Country | `0:1621` | `/country` | [查看](screenshots/04_country.png) |
| 05 | Rate us | `0:1569` | `/rate` | [查看](screenshots/05_rate_us.png) |
| 06 | Home | `0:1365` | `/home` | [查看](screenshots/06_home.png) |
| 07 | Sidelist | `0:1225` | `/menu` | [查看](screenshots/07_menu.png) |
| 08 | Category | `0:1095` | `/category` | [查看](screenshots/08_category.png) |
| 09 | Filters | `0:982` | `/filters` | [查看](screenshots/09_filters.png) |
| 10 | Product | `0:832` | `/product` | [查看](screenshots/10_product.png) |
| 11 | Reviews | `0:755` | `/reviews` | [查看](screenshots/11_reviews.png) |
| 12 | Bag (Empty) | `0:718` | `/bag-empty` | [查看](screenshots/12_bag_empty.png) |
| 13 | Bag | `0:657` | `/bag` | [查看](screenshots/13_bag.png) |
| 14 | Search | `0:580` | `/search` | [查看](screenshots/14_search.png) |
| 15 | Saved | `0:354` | `/saved` | [查看](screenshots/15_saved.png) |
| 16 | Account | `0:144` | `/account` | [查看](screenshots/16_account.png) |
| 17 | Map | `0:62` | `/map` | [查看](screenshots/17_map.png) |
| 18 | Settings | `0:2` | `/settings` | [查看](screenshots/18_settings.png) |

设计基准宽度为 375；首页、筛选、商品详情等原稿为长画板，Flutter 中使用自然滚动布局。沿用背景 `#F2F2F2`、正文 `#222222`、占位图区 `#E7E7E7` 以及玫红促销卡片。字体文件本地打包，无网络字体依赖。

原稿提供灰色商品与人物图像占位，未提供可用实拍商品图片。实现保留这些占位，未自行替换为不相关图片。基础图标由 Flutter 自带图标实现，细节与原稿自定义矢量图标可能存在差异。Android 系统状态栏和手势栏使用系统绘制。

为完成交互，增加了原稿未展开的资料编辑页、空结果状态、购物袋编辑、演示结算确认和商品码查询。原稿中的错误金额、重复设置项和明显拼写错误已按主文档说明修正。
