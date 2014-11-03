Bare Bones Compiler
===================
Trình biên dịch cho ngôn ngữ lập trình Bare Bones  

# Mục lục
<!-- MarkdownTOC -->

- [Giới thiệu ngôn ngữ lập trình Bare Bones](#giới-thiệu-ngôn-ngữ-lập-trình-bare-bones)
    - [Tên gọi](#tên-gọi)
    - [Đặc điểm](#dặc-điểm)
        - [Các câu lệnh](#các-câu-lệnh)
        - [Quy ước đặt tên](#quy-ước-đặt-tên)
        - [Phạm vi giá trị của biến](#phạm-vi-giá-trị-của-biến)
        - [Nhập/xuất](#nhậpxuất)
        - [Dấu ngăn cách lệnh và chú thích](#dấu-ngăn-cách-lệnh-và-chú-thích)
- [Trình biên dịch cho BareBones](#trình-biên-dịch-cho-barebones)
    - [Ý tưởng xây dựng](#y-tưởng-xây-dựng)
    - [Công cụ](#công-cụ)
    - [Hướng dẫn cài đặt và sử dụng](#hướng-dẫn-cài-đặt-và-sử-dụng)
        - [Cài đặt](#cài-đặt)
        - [Sử dụng](#sử-dụng)
- [Đóng góp](#dóng-góp)

<!-- /MarkdownTOC -->


## Giới thiệu ngôn ngữ lập trình Bare Bones

### Tên gọi

Bare Bones (programing language) dịch ra Tiếng Việt có nghĩa là  ngôn ngữ lập trình cơ bản nhất, đơn giản nhất;  
Vì tên dịch ra rất dài, khó nhớ nên từ đây trở về sau, trong tài liệu này sẽ quy ước tên gọi là **ngôn ngữ lập trình BareBones** hay đơn giản là **BareBones**

### Đặc điểm

#### Các câu lệnh

BareBones hết sức đơn giản, chỉ có 5 câu lệnh và 1 cấu trúc lặp `while ... do`

Câu lệnh                    | Ý nghĩa
:---------------------------|:-------
init <*biến*> = <*giá trị*>;| Khai báo biến và khởi tạo giá trị cho biến
clear <*biến*>;             | Xóa giá trị của biến (đưa về `0`) (`X := 0`)
incr <*biến*>;              | Tăng giá trị của lên 1 đơn vị (`X := X + 1`)
decr <*biến*>;              | Giảm giá trị của xuống 1 đơn vị, (`X := X - 1`)
copy <*biến*> to <*biến*>;  | Sao chép giá trị của 1 biến cho 1 biến khác (`Y := X`)
while <*biến*> not 0 do;<br> &nbsp;&nbsp;&nbsp;&nbsp;<*các câu lệnh*>;<br> end; | Nếu giá trị của `biến` chưa bằng `0` thì các câu lệnh trong vòng lặp `while` vẫn tiếp tục.

#### Quy ước đặt tên
* Từ khóa (tên dành riêng): các từ trong danh sách sau là tên dành riêng được BareBones sử dụng, không được dùng để đặt tên cho biến
```
    clear  
    copy  
    decr  
    do  
    end  
    incr  
    init  
    not  
    to  
    while  
```
    Các từ khóa không phân biệt hoa thường

* Tên biến: Ngoài các từ khóa trên không được dùng,tên biến được đặt theo quy tắc sau:
    * Phải bắt đầu bằng 1 chữ cái trong bảng chữ cái alphabet (`a-z`)
    * Tên biến có thể chứa số (`0-9`) và dấu gạch dưới `_`
    * Không phân biệt hoa-thường (Các tên `a1b, A1B, a1B, A1b` là như nhau)

#### Phạm vi giá trị của biến
Biến có thể nhận các giá trị là số nguyên không âm, giới hạn tối đa là `2^64-1` (Tương đương với kiểu `uintmax_t` của ngôn ngữ *C*)

#### Nhập/xuất
BareBones không sử dụng nhập xuất từ bên ngoài chương trình. Giá trị được nhập lúc khởi tạo biến, khi chương trình kết thúc, các giá trị sẽ được xuất ra *thiết bị xuất chuẩn* (thường là màn hình)

#### Dấu ngăn cách lệnh và chú thích
* Chú thích: sử dụng dấu `#`đầu chú thích, chú thích được tính từ sau dấu `#` đến cuối dòng, không có chú thích nhiều dòng, muốn làm vậy phải sử dụng `#` cho mỗi dòng cần chú thích
* Ngăn cách lệnh: sử dụng dấu `;` ở cuối mỗi lệnh. **Đặc biệt**, sau từ khóa `do` cũng phải có dấu `;`


## Trình biên dịch cho BareBones
Quy ước tên viết tắt:
* Trình biên dịch cho ngôn ngữ Bare Bones (hay BareBones Compiler): BBC
* Máy ảo thực thi mã do BBC sinh ra (hay BareBones Virtual Machine): BBVM

### Ý tưởng xây dựng
Dựa trên ý tưởng của ngôn ngữ [Java](http://vi.wikipedia.org/wiki/Java_%28ng%C3%B4n_ng%E1%BB%AF_l%E1%BA%ADp_tr%C3%ACnh%29) (viết 1 lần, chạy nhiều nơi), ngôn ngữ BareBones cũng tương tự như vậy: mã nguồn được dịch ra 1 loại [mã trung gian](http://en.wikipedia.org/wiki/P-code_machine), xuất ra tập tin , tuy nhiên tập tin này chưa thể thực thi được. Muốn thực thi chương trình ta cần dùng 1 `"máy ảo"` để đọc tập tin trung gian và thực thi.

![Sơ đồ](http://i.imgur.com/DWPAw0E.png)

* Ưu điểm: Mã nguồn chỉ cần biên dịch 1 lần, sau đó trên mỗi phần cứng, mỗi nền tảng sẽ đều sẽ có 1 máy ảo đảm nhận việc thực thi, không cần viết hay biên dịch lại 
* Nhược điểm: Phải trải qua 2 bước, không tạo ra tập tin nhị phân thực thi trực tiếp mà cần máy ảo do đó ảnh hưởng đến tốc độ thực thi của chương trình được viết bằng BareBones

### Công cụ
* Do tính nghèo nàn của BareBones nên ta không thể xây dựng trình biên dịch bằng chính ngôn ngữ này hay nói cách khác, BareBones không là [Bootstrapping (compilers)](http://en.wikipedia.org/wiki/Bootstrapping_%28compilers%29). Vì vậy BBC được xây dựng bằng ngôn ngữ lập trình [C](http://en.wikipedia.org/wiki/C_%28programming_language%29).  
* Ngoài ra, để tự động sinh mã hỗ trợ cho việc xây dựng BBC, bộ công cụ phân tích từ vựng và phân tích cú pháp [Lex](http://en.wikipedia.org/wiki/Lex_%28software%29) & [Yacc](http://en.wikipedia.org/wiki/Yacc) cũng được sử dụng, cụ thể là [GNU Flex](http://www.gnu.org/software/flex) (Lex) và [GNU Bison](http://www.gnu.org/software/bison) (Yacc)

### Hướng dẫn cài đặt và sử dụng

#### Cài đặt


#### Sử dụng

## Đóng góp

Tác giả | Công việc phụ trách
:-------|:-------------------
Trần Thị Duyên Hồng | - Tìm hiểu công cụ Lex và cách sử dụng Flex <br> - Xây dựng bộ từ vựng cho ngôn ngữ <br> - Phụ trách nền tảng Mac OS
Lương Tấn Đạt | - Tìm hiểu công cụ Yacc và cách sử dụng Bison <br> - Xây dựng bộ phân tích cú pháp cho ngôn ngữ <br> - Phụ trách nền tảng Windows
[Khang Mạnh Tử](https://github.com/manhtuvjp) <br> 12520477@gm.uit.edu.vn| - Xây dựng trình biên dịch và máy ảo <br> - Chịu trách nhiệm triển khai biên dịch mã nguồn tự động trên Travis-CI <br> - Viết tài liệu hướng dẫn <br>- Phụ trách nền tảng Linux

