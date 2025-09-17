import 'package:enjaz/core/utils/Navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/features/drink/data/model/drink_model.dart';
import 'package:enjaz/features/drink/screen/coffee_detai_screen.dart';
import '../../drink/cubit/drink_cubit.dart';

final coffeeCategories = [
  'All Coffee',
  'Machiato',
  'Latte',
  'Americano',
  'Cappuccino',
];

class CoffeeAppHomeScreen extends StatefulWidget {
  const CoffeeAppHomeScreen({super.key});

  @override
  State<CoffeeAppHomeScreen> createState() => _CoffeeAppHomeScreenState();
}

class _CoffeeAppHomeScreenState extends State<CoffeeAppHomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EDE7),
      body: PaginationList<DrinkModel>(
        withRefresh: true,
        physics: const BouncingScrollPhysics(),
        noDataWidget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              'No coffee yet ☕',
              style: TextStyle(
                color: AppColors.xsecondaryColor,
                fontSize: AppFontSize.size_16,
              ),
            ),
          ),
        ),
        onCubitCreated: (cubit) {
          context.read<DrinkCubit>().drinkCubit = cubit;
        },
        repositoryCallBack: (data) {
          return context.read<DrinkCubit>().fetchAllDrinkServies(data);
        },

        listBuilder: (apiList) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  Container(
                    height: AppFontSize.size_280,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xFF111111), Color(0xFF313131)],
                      ),
                    ),
                  ),
                  headerParts(),
                ],
              ),
              SizedBox(height: AppFontSize.size_35),
              categorySelection(),
              SizedBox(height: AppFontSize.size_20),

              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: AppFontSize.size_270,
                  crossAxisSpacing: AppFontSize.size_15,
                  mainAxisSpacing: AppFontSize.size_20,
                ),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPaddingSize.padding_25,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: apiList.length,
                itemBuilder: (context, index) {
                  final api = apiList[index];
                  final tag = 'coffee-hero-${api.id}';

                  final sub = api.description;

                  final imageUrl =
                      "https://task.jasim-erp.com/api/dms/file/get/${api.id}/?entitytype=1";

                  return Container(
                    padding: const EdgeInsets.fromLTRB(
                      AppPaddingSize.padding_8,
                      AppPaddingSize.padding_8,
                      AppPaddingSize.padding_8,
                      AppPaddingSize.padding_12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppFontSize.size_15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // الصورة + الانتقال للتفاصيل
                        GestureDetector(
                          onTap: () {
                            Navigation.push(
                              CoffeeDetailScreen(heroTag: tag, drinkModel: api),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppFontSize.size_12,
                            ),
                            child: Hero(
                              tag: tag,
                              child: Image.network(
                                imageUrl,
                                height: AppFontSize.size_160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.local_cafe,
                                  size: AppFontSize.size_32,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppFontSize.size_10),

                        Text(
                          api.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSize.size_17,
                            color: AppColors.black,
                          ),
                        ),
                        if (sub != null && sub.isNotEmpty)
                          Text(
                            sub,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.xsecondaryColor),
                          ),

                        const Spacer(),

                        // === زر Add (Quick Add) ===
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(
                              AppFontSize.size_8,
                            ),
                            child: Container(
                              width: AppFontSize.size_32,
                              height: AppFontSize.size_32,
                              decoration: BoxDecoration(
                                color: AppColors.xprimaryColor,
                                borderRadius: BorderRadius.circular(
                                  AppFontSize.size_8,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: AppColors.white,
                                size: AppFontSize.size_18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

Padding headerParts() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppPaddingSize.padding_22),
    child: Column(
      children: [
        SizedBox(height: AppFontSize.size_60),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: TextStyle(color: AppColors.xsecondaryColor),
            ),
            Row(
              children: [
                const Text(
                  'Kathmandu, Nepal',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSize.size_16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: AppFontSize.size_5),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.xsecondaryColor,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppFontSize.size_25),
        Row(
          children: [
            Expanded(
              child: Container(
                height: AppFontSize.size_60,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(AppFontSize.size_12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPaddingSize.padding_15,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_search.png',
                      color: AppColors.white,
                      height: AppFontSize.size_35,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.search, color: AppColors.white),
                    ),
                    SizedBox(width: AppFontSize.size_8),
                    const Expanded(
                      child: TextField(
                        style: TextStyle(
                          fontSize: AppFontSize.size_18,
                          color: AppColors.white,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Search coffee',
                          hintStyle: TextStyle(
                            fontSize: AppFontSize.size_18,
                            color: AppColors.whiteF1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppFontSize.size_15),
            Container(
              height: AppFontSize.size_60,
              width: AppFontSize.size_55,
              decoration: BoxDecoration(
                color: AppColors.xprimaryColor,
                borderRadius: BorderRadius.circular(AppFontSize.size_12),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.tune, color: AppColors.white),
            ),
          ],
        ),
        SizedBox(height: AppFontSize.size_25),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppFontSize.size_15),
          child: Image.asset(
            'assets/images/banner.png',
            width: double.infinity,
            height: AppFontSize.size_140,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: AppFontSize.size_140,
              color: AppColors.greyE5,
            ),
          ),
        ),
      ],
    ),
  );
}

SizedBox categorySelection() {
  return SizedBox(
    height: AppFontSize.size_30,
    child: ListView.builder(
      itemCount: coffeeCategories.length,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(
              left: index == 0 ? AppFontSize.size_25 : AppFontSize.size_10,
              right: index == coffeeCategories.length - 1
                  ? AppFontSize.size_25
                  : AppFontSize.size_10,
            ),
            decoration: BoxDecoration(
              color: AppColors.xsecondaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppFontSize.size_6),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppPaddingSize.padding_10,
            ),
            alignment: Alignment.center,
            child: Text(
              coffeeCategories[index],
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: AppFontSize.size_16,
                color: AppColors.black,
              ),
            ),
          ),
        );
      },
    ),
  );
}
