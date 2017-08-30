# 1. Giới thiệu về Swinject
Để mở đầu bài viết, mình xin trích lại phần giới thiệu ngắn gọn về Swinject trên Github, translate ra thì sẽ thế này:
> Swinject là một bộ khung Dependency Injection nhỏ gọn được viết cho ngôn ngữ Swift
> 
> Trong đó Dependency Injection (DI) là một mẫu thiết kế phần mềm, dùng nguyên lý Inversion of Control (IoC) để giải quyết sự phụ thuộc trong lập trình phần mềm. Ứng dụng mẫu thiết kế DI này, Swinject giúp phần mềm được chia thành các thành phần, module ít phụ thuộc lẫn nhau, nhờ đó việc lập trình, kiểm thử và bảo trì trở nên dễ dàng hơn.
> 
> Swinject sử dụng Generic Type và First class function của Swift, giúp việc khai báo các dependency trở nên dễ dàng hơn.

Ok, khá là blah blah blah.....
Đập vào mắt là cả một mớ khái niệm có vẻ rắc rối. Tuy nhiên, có thể thấy mục đích của Swinject là để giải quyết một vấn đề khá cơ bản trong thiết kế lập trình hướng đối tượng, đó là sự phụ thuộc (coupling) giữa các module. Vậy để hiểu và áp dụng được Swinject, ta sẽ phải tua qua các nội dung sau:

1. **_Ví dụ về Coupling Components._**
2. **_Dependency Injection (DI) - Dependency Inversion Principle (DIP) - Inverse of Control (IoC)._**
3. **_Cơ bản về Swinject._**
4. **_Generic type system & First class functions._**

# 2. Ví dụ về Coupling Components
Trước hết lấy một ví dụ khá ngô nghê về việc xử lý thanh toán online trên web shopping (Thực tế thì tôi cũng không biết nó được implement thế nào :D).

Ta có class `CreditCard` đại diện cho phương thức thanh toán qua thẻ tín dụng.
```swift
class CreditCard {
    let currency: String

    init(currency: String) {
        self.currency = currency
    }

    func description() -> String {
        return "Visa/Master Credit Card"
    }
}
``` 

Class `Order` đại diện cho đơn hàng trên hệ thống.
```swift
class Order {
    let payment = CreditCard(currency: "VNĐ")

    func confirmPayment() -> String {
        return "Your order will be paid in \(payment.currency) with \(payment.description())!"
    }
}
```
Ở đây phương thức thanh toán `CreditCard` đã được khởi tạo trực tiếp bên trong class `Order`. Làm vậy, class `CreditCard` trở thành dependency của class `Order` và đã được hard-code trong class `Order`. 

Có gì đó không đúng phải không? Thực tế, ta phải support nhiều loại Credit currency khác nhau, chưa kể còn nhiều phương thức thanh toán khác ngoài Credit! Việc hard-code việc khởi tạo `CreditCard` trong class `Order` sẽ khiến việc mở rộng phần mềm trở nên khó khăn.

Vậy thì để giải quyết một phần vấn đề này, theo cách suy nghĩ rất tự nhiên, ta chỉ cần tạo object `CreditCard` ở ngoài sau đó truyền nó vào khi khởi tạo một `Order`. Và đó cũng chính là **Dependency Injection (DI)**!

# 3. Dependency Injection (DI) - Dependency Inversion Principle (DIP) - Inverse of Control (IoC)
### Dependency Injection (DI)
Tiếp tục với ví dụ trước, nếu sử dụng DI, code sẽ được viết thế này:

```swift
class Order {
    let payment: CreditCard

    init(payment: CreditCard) {
        self.payment = payment
    }

    func confirmPayment() -> String {
        return "Your order will be paid in \(payment.currency) with \(payment.description())!"
    }
}
```

Khi đó payment dependency sẽ được inject vào `Order` khi khởi tạo:
```swift
let creditCard = CreditCard(currency: "USD")
let order = Order(payment: creditCard)
```

Pattern trên còn được gọi là **_Initializer injection_**. Ta còn có thể gắn dependency thông qua việc gán biến (**_Propery Injection_**) hoặc thông qua một phương thức trung gian (**_Method Injection_**)

Vậy là ta đã giải quyết được một phần vấn đề Coupling, vấn đề tiếp theo đặt ra là, ví dụ ta có thêm một phương thức thanh toán khác là `Bitcoin`! Có thể nhận ra ngay là class `Order` sẽ chỉ chấp nhận mỗi phương thức thanh toán `CreditCard` vì thuộc tính `payment` đã được định nghĩa type là `CreditCard` rồi.

Và đây là lúc ta sẽ áp dụng nguyên lý Dependency Inversion (DIP) để giải quyết vấn đề này.

### Dependency Inversion Principle (DIP)
Dependency Inversion là nguyên lý thứ 4 trong [bộ 5 nguyên lý thiết kế phần mềm](https://en.wikipedia.org/wiki/Dependency_inversion_principle) - viết tắt là **SOLID**
Trích lại nguyên lý DIP từ Wiki:
>Module cấp cao không nên phụ thuộc vào module cấp thấp. Mà cả 2 nên phụ thuộc vào một lớp Abstraction.

Nguyên lý này giải quyết bài toán Decoupling dependency. Áp dụng vào ví dụ về thanh toán này, thì cả `CreditCard` và `Order` sẽ nên được viết lại để trao đổi với nhau qua một Interface, hay là Protocol trong Swift.

Ta sẽ viết thêm một protocol là `IPayment`
```swift
protocol IPayment {
    var currency: String { get }
    func description() -> String
}
```

`CreditCard` và `Bitcoin` khi đó sẽ implement protocol này
```swift
class CreditCard: IPayment {
    let currency: String

    init(currency: String) {
        self.currency = currency
    }

    func description() -> String {
        return "Visa/Master Credit Card"
    }
}

class Bitcoin: IPayment {
    let currency: String = "BTC"

    func description() -> String {
        return "Bitcoin"
    }
}
```

`Order` sẽ được sửa để định nghĩa lại kiểu của thuộc tính `payment`
```swift
class Order {
    let payment: IPayment

    init(payment: IPayment) {
        self.payment = payment
    }

    func confirmPayment() -> String {
        return "Your order will be paid in \(payment.currency) with \(payment.description())!"
    }
}
```

Sau đó việc ta có thể dễ dàng tạo Order với bất kỳ phương thức thanh toán nào!
```swift
let creditCard = CreditCard(currency: "JPY")
let bitcoin = Bitcoin()
let orderOne = Order(payment: creditCard)
let orderTwo = Order(payment: bitcoin)
```

Ezzzz! Right?? Vậy thì còn lại cái keyword này **_Inversion of Control (IoC)_**, rốt cuộc là cái gì nghe nguy hiểm thế?

### Inversion of Control (IoC)
Ok thôi, với Coder tay to thì không ngại Google và đọc [Wiki](https://en.wikipedia.org/wiki/Inversion_of_control) lần nữa
>In software engineering, inversion of control (IoC) is a design principle in which custom-written portions of a computer program receive the flow of control from a generic framework.

Nghe đơn giản thôi nhỉ, IoC là nguyên lý phần mềm đề xuất: giao việc điều khiển luồng chạy của chương trình cho một Framework chung xử lý và gọi từ ngoài vào. Ngược với cách viết truyền thống là sử dụng một thư viện chung và gọi vào các hàm của thư viện.

Eureka! Vậy tức là cái Generic Framework mà Wiki đề cập ở đây, chính là cái framework **Swinject** mà ta đang tìm hiểu. Ta sẽ không phải lo việc tự xử lý dependency nữa, mà đẩy hết cho **Swinject** lo :D

##### ---
Ok, tóm tắt lại ta có 3 keyword nghe thật to tát: **Dependency Injection**, **Dependency Inversion** và **Inverse of Control**
- DI giải quyết việc gắn dependency thế nào? (Initializer, Property, Method)
- DIP giải quyết việc Decoupling thông qua việc chia sẻ lớp Abstract chung.
- IoC thì giống với Tuyển dụng ý: Bạn không cần phải gọi cho tôi, tôi sẽ gọi cho bạn! [Link](https://en.wikipedia.org/wiki/Inversion_of_control#Overview)

# 3. Cơ bản về Swinject
### Cách cài đặt bằng CocoaPods
Tạo file `Podfile` trong thư mục gốc của project, hoặc sửa lại nếu đã có như sau:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0' # or platform :osx, '10.10' if your target is OS X.
use_frameworks!

pod 'Swinject', '~> 2.1.0'

# Uncomment if you use SwinjectStoryboard
# pod 'SwinjectStoryboard', '~> 1.0.0'
```
Sau đó chạy lệnh `pod install`. Chi tiết bạn tham khảo tại [CocoaPods](https://cocoapods.org/)

### Show me the code!
...Okay, download [source code](https://github.com/muzix/swinject-demo/releases) hoặc [clone project](https://github.com/muzix/swinject-demo) về.

First step!
```ruby
cd swinject-demo
pod install
```

Tiếp theo... Build, sau đó mở file MyPlayground.playground.

Cách sử dụng Swinject rất đơn giản. Sau khi khởi tạo Container (chính là cái IoC container đó đó), ta đăng ký với Container một class kèm theo một closure chứa code khởi tạo object từ Class đó.
```swift
let container = Container()
container.register(IPayment.self) { _ in Bitcoin() }
```
Tương tự như vậy với class Order
```swift
container.register(Order.self) { r in
    Order(payment: r.resolve(IPayment.self)!)
}
```
Chú ý ở điểm đặc biệt ở đây, khi khởi tạo Order, ta giao cho Resolver của Swinject tự động chọn ra denpendency phù hợp với giao thức IPayment

Cuối cùng, để tạo một Order ta chỉ cần làm thế này:
```swift
let swinjectOrder = container.resolve(Order.self)
print(swinjectOrder.confirmPayment()) // Output: Your order will be paid in BTC with Bitcoin!
```