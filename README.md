# Catsxp Portable

<p align="center">
  <img src="https://img.bibica.net/DrNuwrhh.png" alt="Image">
</p>

[Catsxp](https://www.catsxp.com/?utm_source=chatgpt.com) mặc định đã hỗ trợ chế độ Portable. Tuy nhiên, cơ chế cập nhật của phiên bản này chưa thuận tiện, nên mình viết thêm `update.bat` để việc cập nhật trở nên đơn giản hơn

> [!IMPORTANT]
> URL download được lấy trực tiếp từ kết quả Omaha API trả về `https://www.catsxp.com/api/service/Update`, tương đương với hành động người dùng bấm kiểm tra cập nhật thủ công trong `catsxp://settings/help`
> 
> Hệ thống sẽ thực hiện bước kiểm tra SHA256 đối chiếu với phần phản hồi manifest của API nhằm đảm bảo file `.exe` tải về đạt tính toàn vẹn tuyệt đối, tránh file lỗi hoặc bị can thiệp giữa đường
>
> Catsxp Portable tại dự án này được đóng gói lại từ phiên bản cài đặt tiêu chuẩn chính thức của Catsxp

## Cài đặt

* Tải gói cài đặt tại: [https://github.com/bibicadotnet/catsxp-portable/releases/download/setup/Catsxp_Portable.zip](https://github.com/bibicadotnet/catsxp-portable/releases/download/setup/Catsxp_Portable.zip)
* Giải nén và chạy `update.bat`.

Sau khi hoàn tất, thư mục sẽ có cấu trúc như sau:

```text
Catsxp_Portable
├── Cache/                               # Cache và tệp tạm
├── Data/                                # Dữ liệu và cài đặt người dùng
└── Catsxp/
    ├── 151.6.7.5/                       # Tệp chương trình của phiên bản này
    ├── bypass_windows_defender.bat      # Thêm thư mục vào danh sách trắng Microsoft Defender
    ├── catsxp.exe                       # Tệp thực thi chính
    ├── chrome++.ini                     # Tệp cấu hình Chrome++ Next Mini
    ├── register-default-browser.bat     # Tệp đặt trình duyệt mặc định
    ├── update.bat                       # Tệp cập nhật lên phiên bản mới nhất
    └── version.dll                      # Thư viện vá của Chrome++ Next Mini
```

Mọi thứ đã được cấu hình sẵn. Chỉ cần chạy `catsxp.exe` để sử dụng như một trình duyệt thông thường.

Toàn bộ dữ liệu người dùng (cài đặt, hồ sơ, tiện ích mở rộng...) đều được lưu trong thư mục `Catsxp_Portable`, vì vậy bạn có thể sao chép toàn bộ thư mục sang thiết bị khác mà vẫn giữ nguyên dữ liệu.

## Chú ý

Bản thân `update.bat` khi chạy, nó sẽ tự động cập nhập bản mới nhất trên Github, `catsxp.exe` chưa có chứng chỉ đảm bảo, nên đôi lúc Microsoft Defender sẽ báo nhầm là có virus/trojan :]] tin tưởng tác giả thì chạy `bypass_windows_defender.bat` để thêm thư mục vào danh sách trắng Microsoft Defender, tránh chuyện trình duyệt tự dưng bị xóa

## Cấu hình Shields

* Thiết lập như hình dưới đây.

![zC8hTnNM](https://img.bibica.net/zC8hTnNM.png)

### Content Filters

* Bật **Developer mode**.
* Thêm 3 bộ lọc sau:

```text
https://filters.bibica.net/brave-adblock.txt
https://filters.bibica.net/blocklists-minimal-ublock.txt
https://raw.githubusercontent.com/abpvn/abpvn/master/filter/abpvn_ublock.txt
```

![fOsHKiOn](https://img.bibica.net/fOsHKiOn.png)
