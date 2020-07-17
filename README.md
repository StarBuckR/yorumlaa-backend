# Yorumlaa Backend

Ruby on Rails backend(RESTFul API) of a site that my friends and I created. 

# Restful API #
Heroku üzerinde çalışırken **localhost:3000** yerine **https://yorumlaa.herokuapp.com** kullanmalısınız.
Örneğin: **https://yorumlaa.herokuapp.com/api/login**

Eğer **admin hesabı gerekirse**, **en başta oluşturduğum bilgilerle olan kullanıcı admin**. Onu kullanabilirsiniz.

Aşağıdaki yazılanların tamamı **localhost:3000/api** içerisinde bulunmaktadır. Ben yine de her sorgunun tam linkini ve tam gereksinimlerini detaylıca açıklayacağım.

Hataları da olabildiğince göstereceğim.

# **MESAJLAR** #
Mesajlar 2'ye ayrılıyor. Hata ve başarı mesajları. 

Hata mesajlarında status 4 ile başlayan numaralarda dönüyor(400, 401, 402, 403, 404, 422). Eğer dönen json'da **errors** varsa bir dizi olarak veritabanına yazma hataları döner. Eğer **message** içinde dönerse, benim elimle yazdığım hatalar dönecektir.

Gönderdiğiniz bir json'da bir eksiklik veya varsa bunu **errors** içinde alırsınız. O yüzden **her birisi için** yanlış yazma hatalarını açıklamayacağım.

Başarı mesajları 2 ile başlayan status ile döner(200, 201 vs.). **message** içinde mesaj döner.

Buradaki hataları kırmızı arka planda, başarı mesajlarını ise yeşil arka planda direkt kullanıcıya gösterebilirsiniz. Değiştirmemi istediğiniz varsa da belirtirseniz sevinirim.

# **User** #
## User ve Session ##

Bu kısım birden fazla aşamadan oluşuyor. User *create*, *destroy*, *update* ve *show* methodları. Diğer kısım ise Session *create* ve *destroy*.

## User oluşturma, silme ve gösterme (create, destroy, show) ##
## **Create User (signup)** ##
User oluşturmak için, **localhost:3000/api/signup** adresine **POST** methodu ile aşağıdaki json'ı göndermeniz gerekiyor.
```
#!json
{
	"user": {
		"email": "ridvan@gmail.com",
		"username": "ridvan",
		"password": "123456a",
        "avatar": "<image> -- bu her dilde farklı, eğer yoksa bu kısmı tamamen silin"
	}
}

```
Burada email doğru email formatında olmalı (ornek@ornek2.com).
Şifrenin de uzunluğu en az 6 karakter en fazla 30 karakter olabilir. Şifrede en az 1 küçük veya büyük karakter, ve en az 1 sayı olmalı.
Username de 1 ila 50 karakter arasında olabilir.

##

Herhangi bir hata olduğunda gerekli mesajı aşağıdaki şekilde Türkçe olarak alacaksınız:

```
#!json
{
    "errors": [
        "Kullanıcı adı hali hazırda kullanılmakta",
        "E-mail hali hazırda kullanılmakta",
        "Şifre çok kısa (en az 6 karakter)",
        "Şifre en az 1 rakam ve 1 harf içermelidir"
    ]
}
```

Eğer herhangi bir hata yoksa şu şekilde bir cevap alırsınız:


```
#!json
{
    "id": 1,
    "username": "ridvan"
}

```

## **Update User** ##

Bu durumu daha güvenlikli olması açısından, tokenle değil kullanıcıdan bilgi alarak yapmak daha mantıklı geldi. Telefondaki authentication olayı yapılana kadar sadece **password** değişmesi daha doğru olur. O yüzden **localhost:3000/api/users/<id>** adresine giderek **PATCH** methodu ile aşağıdaki json'ı göndermeniz gerekiyor.

```
#!json
{
	"user": {
		"password": "123456a",
		"new_password": "123456aa"
	}
}
```
Bu kişi şifresini girmeden yeni şifresini belirleyemez. Eğer doğru bir şekilde şifresini ve yeni şifresini girdiyse, kullanıcı id'si ve username'i döner. Eğer hatalı şifre yazılırsa aşağıdaki çıktı döner.

```
#!json
{
    "message": "Hatalı şifre girdiniz"
}

```


## **Destroy User** ##
Kullanıcıyı veritabanından tamamen silmek için, **localhost:3000/api/users/<id>** adresine **DELETE** methodu ile aşağıdaki json'ı göndermeniz gerekiyor. Buradaki json kullanıcı oluştururken kullandığımız bilgilerle aynı bilgileri içeriyor.

```
#!json
{
	"user": {
		"email": "ridvan@gmail.com",
		"username": "ridvan",
		"password": "123456a"
	}
}

```

Alacağınız cevap ise

```
#!json
{
    "message": "Hesabınız silindi!"
}
```
Eğer doğru bilgileri girmediyseniz, yukarıdaki **errors** tarzı bir hata ile karşılaşırsınız.

Görebildiğiniz gibi, **message** benim *genellikle* benim tarafımdan yazılmış, durum veya hata belirten mesajlar. Errors ise veritabanı işlemlerinde girilen yanlış, hatalı bilgileri yazdıran obje.

## **Show** ##

Kullanıcıyı görüntülemek için **GET** methodu ile **localhost:3000/api/users/<id>** adresine gitmemiz gerekiyor.


```
#!json
{
    "id": 1,
    "username": "ridvan"
}

```
Alacağımız çıktı bu şekilde olacaktır.
Eğer aradığımız id'deki kullanıcı yok ise:

```
#!json
{
    "message": "Kullanıcı bulunamadı"
}
```
Şeklinde bir çıktı alacağız
## **Verify User** ##
Mailden gelen kod ile hesap onaylanabilmesi için **localhost:3000/api/users/<id>/verify** adresine **POST** methodu ile aşağıdaki gibi bir json göndermeniz gerekiyor:

```
#!json
{
	"verification": "44234ca46e8be3c993c1 -> burası 6 haneli sadece harflerden oluşan bir hale dönüşecek, ona göre tasarlayabilirsiniz."
}
```

# **Session Create ve Destroy** #
## **Create Session** ##

Session oluşturmak login olmak demektir. Bu yüzden **localhost:3000/api/login** adresine **POST** methodu ile aşağıdaki objeyi yolluyoruz.


```
#!json
{
	"user": {
		"email_or_username": "ridvan@gmail.com",
		"password": "123456a"
	}
}

"veya"

{
	"user": {
		"email_or_username": "ridvan",
		"password": "123456a"
	}
}
```

İki durum da çalışacaktır. Size dönen çıktı:

```
#!json
{
    "jwt": "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJyaWR2YW4iLCJleHAiOjE1ODc1MDE3OTV9.aZcMUl4kY7ecqXMoutZ-nIzGYiGFDl6RN9JZ_g_0FwI"
}
```
şeklinde olacaktır. Bu token *client* tarafında tutulacak olup, işlemlerin bi' çoğunda kullanılacaktır.

## Destroy Session ##

Tokenler stateless olduğu için, bu method için backend de bi' şey yapılamıyor. Client tarafında tokeni silmeniz yeterli olacaktır.

# **AUTHORIZATION** #
Authorization için Header kısmında **"Authorization"** isminde bir key oluşturup yukarıdaki jwt tokenini bununla birlikte göndermeniz gerekiyor.

Sitede birçok işlem için token gerekiyor. O yüzden **eğer varsa tokeni kesinlikle göndermeniz gerekiyor**.

Giriş yapılması gereken bir işlemi, **giriş yapmadan**(token göndermeden) yapmaya çalışırsanız:

```
#!json
{
    "message": "Bu işlem için giriş yapmanız gerekiyor."
}
```
Hatası alırsınız. İsterseniz bu hatayı **"Bu işlemi gerçekleştirmek için giriş yapmanız gerekiyor"** şeklinde değiştirebilirim.

Eğer admin olarak gerçekleştirilmesi gereken bir işlemi, admin olmayan bir kullanıcının tokeni ile gerçekleştirmeye çalıştırırsanız(**kullanıcı admin değilse** ve işlemi gerçekleştirmeye çalışırsa):

```
#!json
{
    "message": "Bu işlemi gerçekleştirmek için yetkili olmanız gerekiyor"
}
```

Eğer **tokenin süresi dolmuş** ise:

```
#!json
{
    "message": "Bu işlem için giriş yapmanız gerekiyor."
}
```
Mesajını alırsınız. Bunların hepsi status: 401 Unauthorized olarak döner.

# Product #
Bu kısımda *show*, *create* ve bazı admin özellikleri tanıtılacaktır.

## **Create Product Request** ##

Product Request oluşturmak için aşağıdaki gibi bir json'ı **localhost:3000/api/products** adresine **POST** methodu ile göndermeniz gerekiyor. **Content-Type: multipart/form-data olmalı**

```
#!json

{
	"product": {
		"title": "Iphone X",
		"category": "Akıllı Telefon",
        "images": ["images"], "<-- burası postman de şu şekilde images[]: dilden dile değişebilir ama array olarak göndermezseniz sistem almaz"
	}
}
```
Category kısmını yeni yaptım(16.05.2020) o yüzden serverda bulunmayabilir.
Eğer hatalı bir girdi verirseniz yine errors içinde bir dönüş alacaksınız. Eğer token vermezseniz, yani kullanıcı giriş yapmamış ise:

```
#!json
{
    "message": "Bu işlem için giriş yapmanız gerekiyor."
}
```
cevabını alırsınız. (bu mesajı değiştirebiliriz)

Eğer hata yok ise, request oluşturulur ve aşağıdaki gibi bir çıktı döner.
```
#!json
{
    "id": 8,
    "title": "Iphone X",
    "approval": false,
    "age_restriction": false,
    "created_at": "2020-04-21T16:53:17.764Z",
    "updated_at": "2020-04-21T16:53:17.764Z",
    "slug": "iphone-x",
    "category": "Akıllı Telefon"
}
```

## **Show Product** ##
Bir ürünü görüntülemek için id'sini veya yukarıda da gözüken **"slug"**'ını URL'de kullanabilirsiniz.
Örneğin oluşturduğumuz ürünü görmek için; **localhost:3000/api/products/iphone-x** adresine **GET** methodu ile giderek ürünü görebilirsiniz.


```
#!json
{
    "breadcrumb": [
        {
            "id": 11,
            "name": "Elektronik",
            "created_at": "2020-05-15T19:39:08.582Z",
            "updated_at": "2020-05-15T19:39:08.582Z",
            "ancestry": null,
            "children": [
                {
                    "id": 13,
                    "name": "Telefon",
                    "created_at": "2020-05-15T19:39:25.595Z",
                    "updated_at": "2020-05-15T19:39:25.595Z",
                    "ancestry": "11",
                    "children": []
                }
            ]
        }
    ],
    "images": [
        {
            "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBFUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--84ea488afb061e64b837446e5c543aac9c3f27ba/4w5tEawk_400x400.jpg"
        },
        {
            "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBFZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--e32a2d76e7b5e601b0e4b2b9010fd9a8c64cca25/333.png"
        },
        {
            "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBFdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--882bb70c8dd593d5cd5119a86705b36285c64575/4w5tEawk_400x400.jpg"
        },
        {
            "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBGQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--dbcb70b673ab7835fdd3c802649cb4c5699c6fa9/333.png"
        }
    ],
    "ratings": {
        "overall": 6.34375,
        "particularly": {
            "Kamera": 6.5,
            "Performans": 3.5,
            "Fiyat/Performans": 9.0,
            "Batarya": 6.5
        }
    },
    "product": {
        "id": 24,
        "title": "Iphone XX",
        "approval": false,
        "age_restriction": false,
        "created_at": "2020-05-29T09:35:31.369Z",
        "updated_at": "2020-05-29T09:35:31.432Z",
        "slug": "iphone-xx",
        "category": "Telefon"
    },
    "comments": [
        {
            "comment": {
                "id": 46,
                "body": "body budur ahmet",
                "like": 0,
                "dislike": 0,
                "product_id": 24,
                "user_id": 5,
                "username": "ahmet",
                "created_at": "2020-05-29T21:08:40.241Z",
                "updated_at": "2020-05-29T21:08:40.241Z"
            },
            "rating": 6.7109375
        },
        {
            "comment": {
                "id": 47,
                "body": "body budur ridvan",
                "like": 0,
                "dislike": 0,
                "product_id": 24,
                "user_id": 1,
                "username": "ridvan",
                "created_at": "2020-05-29T21:09:01.022Z",
                "updated_at": "2020-05-29T21:09:01.022Z"
            },
            "rating": 6.7109375
        }
    ]
}
```
Images normalde **/rails/** şeklinde bir link olarak geliyor.
# **ADMIN** #
## **Admin Approve Product** ##

Bu fonksiyonu, gelen ürün isteklerini onaylamak için kullanıyoruz. **localhost:3000/api/admin/approve** adresine **POST** methodu ile aşağıdaki json'ı gönderiyoruz.


```
#!json
{
	"id": 8
}
```
Eğer id doğru girildiyse ve Authorization'dan gelen token admin tokeni ise(kullanıcı admin ise):

```
#!json

{
    "message": "Ürün onaylandı",
    "product": {
        "approval": true,
        "id": 8,
        "slug": "iphone-x",
        "title": "Iphone X",
        "age_restriction": false,
        "created_at": "2020-04-21T16:53:17.764Z",
        "updated_at": "2020-04-22T09:10:07.435Z"
    }
}
```
Eğer id doğru girilmemişse veya daha önceden onaylanmışsa:

```
#!json
{
    "message": "Ürün bulunamadı veya zaten onaylı"
}
```
Şeklinde bir çıktı alırsınız. Admin olmadığındaki hataları vs. **Authorization** kısmında anlatmıştım, yeniden inceleyebilirsiniz.

## **Admin List Not Approved** ##
Adminler için, onaylanmamış ürünlerin tam listesini getirir. **localhost:3000/api/admin/list_not_approved** adresine **GET** methodu ile çağrı yapmanız gerekiyor. Alacağınız çıktı:


```
#!json
{
    "products": [
        {
            "id": 4,
            "title": "Iphone 5",
            "approval": false,
            "age_restriction": false,
            "created_at": "2020-04-10T22:46:59.413Z",
            "updated_at": "2020-04-10T22:46:59.413Z",
            "slug": "iphone-5"
        },
        {
            "id": 5,
            "title": "Iphone 6",
            "approval": false,
            "age_restriction": false,
            "created_at": "2020-04-10T22:47:04.671Z",
            "updated_at": "2020-04-10T22:47:04.671Z",
            "slug": "iphone-6"
        },
        {
            "id": 6,
            "title": "Iphone 6s",
            "approval": false,
            "age_restriction": false,
            "created_at": "2020-04-10T22:47:06.484Z",
            "updated_at": "2020-04-10T22:47:06.484Z",
            "slug": "iphone-6s"
        }
    ]
}
```
şeklinde olacaktır.

## **Admin Create Rating Category** ##
Adından da anlaşılacağı üzere derecelendirme kategorisi oluşturuyor. **Sadece kategori oluşturuyor**.
Çağrı için **localhost:3000/api/admin/create_rating_category** adresine **POST** methodu ile aşağıdaki gibi bir json'ı göndermeniz gerekiyor.

```
#!json
{
	"category_name": "Kamera"
}
```
Kategori ismi için minimum 3, maximum 30 karakter limiti vardır.

Eğer kategori ismi zaten varsa:


```
#!json
{
    "message": "Bu isimde bir kategori zaten var"
}
```

Eğer yoksa ve başarı ile oluşturulursa:

```
#!json
{
    "message": "Kategori başarı ile yaratıldı"
}
```
Daha sonra bu kategoriyi ürünlere bağlamamız gerekiyor. Onun için aşağıdaki methodu kullanacağız.

## **Admin Create Product Ratings** ##
**localhost:3000/api/admin/create_product_ratings** adresine **POST** methodu ile aşağıdaki gibi bir json göndermelisiniz. Bu json, o ürün için olan tüm ratingleri belirliyor ve sonradan güncellenemiyor. Admin sayfasında olacağı için bir sorun olacağını düşünmüyorum.

```
#!json
{
	"ratings": [
		{"category_name": "Kamera"},
		{"category_name": "Performans"},
		{"category_name": "Fiyat/Performans"},
		{"category_name": "Batarya"}
	],
	"product_id": 2
}
```
Eğer hali hazırda bir rating template bulunuyorsa:

```
#!json
{
    "message": "Zaten bir product rating bulunuyor"
}
```
Eğer bulunmuyorsa ve başarılı bir şekilde oluşturulursa:

```
#!json
{
    "id": 2,
    "product_id": 2,
    "category_names": [
        "Kamera",
        "Performans",
        "Fiyat/Performans",
        "Batarya"
    ],
    "created_at": "2020-04-22T09:44:12.698Z",
    "updated_at": "2020-04-22T09:44:12.698Z"
}
```
Şeklinde bir çıktı alırsınız.

# **COMMENTS** #

## **Create Comment** ##
Yorum oluşturmak için ürün sayfasına gitmemiz gerekiyor. Herkesin bir yorumu olduğu için, ve kullanıcıların bakış açısından yazdığım için bu daha mantıklı geldi. Örnek olarak **localhost:3000/api/products/iphone-x/create_comment** adresine **POST** methodu ile aşağıdaki gibi bir json göndermeniz gerekiyor:

```
#!json
{
	"body": "body budur hele",
	"ratings": [
		{
			"category_name": "Kamera",
			"rating_value": 6
		},
		{
			"category_name": "Performans",
			"rating_value": 4
		},
		{
			"category_name": "Fiyat/Performans",
			"rating_value": 8
		},
		{
			"category_name": "Batarya",
			"rating_value": 7
		}
	]
}
```
Bu, bulunduğunuz ürüne bir yorum oluşturacaktır. Eğer hata yoksa:

```
#!json
{
    "comment": {
        "id": 42,
        "body": "body budur hele",
        "like": 0,
        "dislike": 0,
        "product_id": 8,
        "user_id": 1,
        "username": "ridvan",
        "created_at": "2020-04-22T10:02:26.222Z",
        "updated_at": "2020-04-22T10:02:26.222Z"
    },
    "rating": {
        "id": 5,
        "user_id": 1,
        "product_id": 8,
        "ratings": [
            {
                "category_name": "Kamera",
                "rating_value": 6
            },
            {
                "category_name": "Performans",
                "rating_value": 4
            },
            {
                "category_name": "Fiyat/Performans",
                "rating_value": 8
            },
            {
                "category_name": "Batarya",
                "rating_value": 7
            }
        ],
        "created_at": "2020-04-22T10:02:26.286Z",
        "updated_at": "2020-04-22T10:02:26.286Z"
    }
}
```
gibi bir çıktı alırsınız. Eğer daha önce bir yorumunuz bulunuyorsa:

```
#!json
{
    "message": "Zaten bir yorumunuz bulunuyor"
}
```
mesajını 422 status ile birlikte alırsınız.

Eğer kategoriler ürünün kategorileriyle uyuşmuyorsa veya yanlış girmişseniz:

```
#!json
{
    "message": "Kategorileri doğru girdiğinizden emin olun"
}
```
Eğer derecelendirmede geçersiz bir değer girerseniz:

```
#!json
{
    "message": "Derecelendirmeler 0 ile 10 arasında olmalıdır"
}
```

## **Comment Update** ##
Bir yorumu güncellemek için **localhost:3000/api/products/iphone-x** adresine **PATCH** methodu ile aşağıdaki gibi bir json göndermeniz gerekiyor:


```
#!json
{
	"body": "düzenlenmiş body"
}
```
Eğer bir hata yok ise:

```
#!json
{
    "id": 42,
    "body": "düzenlenmiş body",
    "user_id": 1,
    "product_id": 8,
    "username": "ridvan",
    "like": 0,
    "dislike": 0,
    "created_at": "2020-04-22T10:02:26.222Z",
    "updated_at": "2020-04-22T10:32:34.275Z"
}
```
çıktısını alırsınız.

Eğer size ait yorum yok ise:

```
#!json
{
    "message": "Bu ürüne ait bir yorumunuz bulunmuyor"
}
```
çıktısını alırsınız.

## **Update Rating** ##
Comment ve Rating'ler ayrı ayrı güncellenebiliyor. Yukarıda yorumu güncellemeyi gördük. Ratingi güncellemek için **localhost:3000/api/products/iphone-x/rating** adresine gidip **PATCH** methodu ile aşağıdaki gibi bir json göndermeniz gerekiyor.

```
#!json
{
	"ratings": [
		{
			"category_name": "Kamera",
			"rating_value": 8
		},
		{
			"category_name": "Performans",
			"rating_value": 9
		},
		{
			"category_name": "Fiyat/Performans",
			"rating_value": 7
		},
		{
			"category_name": "Batarya",
			"rating_value": 5
		}
	]
}
```

Eğer doğru girdi verdiyseniz:

```
#!json
{
    "id": 5,
    "ratings": [
        {
            "category_name": "Kamera",
            "rating_value": 8
        },
        {
            "category_name": "Performans",
            "rating_value": 9
        },
        {
            "category_name": "Fiyat/Performans",
            "rating_value": 7
        },
        {
            "category_name": "Batarya",
            "rating_value": 5
        }
    ],
    "user_id": 1,
    "product_id": 8,
    "created_at": "2020-04-22T10:02:26.286Z",
    "updated_at": "2020-04-22T16:11:46.336Z"
}
```
şeklinde bir çıktı alırsınız. Eğer hata varsa, yorum oluştururken aldığınız rating hatalarına benzer hatalar ile karşılaşırsınız. 

```
#!json
{
    "message": "Kategorileri doğru girdiğinizden emin olun"
}
```
## **Delete Comment** ##
Bir yorumu silmek için **localhost:3000/api/products/iphone-x** adresine **DELETE** methodu ile tokeni göndermeniz yeterlidir(tokeni ayrıca göndermenize gerek yok, normal bir şeklide header içinde gönderilecek). Alacağınız cevap:

```
#!json
{
    "message": "Yorum başarı ile silindi"
}
```
şeklindedir. Bu sayede yorumunuz, derecelendirmeniz ve yorumunuza ait tüm like'lar silinir.

## **Show Comment** ##
Bir kullanıcıya ait yorumları görüntülemek için, **localhost:3000/api/users/<id>/comments** adresine **GET** methodunu göndermeniz yeterlidir. Alacağınız cevap:

```
#!json
{
    "comments": [
        {
            "comment": {
                "id": 4,
                "body": "hebele hubele yorum",
                "like": 0,
                "dislike": -1,
                "product_id": 1,
                "user_id": 1,
                "username": "ridvan",
                "created_at": "2020-04-12T09:25:03.094Z",
                "updated_at": "2020-04-12T09:25:03.094Z"
            },
            "rating": 6.73583984375
        },
        {
            "comment": {
                "id": 4,
                "body": "hebele hubele yorum",
                "like": 0,
                "dislike": -1,
                "product_id": 1,
                "user_id": 1,
                "username": "ridvan",
                "created_at": "2020-04-12T09:25:03.094Z",
                "updated_at": "2020-04-12T09:25:03.094Z"
            },
            "rating": 6.73583984375
        },
]
}
```
Eğer id yanlış ise:

```
#!json
{
    "message": "Kullanıcı bulunamadı!"
}
```
şeklinde bir cevap alırsınız.

# **USER COMMENT DETAILS** #
## **Create Comment Details** ##
Eğer like veya dislike atmak istiyorsak, **localhost:3000/api/comments/<comment_id>** adresine giderek **POST** methodu ile aşağıdaki gibi bir json'ı göndermeniz gerekiyor.

```
#!json
{
	"details": {
		"like": true
	}
}
```
bu bir **like**, **dislike** için:

```
#!json
{
	"details": {
		"like": false
	}
}
```
göndermeniz gerekiyor. Eğer başarılı bir şekilde oluşturulursa:

```
#!json
{
    "id": 2,
    "comment_id": 7,
    "user_id": 1,
    "like": true,
    "created_at": "2020-04-22T16:30:08.053Z",
    "updated_at": "2020-04-22T16:30:08.053Z"
}
```
Eğer comment bulunamaz ise:

```
#!json
{
    "message": "Yorum bulunamadı"
}
```
şeklinde bir mesaj alırsınız. Eğer hali hazırda detay var ise:

```
#!json
{
    "message": "Yeniden like oluşturamazsınız, like'ı güncellemelisiniz"
}
```
şeklinde bir mesaj alırsınız. (Ne yazacağımı bilemedim mesaj olarak yardım)

## **Comment Detail Update** ##
Detayları güncellemek için oluşturduğumuz adrese (**localhost:3000/api/comments/<id>**) **PATCH** methodu ile aynı oluşturma şekilde bir json göndermeniz gerekiyor.

```
#!json
{
	"details": {
		"like": false
	}
}
```
Eğer aynı değeri göndermeye çalışırsanız:

```
#!json
{
    "message": "Detayı değiştirmeniz gerekiyor"
}
```
hatasını alırsınız. **ID yanlış** ise yukarıdaki ile aynı hatayı alırsınız. Eğer detaylar ve id doğru ise:

```
#!json
{
    "user_id": 1,
    "id": 1,
    "like": false,
    "comment_id": 7,
    "created_at": "2020-04-22T16:28:48.376Z",
    "updated_at": "2020-04-22T16:44:57.457Z"
}
```

şeklinde bir cevap alırsınız.

## **Delete Comment Details** ##
Eğer like veya dislike'ı kaldırmak istiyorsak, **localhost:3000/api/comments/<id>/comment_details** adresine **DELETE** methodunu göndermemiz yeterlidir. Eğer o yoruma ait detayınız bulunmuyorsa:

```
#!json
{
    "message": "Yoruma ait detay bulunamadı"
}
```
Eğer başarı ile silinebilirse:

```
#!json
{
    "message": "Detay başarı ile silindi"
}
```
cevabını alırsınız.

**Bu kısımdaki(Yorum Detay) mesajları kullanıcıya göstermemeniz daha iyi. Sadece arkadaki işlemler için status kodları kullanılabilir (200, 201, 400, 401)vs.**

# **Comment Report** #

## **Create Comment Report** ##
Bir rapor oluşturmak için **localhost:3000/api/comments/<id>/report** adresine **POST** methodu ile aşağıdaki gibi bir json'ı göndermeniz gerekiyor:

```
#!json
{
	"report_body": "Bu yorum beni rahatsız ediyor siler misiniz lütfen"
}
```
Eğer herhangi bir hata yoksa:

```
#!json
{
    "id": 1,
    "user_id": 1,
    "comment_id": 4,
    "report_body": "Bu yorum beni rahatsız ediyor siler misiniz lütfen",
    "created_at": "2020-04-26T21:30:42.528Z",
    "updated_at": "2020-04-26T21:30:42.528Z"
}
```
gibi bir cevap alırsınız. Eğer kullanıcının daha önceden o yoruma ait bir raporu bulunuyorsa, ve gözden geçirilmemişse(veya 2 kez oluşturmaya çalıştırmışsa):

```
#!json
{
    "message": "Zaten bir raporunuz bulunuyor"
}
```
şeklinde bir cevap alırsınız.

## **Delete Comment Report** ##
Eğer adminler kişinin raporunu gözden geçirmiş ve gerekeni yapmışsa, raporu silmeleri gerekiyor. Onun için **localhost:3000/api/reports/<id>** adresine **DELETE** methodu ile gönderi yapmanız gerekiyor. Herhangi bir body içermesine gerek yok admin tokeni yeterli olacaktır.

Eğer başarı ile silinirse:

```
#!json
{
    "message": "Rapor başarı ile silindi"
}
```
Eğer rapor bulunamaz ise:

```
#!json
{
    "message": "Rapor bulunamadı"
}
```
şeklinde bir mesaj alırsınız.

# **Categories** #

## **Create Category** ##
Kategori oluşturmak için(sadece kategori ismi), **localhost:3000/api/categories** adresine **POST** methodu ile aşağıdaki gibi bir json göndermeniz gerekiyor:

```
#!json
{
	"category": {
		"name": "Elektronik"
	}
}
```
Eğer bu kategori daha öncede bulunuyorsa:

```
#!json

{
    "message": {"Kategori ismi hali hazırda kullanılmakta"}
}
```
Eğer bulunmuyorsa:
```
#!json

{
    "id": 1,
    "name": "Elektronik",
    "created_at": "2020-05-15T19:42:40.690Z",
    "updated_at": "2020-05-15T19:42:40.690Z",
    "ancestry": null
}
```
şeklinde bir yanıt alırsınız. Burada *ancestry* kategori ağacı ile ilgilidir. Eğer kategorimizin *parent'ı* varsa yine aynı adrese aşağıdaki gibi bir json göndermeliyiz.** BUNU KATEGORİYİ OLUŞTURURKEN YAPMALIYIZ, SONRADAN DEĞİL
**.
```
#!json
{
	"category": {
		"name": "Bilgisayar",
        "parent": "Elektronik" 
	}
}
```
Yanıtımız aşağıdaki gibidir.
```
#!json

{
    "id": 1,
    "name": "Bilgisayar",
    "created_at": "2020-05-15T19:42:40.690Z",
    "updated_at": "2020-05-15T19:42:40.690Z",
    "ancestry": 1
}
```
## **Category Tree**##
Kategori ağacına erişmek için **localhost:3000/api/categories/tree** adresine **POST** methodu ile aşağıdaki gibi bir json atmanız gerekiyor. **EĞER İÇİNİ BOŞ BIRAKIRSANIZ AŞAĞIDAKİ GİBİ BÜTÜN AĞAÇ DÖNER**

```
#!json
[
    {
        "id": 11,
        "name": "Elektronik",
        "created_at": "2020-05-15T19:39:08.582Z",
        "updated_at": "2020-05-15T19:39:08.582Z",
        "ancestry": null,
        "children": [
            {
                "id": 12,
                "name": "Bilgisayar",
                "created_at": "2020-05-15T19:39:20.163Z",
                "updated_at": "2020-05-15T19:39:20.163Z",
                "ancestry": "11",
                "children": []
            },
            {
                "id": 13,
                "name": "Telefon",
                "created_at": "2020-05-15T19:39:25.595Z",
                "updated_at": "2020-05-15T19:39:25.595Z",
                "ancestry": "11",
                "children": [
                    {
                        "id": 14,
                        "name": "Akıllı Telefon",
                        "created_at": "2020-05-15T19:39:34.211Z",
                        "updated_at": "2020-05-15T19:39:34.211Z",
                        "ancestry": "11/13",
                        "children": []
                    },
                    {
                        "id": 15,
                        "name": "Tablet",
                        "created_at": "2020-05-15T19:39:43.302Z",
                        "updated_at": "2020-05-15T19:39:43.302Z",
                        "ancestry": "11/13",
                        "children": [
                            {
                                "id": 16,
                                "name": "Mini Tablet",
                                "created_at": "2020-05-15T19:39:48.519Z",
                                "updated_at": "2020-05-15T19:39:48.519Z",
                                "ancestry": "11/13/15",
                                "children": []
                            }
                        ]
                    }
                ]
            }
        ]
    },
    {
        "id": 17,
        "name": "Mini Tablet2",
        "created_at": "2020-05-15T19:40:07.944Z",
        "updated_at": "2020-05-15T19:40:07.944Z",
        "ancestry": null,
        "children": []
    },
    {
        "id": 18,
        "name": "Outdoor",
        "created_at": "2020-05-15T19:42:40.690Z",
        "updated_at": "2020-05-15T19:42:40.690Z",
        "ancestry": null,
        "children": []
    }
]
```
Eğer belli bir kategorinin altını arıyorsanız:

```
#!json
{
	"name": "Telefon"
}
```
Şeklinde bir gönderi yapıp aşağıdaki gibi bir çıktı alırsınız:

```
#!json
[
    {
        "id": 13,
        "name": "Telefon",
        "created_at": "2020-05-15T19:39:25.595Z",
        "updated_at": "2020-05-15T19:39:25.595Z",
        "ancestry": "11",
        "children": [
            {
                "id": 14,
                "name": "Akıllı Telefon",
                "created_at": "2020-05-15T19:39:34.211Z",
                "updated_at": "2020-05-15T19:39:34.211Z",
                "ancestry": "11/13",
                "children": []
            },
            {
                "id": 15,
                "name": "Tablet",
                "created_at": "2020-05-15T19:39:43.302Z",
                "updated_at": "2020-05-15T19:39:43.302Z",
                "ancestry": "11/13",
                "children": [
                    {
                        "id": 16,
                        "name": "Mini Tablet",
                        "created_at": "2020-05-15T19:39:48.519Z",
                        "updated_at": "2020-05-15T19:39:48.519Z",
                        "ancestry": "11/13/15",
                        "children": []
                    }
                ]
            }
        ]
    }
]
```

## **Follow** ##
Bir ürünü takip etmek için **localhost:3000/api/products/<product_id>/follow** adresine **POST** methodu ile boş bir body göndermeniz yeterli. Örnek adres: **localhost:3000/api/products/iphone-x/follow**

```
#!json
{
    "id": 1,
    "user_id": 1,
    "product_id": 9,
    "update_notif": 1,
    "created_at": "2020-05-16T11:44:13.064Z",
    "updated_at": "2020-05-16T11:44:13.064Z"
}
```
Bu şekilde bir body dönecektir fakat bunu dikkate almayınız. Kullanmanıza gerek yok.
## **Notifications** ##
Bildirimleri almak için **localhost:3000/api/notifications** adresine **GET** methodu ile erişmeniz yeterlidir. Alacağınız çıktı aşağıdaki gibidir. (Ürün adı ve son bildirimlere bakma tarihinden bu yana gelen yeni yorumlar)

```
#!json
{
    "Iphone X": 1
}
```
# **Search** #
Ürün aramak için **localhost:3000/api/products/search** adresine **POST** methodu ile aşağıdaki gibi bir json göndermeniz gereklidir:


```
#!json
{
	"search": "iphone"
}
```
Alacağınız çıktı aşağıdaki gibidir.(ürünler kategorilerden önce oluşturulduğu için kategoriler null gözüküyor)
```
#!json

[
    {
        "id": 3,
        "title": "Iphone 5s",
        "approval": true,
        "age_restriction": false,
        "created_at": "2020-04-10T22:46:56.985Z",
        "updated_at": "2020-04-11T21:51:18.987Z",
        "slug": "iphone-5s",
        "category": null
    },
    {
        "id": 4,
        "title": "Iphone 5",
        "approval": false,
        "age_restriction": false,
        "created_at": "2020-04-10T22:46:59.413Z",
        "updated_at": "2020-04-10T22:46:59.413Z",
        "slug": "iphone-5",
        "category": null
    },
    {
        "id": 5,
        "title": "Iphone 6",
        "approval": false,
        "age_restriction": false,
        "created_at": "2020-04-10T22:47:04.671Z",
        "updated_at": "2020-04-10T22:47:04.671Z",
        "slug": "iphone-6",
        "category": null
    },
    {
        "id": 6,
        "title": "Iphone 6s",
        "approval": false,
        "age_restriction": false,
        "created_at": "2020-04-10T22:47:06.484Z",
        "updated_at": "2020-04-10T22:47:06.484Z",
        "slug": "iphone-6s",
        "category": null
    },
    {
        "id": 7,
        "title": "Iphone 6s",
        "approval": false,
        "age_restriction": false,
        "created_at": "2020-04-10T23:00:54.153Z",
        "updated_at": "2020-04-10T23:00:54.153Z",
        "slug": "iphone-6s-c6626d91-c1e3-47bb-9819-8b0d937a4d29",
        "category": null
    },
    {
        "id": 8,
        "title": "Iphone X",
        "approval": true,
        "age_restriction": false,
        "created_at": "2020-04-21T16:53:17.764Z",
        "updated_at": "2020-04-22T09:10:07.435Z",
        "slug": "iphone-x",
        "category": null
    },
    {
        "id": 9,
        "title": "Iphone XI",
        "approval": false,
        "age_restriction": false,
        "created_at": "2020-05-16T11:05:19.551Z",
        "updated_at": "2020-05-16T11:05:19.551Z",
        "slug": "iphone-xi",
        "category": "Akıllı Telefon"
    }
]
```
## **Search by Category** ##
Kategori bazlı arama için **localhost:3000/api/products/search_by_category** adresine **POST** methodu ile aşağıdaki gibi bir json göndermeniz gerekiyor:

```
#!json
{
	"category": "Telefon"
}
```
Alacağınız cevap aşağıdaki gibi olacaktır(herokuda bu ürünler yok, ekleyip denemeniz gerek. Veya image ve ratings de sorun olabilir, onlar da ürünler rating ve image den önce oluşturulduğu için):

```
#!json
{
    "products": [
        {
            "product": {
                "id": 9,
                "title": "Iphone XI",
                "approval": false,
                "age_restriction": false,
                "created_at": "2020-05-16T11:05:19.551Z",
                "updated_at": "2020-05-16T11:05:19.551Z",
                "slug": "iphone-xi",
                "category": "Akıllı Telefon"
            },
            "images": [],
            "ratings": {
                "overall": 4.96875,
                "particularly": {
                    "Kamera": 5.5,
                    "Performans": 5.0,
                    "Fiyat/Performans": 7.0,
                    "Batarya": 4.5
                }
            }
        },
        {
            "product": {
                "id": 10,
                "title": "Telefonx5",
                "approval": false,
                "age_restriction": false,
                "created_at": "2020-05-16T13:17:41.170Z",
                "updated_at": "2020-05-16T13:17:41.170Z",
                "slug": "telefonx5",
                "category": "Telefon"
            },
            "images": [],
            "ratings": {
                "overall": 0,
                "particularly": {}
            }
        },
        {
            "product": {
                "id": 15,
                "title": "Telefonx10",
                "approval": false,
                "age_restriction": false,
                "created_at": "2020-05-16T13:56:17.556Z",
                "updated_at": "2020-05-16T13:56:17.594Z",
                "slug": "telefonx10",
                "category": "Telefon"
            },
            "images": [
                {
                    "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--ad82b68dc7b11abd00ef44b9931d343f628c33c8/coffee%20mug.png"
                },
                {
                    "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--b6b74acef5940d39fca40436d42ff6a814f919c5/furnitures.png"
                }
            ],
            "ratings": {
                "overall": 0,
                "particularly": {}
            }
        },
        {
            "product": {
                "id": 24,
                "title": "Iphone XX",
                "approval": false,
                "age_restriction": false,
                "created_at": "2020-05-29T09:35:31.369Z",
                "updated_at": "2020-05-29T09:35:31.432Z",
                "slug": "iphone-xx",
                "category": "Telefon"
            },
            "images": [
                {
                    "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBFUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--84ea488afb061e64b837446e5c543aac9c3f27ba/4w5tEawk_400x400.jpg"
                },
                {
                    "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBFZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--e32a2d76e7b5e601b0e4b2b9010fd9a8c64cca25/333.png"
                },
                {
                    "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBFdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--882bb70c8dd593d5cd5119a86705b36285c64575/4w5tEawk_400x400.jpg"
                },
                {
                    "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBGQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--dbcb70b673ab7835fdd3c802649cb4c5699c6fa9/333.png"
                }
            ],
            "ratings": {
                "overall": 6.34375,
                "particularly": {
                    "Kamera": 6.5,
                    "Performans": 3.5,
                    "Fiyat/Performans": 9.0,
                    "Batarya": 6.5
                }
            }
        }
    ]
}
```
