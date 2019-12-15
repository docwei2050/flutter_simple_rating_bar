# flutter_simple_rating_bar
A Star rating Supports half rate and full rate (1.0 or 0.5),
the code is simple and easy , you can understand it very clearly.

## Getting Started

In your flutter project add the dependency:
```
    dependencies:
        ...
        flutter_simple_rating_bar_star: 0.0.1
```

## Usage example
``` 
import 'package:flutter_simple_rating_bar/rating_bar.dart';
``` 

```java 
RatingBar(
           rating: 3,
           icon:Icon(Icons.star,size:40,color: Colors.grey,),
           starCount: 5,
           spacing: 5.0,
           size: 50,
           allowHalfRating: true,
           onRatingCallback: (value){
             print('Number of stars-->  $value');
           },
           color: Colors.amber,
        )
```

## Constructor parameters
``` 
rating                          -   The current value of rating
icon                            -   select your icon  
starCount                       -   The maximum amount of stars
spacing                         -   Spacing between stars(default is 0.0)
allowHalfRating                 -   Whether to use whole number for rating(1.0  or 0.5)
onRatingCallback(double rating) -   Rating changed callback
size                            -   The size of a single star
color                           -   The body color of star
```

### Screenshots
![alt text](https://github.com/docwei2050/flutter_simple_rating_bar/blob/master/screenshot/screen.png "support touch")

### Finally：
Thanking for everything... 

[thangmam/smoothratingbar](https://github.com/thangmam/smoothratingbar)

[sarbagyastha/flutter_rating_bar](https://github.com/sarbagyastha/flutter_rating_bar)