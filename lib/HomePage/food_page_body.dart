import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/popular_product_controller.dart';
import '../ModelClass/food_model.dart';
import '../Widgets/big_text.dart';
import '../Widgets/dimensions.dart';
import '../Widgets/icon_text_widget.dart';
import '../Widgets/small_text.dart';
import '../pages/app_column.dart';
import '../pages/recommended_food_page.dart';
import '../pages/popular_food_page.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.86);
  var _currentPageValue = 0.0;
  double _scalefactor = 0.8;

  //  data for recommended foods (slider)
  final List<FoodItem> recommendedFoods = [
    FoodItem(
      name: "Korean Spicy Glazed Chicken",
      description: "An authentic Korean culinary masterpiece featuring premium chicken pieces that have been double-fried using traditional Korean techniques to achieve the ultimate textural perfection. Each morsel begins with tender, free-range chicken thighs and drumettes, carefully marinated for 12 hours in a blend of soy sauce, rice wine, garlic, and ginger to infuse deep savory flavors throughout the meat. The chicken is first fried at a lower temperature to cook through completely, then fried again at high heat to create an incredibly crispy, golden-brown exterior that shatters with each bite while revealing succulent, juicy meat within. The signature glaze is a complex symphony of flavors - a reduction of Korean gochujang (fermented chili paste), premium soy sauce, rice vinegar, brown sugar, sesame oil, and aromatic spices including star anise and Korean pear juice for natural sweetness. This glossy, lacquer-like coating caramelizes beautifully during the final tossing process, creating sticky, finger-licking goodness. Garnished with toasted sesame seeds, finely chopped scallions, and a sprinkle of Korean chili flakes for an extra kick of heat and visual appeal. Served with pickled radish cubes to cleanse the palate between bites.",
      imagePath: "assets/images/food1.jpg",
      price: 1520.0,
      category: "Korean",
      distance: "2.8 km",
      time: "32 min",
      quality: "Excellent",
    ),
    FoodItem(
      name: "Traditional Masala Dosa",
      description: "A legendary South Indian delicacy that represents centuries of culinary tradition, featuring an enormous, paper-thin crepe made from a perfectly fermented batter of premium basmati rice and black gram dal (urad dal) that has been soaked, ground, and naturally fermented for 8-12 hours to develop complex flavors and achieve the ideal consistency. The batter is skillfully spread on a seasoned cast-iron griddle (tawa) using a circular motion, creating a lace-like, golden crepe that spans nearly two feet in diameter. The dosa is cooked until it achieves a beautiful golden-brown color with crispy edges while maintaining a soft, pliable center. The filling consists of a generous portion of spiced potato curry (aloo sabzi) prepared with boiled potatoes, mustard seeds, curry leaves, green chilies, ginger, turmeric, and aromatic spices, slow-cooked until the potatoes absorb all the flavors and achieve a creamy texture. Accompanied by sambar - a tangy, spicy lentil soup made with toor dal, tamarind, tomatoes, drumsticks, okra, and a special blend of sambar powder containing roasted spices. Also served with three varieties of chutneys: coconut chutney made with fresh coconut, green chilies, and ginger; tomato chutney with caramelized onions and curry leaves; and mint-coriander chutney for a fresh, herbaceous contrast. The entire meal is served on a traditional banana leaf for authentic presentation and enhanced flavor.",
      imagePath: "assets/images/food2.jpg",
      price: 1200.0,
      category: "Indian",
      distance: "1.5 km",
      time: "25 min",
      quality: "Premium",
    ),
    FoodItem(
      name: "Korean Spicy Ramen",
      description: "A soul-warming bowl of traditional Korean ramyeon featuring fresh, hand-pulled noodles with the perfect chewy texture (known as 'al dente' in Korean cooking), swimming in an intensely flavorful, fiery red broth that has been simmered for hours to achieve maximum depth and complexity. The broth base begins with a rich chicken and pork bone stock, slow-cooked for 12+ hours until it becomes milky white and gelatinous, then enhanced with Korean gochujang (fermented red pepper paste), gochugaru (Korean red pepper flakes), fermented soybean paste (doenjang), garlic, ginger, and a secret blend of aromatic spices. The heat level is carefully balanced to provide a satisfying burn without overwhelming the other flavors. Topped generously with thin slices of tender, melt-in-your-mouth pork belly that has been braised in soy sauce, mirin, and brown sugar until it reaches perfect tenderness. A perfectly soft-boiled egg with a golden, runny yolk sits majestically in the center, adding richness and protein to the dish. Fresh vegetables include crisp bean sprouts, julienned carrots, sliced shiitake mushrooms, tender baby corn, and finely chopped scallions for color and texture contrast. Garnished with sheets of roasted seaweed (nori), sesame seeds, and a drizzle of aromatic sesame oil that creates beautiful patterns on the surface of the broth. Served with traditional Korean side dishes (banchan) including kimchi and pickled radish.",
      imagePath: "assets/images/food3.jpg",
      price: 1800.0,
      category: "Korean",
      distance: "3.2 km",
      time: "40 min",
      quality: "Superior",
    ),
    FoodItem(
      name: "Shanghai Soup Dumplings",
      description: "Exquisite handcrafted soup dumplings representing one of China's most technically challenging and beloved culinary arts, where each dumpling is a small miracle of engineering containing both solid filling and liquid broth within an impossibly thin, delicate wrapper. These xiaolongbao begin with meticulously prepared dough made from high-gluten flour, hot water, and a touch of salt, kneaded until silky smooth and rested to develop the perfect elasticity. Expert dumpling makers roll each wrapper by hand to achieve uniform thickness - thin enough to be translucent yet strong enough to contain the precious filling without breaking. The filling consists of premium ground pork shoulder mixed with finely minced fresh ginger, Shaoxing rice wine, light and dark soy sauce, sesame oil, white pepper, and chopped scallions for aromatic complexity. The magic lies in the gelatinized pork stock (made by slow-cooking pork bones, chicken carcasses, ginger, and scallions for 8+ hours, then chilling until solidified) which is diced and mixed into the meat filling. When steamed, this gelatin melts into a burst of hot, flavorful broth. Each dumpling is carefully pleated with exactly 18-20 folds in a precise spiral pattern, creating both structural integrity and visual beauty. Steamed in traditional bamboo baskets lined with cabbage leaves to prevent sticking, these dumplings emerge with silky, translucent skins and are served immediately while the broth inside is still piping hot. Accompanied by Chinkiang black vinegar mixed with julienned fresh ginger for dipping, which cuts through the richness and enhances the pork flavors.",
      imagePath: "assets/images/food4.jpg",
      price: 1350.0,
      category: "Chinese",
      distance: "2.0 km",
      time: "28 min",
      quality: "Excellent",
    ),
    FoodItem(
      name: "Japanese Artisan Donuts",
      description: "Premium Japanese-style donuts that represent the pinnacle of artisanal pastry craftsmanship, combining traditional Japanese attention to detail with modern flavor innovations. These aren't your typical American-style donuts - they're made using a special Japanese technique called 'yaki donatsu' (baked donuts) or premium fried versions using cake flour for an incredibly light, fluffy texture that's less greasy and more refined than conventional donuts. The base dough is prepared with Japanese cake flour, farm-fresh eggs, premium creamery butter, pure cane sugar, Madagascar vanilla extract, and a touch of mochi flour for that characteristic Japanese chewiness. Each donut is carefully shaped by hand and either baked in specialized molds or fried in temperature-controlled oil at precisely 340°F to achieve the perfect golden color and texture. The collection features multiple sophisticated flavors: classic glazed with a mirror-like finish made from powdered sugar and pure vanilla; matcha green tea with white chocolate drizzle and a dusting of ceremonial-grade matcha powder; black sesame with a nutty, earthy flavor and sesame seed garnish; yuzu citrus with a bright, tangy glaze made from real yuzu juice; and sakura (cherry blossom) with delicate pink glaze and crystallized sakura petals. Some varieties feature Japanese-style fillings such as smooth red bean paste (anko), custard cream infused with Japanese whisky, or seasonal fruit compotes. Each donut is individually wrapped in elegant packaging and presented in a beautiful wooden box reminiscent of traditional Japanese gift presentations. The texture is incredibly light and airy with a tender crumb that melts in your mouth, while the glazes provide the perfect balance of sweetness without being overwhelming.",
      imagePath: "assets/images/food5.jpg",
      price: 2200.0,
      category: "Japanese",
      distance: "4.1 km",
      time: "45 min",
      quality: "Premium",
    ),
  ];

  // Sample data for popular foods
  final List<FoodItem> popularFoods = [
    FoodItem(
      name: "Artisan Toast Collection",
      description: "An exquisite selection of six artisanal toast variations featuring premium ingredients on freshly baked sourdough bread. Each piece is carefully crafted with unique toppings including creamy avocado slices with a sprinkle of hemp seeds, smoked salmon with cream cheese and fresh dill, mixed berry compote with ricotta and honey drizzle, scrambled eggs with microgreens, and seasonal fruit arrangements. This nutritious breakfast collection provides a perfect balance of healthy fats, proteins, complex carbohydrates, and essential vitamins to fuel your morning with sustained energy. Made with organic, locally-sourced ingredients and served on rustic wooden boards for an authentic farm-to-table experience.",
      imagePath: "assets/images/food10.jpg",
      price: 800.0,
      category: "Breakfast",
      distance: "2.8 km",
      time: "32 min",
      quality: "Normal",
    ),
    FoodItem(
      name: "Delightful Macarons",
      description: "Indulge in the epitome of French patisserie artistry with our meticulously crafted collection of chocolate and vanilla macarons, each one a small masterpiece that represents centuries of refined baking tradition. These delicate sandwich cookies are the perfect embodiment of technical precision and culinary elegance, created using the finest ingredients and time-honored techniques passed down through generations of French pastry chefs.",
      imagePath: "assets/images/food6.jpg",
      price: 1600.0,
      category: "Dessert",
      distance: "1.9 km",
      time: "35 min",
      quality: "Premium",
    ),
    FoodItem(
      name: "Asian Fusion Delight",
      description: "A beautifully presented asian dish featuring perfectly grilled chicken steaks glazed with our signature teriyaki sauce, served over a bed of jasmine rice and accompanied by fresh steamed vegetables. This Asian-inspired creation combines traditional cooking methods with contemporary presentation, featuring fresh chicken marinated in soy sauce, mirin, ginger, and garlic for optimal flavor absorption. The dish is garnished with fresh cilantro, sesame seeds, and thinly sliced green onions, while colorful bell peppers and snap peas add both nutritional value and visual appeal. Rich in plant-based protein, fiber, and essential amino acids, this wholesome meal satisfies both vegetarians and health-conscious diners seeking authentic Asian flavors without compromising on nutrition.",
      imagePath: "assets/images/food7.jpg",
      price: 950.0,
      category: "Grilled",
      distance: "2.2 km",
      time: "20 min",
      quality: "Excellent",
    ),
    FoodItem(
      name: "Mediterranean Pizza",
      description: "A spectacular thin-crust pizza showcasing the finest Mediterranean seafood on a perfectly crispy base made from imported Italian flour and San Marzano tomatoes. This gourmet pizza features a generous topping of fresh mussels, tender calamari rings, succulent shrimp, and chunks of white fish, all sourced from sustainable fisheries. The pizza is enhanced with creamy mozzarella di bufala, fresh basil leaves, cherry tomatoes, and a drizzle of extra virgin olive oil. Capers and red onion slices add bursts of flavor, while oregano and garlic complete this coastal masterpiece. Baked in our traditional wood-fired oven at high temperatures, the crust achieves the perfect balance of crispiness and chewiness that characterizes authentic Neapolitan-style pizza.",
      imagePath: "assets/images/food8.jpg",
      price: 2500.0,
      category: "Fast Food",
      distance: "3.5 km",
      time: "50 min",
      quality: "Superior",
    ),
    FoodItem(
      name: "Butter Chicken",
      description: "An authentic Indian culinary experience featuring slow-cooked curry served with freshly baked naan bread and fragrant basmati rice. This traditional feast includes a rich, aromatic curry prepared with tender pieces of meat or vegetables (depending on your preference) simmered in a complex blend of spices including turmeric, cumin, coriander, garam masala, and cardamom. The curry base is made from scratch using onions, tomatoes, ginger, garlic, and fresh herbs, creating layers of flavor that have been perfected over generations. Accompanied by warm, pillowy naan bread baked fresh in our tandoor oven and long-grain basmati rice cooked with saffron and whole spices. This hearty meal represents the essence of Indian home cooking and hospitality.",
      imagePath: "assets/images/food9.jpg",
      price: 2100.0,
      category: "Indian",
      distance: "2.7 km",
      time: "45 min",
      quality: "Premium",
    ),
    FoodItem(
      name: "Creamy Pasta Carbonara",
      description: "A luxurious Italian pasta dish featuring al dente spaghetti tossed in a velvety carbonara sauce made from farm-fresh eggs, aged Parmigiano-Reggiano cheese, and crispy pancetta. This Roman classic is prepared using traditional techniques where the hot pasta creates a silky, creamy sauce without the use of cream. The dish begins with rendering high-quality pancetta until perfectly crispy, then combining it with a mixture of whole eggs and egg yolks whisked with freshly grated cheese and cracked black pepper. The magic happens when the hot pasta is tossed with this mixture, creating an incredibly smooth and rich sauce that coats every strand. Garnished with additional cheese, fresh herbs, and extra pancetta for texture and visual appeal.",
      imagePath: "assets/images/food11.jpg",
      price: 650.0,
      category: "Italian",
      distance: "1.8 km",
      time: "15 min",
      quality: "Excellent",
    ),
    FoodItem(
      name: "Spicy Chicken Biryani",
      description: "An aromatic and flavorful basmati rice dish layered with tender marinated chicken pieces, fragrant spices, and fresh herbs, creating the ultimate comfort food experience. This traditional biryani is prepared using the authentic dum cooking method, where partially cooked rice and spiced chicken are layered in a heavy-bottomed pot and slow-cooked together, allowing the flavors to meld perfectly. The chicken is marinated in yogurt, ginger-garlic paste, red chili powder, turmeric, and garam masala for several hours before being partially cooked with caramelized onions. The basmati rice is infused with whole spices including bay leaves, cardamom, cinnamon, and star anise. Saffron soaked in warm milk adds color and aroma, while fried onions, fresh mint, and cilantro provide layers of flavor and texture.",
      imagePath: "assets/images/food12.jpg",
      price: 1400.0,
      category: "Pakistani",
      distance: "2.4 km",
      time: "30 min",
      quality: "Premium",
    ),
    FoodItem(
      name: "Classic American Burger",
      description: "The ultimate burger experience featuring a juicy, hand-formed beef patty made from premium ground chuck, grilled to perfection and served on a toasted brioche bun with all the classic fixings. Our signature burger starts with fresh ground beef seasoned simply with salt and pepper, then grilled over high heat to create a beautiful crust while maintaining a juicy interior. The brioche bun is lightly toasted and spread with our special sauce - a blend of mayonnaise, ketchup, and secret seasonings. Topped with crisp iceberg lettuce, ripe tomato slices, red onion, and dill pickles for that authentic American diner experience. Served with a generous portion of golden, crispy French fries seasoned with sea salt and herbs. This is comfort food at its finest, representing the quintessential American dining experience.",
      imagePath: "assets/images/img.png",
      price: 1100.0,
      category: "Fast Food",
      distance: "1.6 km",
      time: "25 min",
      quality: "Excellent",
    ),
    FoodItem(
      name: "Garden Fresh Mixed Salad",
      description: "A vibrant and nutritious salad bowl packed with the freshest seasonal vegetables, crisp greens, and a variety of colorful toppings that create both visual appeal and exceptional taste. This health-conscious meal features a base of mixed organic greens including arugula, spinach, and romaine lettuce, topped with cherry tomatoes, cucumber slices, shredded carrots, red bell peppers, and red onion rings. Enhanced with protein-rich elements such as hard-boiled eggs, crumbled feta cheese, and toasted nuts or seeds for added texture and nutritional value. The salad is finished with fresh herbs like basil and parsley, and served with your choice of house-made dressings including balsamic vinaigrette, ranch, or lemon herb dressing. Perfect for health-conscious diners seeking a meal that's both satisfying and nutritionally balanced.",
      imagePath: "assets/images/img_1.png",
      price: 750.0,
      category: "Healthy",
      distance: "1.2 km",
      time: "10 min",
      quality: "Fresh",
    ),
    FoodItem(
      name: "Hearty Homestyle Soup",
      description: "A comforting bowl of slow-simmered soup that embodies the warmth and satisfaction of home cooking, prepared daily with the finest fresh ingredients and time-honored recipes. Our signature soup changes with the seasons but always maintains the same commitment to quality and flavor. Whether it's a rich chicken noodle soup with tender vegetables and herbs, a robust vegetable minestrone packed with beans and pasta, or a creamy tomato basil soup made from vine-ripened tomatoes, each bowl is crafted with care and attention to detail. The soup base is prepared using traditional stock-making techniques, simmering bones and vegetables for hours to extract maximum flavor and nutrients. Served piping hot with freshly baked crusty bread or crackers, this soul-warming dish provides comfort and nourishment in every spoonful.",
      imagePath: "assets/images/img_2.png",
      price: 500.0,
      category: "Soup",
      distance: "2.0 km",
      time: "20 min",
      quality: "Homestyle",
    ),
  ];

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // slider
        Container(
          height: 320,
          child: PageView.builder(
            controller: pageController,
            itemCount: recommendedFoods.length,
            itemBuilder: (context, position) {
              return _buildPageItem(position);
            },
          ),
        ),

        // dots
        new DotsIndicator(
          dotsCount: recommendedFoods.length,
          position: _currentPageValue,
          decorator: DotsDecorator(
            activeColor: Color(0xFF6A4C93), // Royal Plum primary
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),

        // popular
        SizedBox(height: 30,),
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(color: Color(0xFF1A1A2E), text: "Popular"), // Royal Plum text
              SizedBox(width: 10,),
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: BigText(color: Color(0xFF1A1A2E), text: "."),
              ),
              SizedBox(width: 10,),
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: SmallText(text: "Food Pairing", color: Color(0xFF1A1A2E).withOpacity(0.7)),
              ),
            ],
          ),
        ),

        // list of food and images
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: popularFoods.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PopularFoodPage(
                      foodItem: popularFoods[index],
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  children: [
                    // image container
                    Container(
                      height: 105,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white38,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(popularFoods[index].imagePath),
                        ),
                      ),
                    ),
                    // text container
                    Expanded(
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BigText(
                                color: Color(0xFF1A1A2E), // Royal Plum text
                                text: popularFoods[index].name,
                                size: 18,
                              ),
                              SizedBox(height: 5),
                              SmallText(text: popularFoods[index].category, color: Color(0xFF1A1A2E).withOpacity(0.7)),
                              SizedBox(height: 5),

                              FittedBox(
                                child: Row(
                                  children: [
                                    IconTextWidget(
                                      iconcolor: Color(0xFFF67280), // Royal Plum accent
                                      text: popularFoods[index].quality,
                                      iconData: Icons.circle_sharp,
                                    ),
                                    SizedBox(width: 8),
                                    IconTextWidget(
                                      iconcolor: Color(0xFF6A4C93), // Royal Plum primary
                                      text: popularFoods[index].distance,
                                      iconData: Icons.location_on,
                                    ),
                                    SizedBox(width: 8),
                                    IconTextWidget(
                                      iconcolor: Color(0xFFC06C84), // Royal Plum secondary
                                      text: popularFoods[index].time,
                                      iconData: Icons.access_time_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPageItem(int index) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currentPageValue.floor()) {
      var currentScale = 1-(_currentPageValue-index)*(1-_scalefactor);
      var currentTransform = 220*(1-currentScale)/2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, currentTransform, 0);
    } else if (index == _currentPageValue.floor()+1){
      var currentScale = _scalefactor+(_currentPageValue-index+1)*(1-_scalefactor);
      var currentTransform = 220*(1-currentScale)/2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, currentTransform, 0);
    } else if (index == _currentPageValue.floor()-1){
      var currentScale = 1-(_currentPageValue-index)*(1-_scalefactor);
      var currentTransform = 220*(1-currentScale)/2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, currentTransform, 0);
    } else {
      var currentScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, 220*(1-_scalefactor)/2, 0);
    }

    return Transform(
      transform: matrix,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecommendedFoodPage(
                foodItem: recommendedFoods[index],
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              height: 220,
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: index.isEven ? Color(0XFF6A4C93) : Color(0xFFC06C84), // Royal Plum colors
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(recommendedFoods[index].imagePath),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, 0),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(5, 0),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: AppColumn(text: recommendedFoods[index].name,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
