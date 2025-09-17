// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Brands`
  String get Brands {
    return Intl.message('Brands', name: 'Brands', desc: '', args: []);
  }

  /// `Most Sold`
  String get Most_Sold {
    return Intl.message('Most Sold', name: 'Most_Sold', desc: '', args: []);
  }

  /// `Highend Brand`
  String get Highend_Brand {
    return Intl.message(
      'Highend Brand',
      name: 'Highend_Brand',
      desc: '',
      args: [],
    );
  }

  /// `I have accepted the`
  String get terms1 {
    return Intl.message(
      'I have accepted the',
      name: 'terms1',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get terms2 {
    return Intl.message(
      'Terms and Conditions',
      name: 'terms2',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get Gender {
    return Intl.message('Gender', name: 'Gender', desc: '', args: []);
  }

  /// `Male`
  String get Male {
    return Intl.message('Male', name: 'Male', desc: '', args: []);
  }

  /// `Female`
  String get Female {
    return Intl.message('Female', name: 'Female', desc: '', args: []);
  }

  /// `verification code`
  String get verification_code {
    return Intl.message(
      'verification code',
      name: 'verification_code',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a verification code to your phone`
  String get sent_verification {
    return Intl.message(
      'We have sent a verification code to your phone',
      name: 'sent_verification',
      desc: '',
      args: [],
    );
  }

  /// `Resend the code`
  String get Resend_code {
    return Intl.message(
      'Resend the code',
      name: 'Resend_code',
      desc: '',
      args: [],
    );
  }

  /// `has been changed Successfully`
  String get changed {
    return Intl.message(
      'has been changed Successfully',
      name: 'changed',
      desc: '',
      args: [],
    );
  }

  /// `verification`
  String get verification {
    return Intl.message(
      'verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `Code Send Successfully`
  String get send_code_success {
    return Intl.message(
      'Code Send Successfully',
      name: 'send_code_success',
      desc: '',
      args: [],
    );
  }

  /// `Verify your Number`
  String get Verify_your_Number {
    return Intl.message(
      'Verify your Number',
      name: 'Verify_your_Number',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password`
  String get Forget_Password {
    return Intl.message(
      'Forget Password',
      name: 'Forget_Password',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get Phone {
    return Intl.message('Phone', name: 'Phone', desc: '', args: []);
  }

  /// `Enter your number`
  String get Enter_your_number {
    return Intl.message(
      'Enter your number',
      name: 'Enter_your_number',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get SignIn {
    return Intl.message('Sign In', name: 'SignIn', desc: '', args: []);
  }

  /// `Sign in to your account to enjoy a unique shopping experience on the Asteco Store and get more features`
  String get SignIn_title {
    return Intl.message(
      'Sign in to your account to enjoy a unique shopping experience on the Asteco Store and get more features',
      name: 'SignIn_title',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get User_Name {
    return Intl.message('User Name', name: 'User_Name', desc: '', args: []);
  }

  /// `Enter your user name`
  String get Enter_user {
    return Intl.message(
      'Enter your user name',
      name: 'Enter_user',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message('Password', name: 'Password', desc: '', args: []);
  }

  /// `Enter your password`
  String get Enter_password {
    return Intl.message(
      'Enter your password',
      name: 'Enter_password',
      desc: '',
      args: [],
    );
  }

  /// `you are not verfied`
  String get not_verfied {
    return Intl.message(
      'you are not verfied',
      name: 'not_verfied',
      desc: '',
      args: [],
    );
  }

  /// `dont Have Account!?`
  String get dont_Have_Account {
    return Intl.message(
      'dont Have Account!?',
      name: 'dont_Have_Account',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get Create_Account {
    return Intl.message(
      'Create Account',
      name: 'Create_Account',
      desc: '',
      args: [],
    );
  }

  /// `Signup`
  String get Signup {
    return Intl.message('Signup', name: 'Signup', desc: '', args: []);
  }

  /// `First Name`
  String get First_Name {
    return Intl.message('First Name', name: 'First_Name', desc: '', args: []);
  }

  /// `Last Name`
  String get Last_Name {
    return Intl.message('Last Name', name: 'Last_Name', desc: '', args: []);
  }

  /// `Next`
  String get Next {
    return Intl.message('Next', name: 'Next', desc: '', args: []);
  }

  /// `Cart`
  String get Cart {
    return Intl.message('Cart', name: 'Cart', desc: '', args: []);
  }

  /// `Your Cart Is Empty`
  String get Cart_Empty {
    return Intl.message(
      'Your Cart Is Empty',
      name: 'Cart_Empty',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get Total {
    return Intl.message('Total', name: 'Total', desc: '', args: []);
  }

  /// `Discount Value`
  String get Discount_Value {
    return Intl.message(
      'Discount Value',
      name: 'Discount_Value',
      desc: '',
      args: [],
    );
  }

  /// `Enter the Promocode`
  String get Enter_Code {
    return Intl.message(
      'Enter the Promocode',
      name: 'Enter_Code',
      desc: '',
      args: [],
    );
  }

  /// `Apply Code`
  String get Apply_Code {
    return Intl.message('Apply Code', name: 'Apply_Code', desc: '', args: []);
  }

  /// `Net Total: `
  String get Net_Total {
    return Intl.message('Net Total: ', name: 'Net_Total', desc: '', args: []);
  }

  /// `Pay`
  String get Pay {
    return Intl.message('Pay', name: 'Pay', desc: '', args: []);
  }

  /// `Note the delivery fees to Baghdad 5000 provinces 8000`
  String get cart_note {
    return Intl.message(
      'Note the delivery fees to Baghdad 5000 provinces 8000',
      name: 'cart_note',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get Confirm {
    return Intl.message('Confirm', name: 'Confirm', desc: '', args: []);
  }

  /// `Home`
  String get Home {
    return Intl.message('Home', name: 'Home', desc: '', args: []);
  }

  /// `Offers`
  String get Offers {
    return Intl.message('Offers', name: 'Offers', desc: '', args: []);
  }

  /// `My Cart`
  String get My_Cart {
    return Intl.message('My Cart', name: 'My_Cart', desc: '', args: []);
  }

  /// `Wishlist`
  String get Wishlist {
    return Intl.message('Wishlist', name: 'Wishlist', desc: '', args: []);
  }

  /// `Category`
  String get Shopping {
    return Intl.message('Category', name: 'Shopping', desc: '', args: []);
  }

  /// `Settings`
  String get Settings {
    return Intl.message('Settings', name: 'Settings', desc: '', args: []);
  }

  /// `Search`
  String get Search {
    return Intl.message('Search', name: 'Search', desc: '', args: []);
  }

  /// `YAY! YOU ARE HERE`
  String get YOU_ARE_HERE {
    return Intl.message(
      'YAY! YOU ARE HERE',
      name: 'YOU_ARE_HERE',
      desc: '',
      args: [],
    );
  }

  /// `Hi, Beauteful!`
  String get Hi {
    return Intl.message('Hi, Beauteful!', name: 'Hi', desc: '', args: []);
  }

  /// `Discover`
  String get Discover {
    return Intl.message('Discover', name: 'Discover', desc: '', args: []);
  }

  /// `My WishList`
  String get My_WishList {
    return Intl.message('My WishList', name: 'My_WishList', desc: '', args: []);
  }

  /// `Remove all`
  String get remove {
    return Intl.message('Remove all', name: 'remove', desc: '', args: []);
  }

  /// `My Orders`
  String get My_Orders {
    return Intl.message('My Orders', name: 'My_Orders', desc: '', args: []);
  }

  /// `Favorite`
  String get Favorite {
    return Intl.message('Favorite', name: 'Favorite', desc: '', args: []);
  }

  /// `Change Password`
  String get Change_Password {
    return Intl.message(
      'Change Password',
      name: 'Change_Password',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get About {
    return Intl.message('About', name: 'About', desc: '', args: []);
  }

  /// `Contact Us`
  String get Contact_Us {
    return Intl.message('Contact Us', name: 'Contact_Us', desc: '', args: []);
  }

  /// `Old Password`
  String get Old_password {
    return Intl.message(
      'Old Password',
      name: 'Old_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get Confirm_Password {
    return Intl.message(
      'Confirm Password',
      name: 'Confirm_Password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your confirmed password`
  String get Enter_confirmed_password {
    return Intl.message(
      'Enter your confirmed password',
      name: 'Enter_confirmed_password',
      desc: '',
      args: [],
    );
  }

  /// `your password has been added successfully`
  String get password_successfully {
    return Intl.message(
      'your password has been added successfully',
      name: 'password_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Save {
    return Intl.message('Save', name: 'Save', desc: '', args: []);
  }

  /// `English`
  String get English {
    return Intl.message('English', name: 'English', desc: '', args: []);
  }

  /// `Arabic`
  String get Arabic {
    return Intl.message('Arabic', name: 'Arabic', desc: '', args: []);
  }

  /// `Email`
  String get Email {
    return Intl.message('Email', name: 'Email', desc: '', args: []);
  }

  /// `Logout`
  String get Logout {
    return Intl.message('Logout', name: 'Logout', desc: '', args: []);
  }

  /// `Try Again`
  String get try_again {
    return Intl.message('Try Again', name: 'try_again', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Original 100%`
  String get Original {
    return Intl.message('Original 100%', name: 'Original', desc: '', args: []);
  }

  /// `click here to see more product of this brand`
  String get click_here {
    return Intl.message(
      'click here to see more product of this brand',
      name: 'click_here',
      desc: '',
      args: [],
    );
  }

  /// `Colors `
  String get Colors {
    return Intl.message('Colors ', name: 'Colors', desc: '', args: []);
  }

  /// `how use it`
  String get how_use_it {
    return Intl.message('how use it', name: 'how_use_it', desc: '', args: []);
  }

  /// `specifications`
  String get specifications {
    return Intl.message(
      'specifications',
      name: 'specifications',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get Reviews {
    return Intl.message('Reviews', name: 'Reviews', desc: '', args: []);
  }

  /// `Add To Cart`
  String get Add_To_Cart {
    return Intl.message('Add To Cart', name: 'Add_To_Cart', desc: '', args: []);
  }

  /// `Product added to cart`
  String get Product_added {
    return Intl.message(
      'Product added to cart',
      name: 'Product_added',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while searching. Try again.`
  String get error_search {
    return Intl.message(
      'An error occurred while searching. Try again.',
      name: 'error_search',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get Reset {
    return Intl.message('Reset', name: 'Reset', desc: '', args: []);
  }

  /// `Apply`
  String get Apply {
    return Intl.message('Apply', name: 'Apply', desc: '', args: []);
  }

  /// `Sort`
  String get Sort {
    return Intl.message('Sort', name: 'Sort', desc: '', args: []);
  }

  /// `Price Range`
  String get Price_Range {
    return Intl.message('Price Range', name: 'Price_Range', desc: '', args: []);
  }

  /// `Min`
  String get Min {
    return Intl.message('Min', name: 'Min', desc: '', args: []);
  }

  /// `Max`
  String get Max {
    return Intl.message('Max', name: 'Max', desc: '', args: []);
  }

  /// `Price`
  String get Price {
    return Intl.message('Price', name: 'Price', desc: '', args: []);
  }

  /// `Discount`
  String get Discount {
    return Intl.message('Discount', name: 'Discount', desc: '', args: []);
  }

  /// `Confirm deletion`
  String get Confirm_deletion {
    return Intl.message(
      'Confirm deletion',
      name: 'Confirm_deletion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete?`
  String get Confirm_deletion_title {
    return Intl.message(
      'Are you sure you want to delete?',
      name: 'Confirm_deletion_title',
      desc: '',
      args: [],
    );
  }

  /// `Cancle`
  String get Cancle {
    return Intl.message('Cancle', name: 'Cancle', desc: '', args: []);
  }

  /// `Delete`
  String get Delete {
    return Intl.message('Delete', name: 'Delete', desc: '', args: []);
  }

  /// `profile`
  String get profile {
    return Intl.message('profile', name: 'profile', desc: '', args: []);
  }

  /// `Orders`
  String get Orders {
    return Intl.message('Orders', name: 'Orders', desc: '', args: []);
  }

  /// `Products you might like`
  String get Products_might_like {
    return Intl.message(
      'Products you might like',
      name: 'Products_might_like',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Beautiful!`
  String get Welcome_Beautiful {
    return Intl.message(
      'Welcome Beautiful!',
      name: 'Welcome_Beautiful',
      desc: '',
      args: [],
    );
  }

  /// `Current Orders`
  String get Current_Orders {
    return Intl.message(
      'Current Orders',
      name: 'Current_Orders',
      desc: '',
      args: [],
    );
  }

  /// `Previous Orders`
  String get Previous_Orders {
    return Intl.message(
      'Previous Orders',
      name: 'Previous_Orders',
      desc: '',
      args: [],
    );
  }

  /// `Order Number:`
  String get Order_Number {
    return Intl.message(
      'Order Number:',
      name: 'Order_Number',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get Color {
    return Intl.message('Color', name: 'Color', desc: '', args: []);
  }

  /// `Delivery Charges`
  String get Delivery_Charges {
    return Intl.message(
      'Delivery Charges',
      name: 'Delivery_Charges',
      desc: '',
      args: [],
    );
  }

  /// `Service Fees`
  String get Service_Fees {
    return Intl.message(
      'Service Fees',
      name: 'Service_Fees',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get Total_Amount {
    return Intl.message(
      'Total Amount',
      name: 'Total_Amount',
      desc: '',
      args: [],
    );
  }

  /// `Sort by discount`
  String get Sort_by_discount {
    return Intl.message(
      'Sort by discount',
      name: 'Sort_by_discount',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Price Desc`
  String get Sort_Price_Desc {
    return Intl.message(
      'Sort by Price Desc',
      name: 'Sort_Price_Desc',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Price Ask`
  String get Sort_Price_Ask {
    return Intl.message(
      'Sort by Price Ask',
      name: 'Sort_Price_Ask',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Address`
  String get Enter_address {
    return Intl.message(
      'Enter your Address',
      name: 'Enter_address',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get Checkout {
    return Intl.message('Checkout', name: 'Checkout', desc: '', args: []);
  }

  /// `Pay through`
  String get Pay_through {
    return Intl.message('Pay through', name: 'Pay_through', desc: '', args: []);
  }

  /// `Cash payment`
  String get Cash_payment {
    return Intl.message(
      'Cash payment',
      name: 'Cash_payment',
      desc: '',
      args: [],
    );
  }

  /// `Payment Summary`
  String get Payment_Summary {
    return Intl.message(
      'Payment Summary',
      name: 'Payment_Summary',
      desc: '',
      args: [],
    );
  }

  /// `Submet`
  String get Submet {
    return Intl.message('Submet', name: 'Submet', desc: '', args: []);
  }

  /// `Please Login First`
  String get Please_Login_First {
    return Intl.message(
      'Please Login First',
      name: 'Please_Login_First',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get Success {
    return Intl.message('Success', name: 'Success', desc: '', args: []);
  }

  /// `fill field`
  String get fill_field {
    return Intl.message('fill field', name: 'fill_field', desc: '', args: []);
  }

  /// `must be same as password`
  String get must_same_password {
    return Intl.message(
      'must be same as password',
      name: 'must_same_password',
      desc: '',
      args: [],
    );
  }

  /// `The code entered is incorrect, please try again.`
  String get code_incorrect {
    return Intl.message(
      'The code entered is incorrect, please try again.',
      name: 'code_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Addres`
  String get Shipping_Addres {
    return Intl.message(
      'Shipping Addres',
      name: 'Shipping_Addres',
      desc: '',
      args: [],
    );
  }

  /// `the promocode Actived Successfly`
  String get promocode_Successfly {
    return Intl.message(
      'the promocode Actived Successfly',
      name: 'promocode_Successfly',
      desc: '',
      args: [],
    );
  }

  /// `OTP Code Verification`
  String get OTP_Code_Verification {
    return Intl.message(
      'OTP Code Verification',
      name: 'OTP_Code_Verification',
      desc: '',
      args: [],
    );
  }

  /// `choose one of the methods beloow to get the OTP code.`
  String get choose_methods {
    return Intl.message(
      'choose one of the methods beloow to get the OTP code.',
      name: 'choose_methods',
      desc: '',
      args: [],
    );
  }

  /// `OTP Sended Success via WhatsApp`
  String get OTP_Sended_WhatsApp {
    return Intl.message(
      'OTP Sended Success via WhatsApp',
      name: 'OTP_Sended_WhatsApp',
      desc: '',
      args: [],
    );
  }

  /// `Send via WhatsApp`
  String get Send_via_WhatsApp {
    return Intl.message(
      'Send via WhatsApp',
      name: 'Send_via_WhatsApp',
      desc: '',
      args: [],
    );
  }

  /// `OTP Sended Success via SMS`
  String get OTP_Sended_SMS {
    return Intl.message(
      'OTP Sended Success via SMS',
      name: 'OTP_Sended_SMS',
      desc: '',
      args: [],
    );
  }

  /// `Send via SMS`
  String get Send_via_SMS {
    return Intl.message(
      'Send via SMS',
      name: 'Send_via_SMS',
      desc: '',
      args: [],
    );
  }

  /// `if nothing is chossen in 3 seconds, the code will be sent automatically vis WhatsApp`
  String get nothing_sent_automatically {
    return Intl.message(
      'if nothing is chossen in 3 seconds, the code will be sent automatically vis WhatsApp',
      name: 'nothing_sent_automatically',
      desc: '',
      args: [],
    );
  }

  /// `Registration Successful`
  String get Registration_Successful {
    return Intl.message(
      'Registration Successful',
      name: 'Registration_Successful',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Code`
  String get Wrong_Code {
    return Intl.message('Wrong Code', name: 'Wrong_Code', desc: '', args: []);
  }

  /// `All Product`
  String get all_product {
    return Intl.message('All Product', name: 'all_product', desc: '', args: []);
  }

  /// `Some Thing went Wrong`
  String get Some_Wrong {
    return Intl.message(
      'Some Thing went Wrong',
      name: 'Some_Wrong',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get product_name {
    return Intl.message(
      'Product Name',
      name: 'product_name',
      desc: '',
      args: [],
    );
  }

  /// `Please complete your order first`
  String get Please_complete_your_order_first {
    return Intl.message(
      'Please complete your order first',
      name: 'Please_complete_your_order_first',
      desc: '',
      args: [],
    );
  }

  /// `Governorate`
  String get Governorate {
    return Intl.message('Governorate', name: 'Governorate', desc: '', args: []);
  }

  /// `Enter Governorate`
  String get enter_Governorate {
    return Intl.message(
      'Enter Governorate',
      name: 'enter_Governorate',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get Region {
    return Intl.message('Region', name: 'Region', desc: '', args: []);
  }

  /// `Enter Region`
  String get enter_Region {
    return Intl.message(
      'Enter Region',
      name: 'enter_Region',
      desc: '',
      args: [],
    );
  }

  /// `Nearest place`
  String get Nearest_place {
    return Intl.message(
      'Nearest place',
      name: 'Nearest_place',
      desc: '',
      args: [],
    );
  }

  /// `Enter the nearest point of reference to you`
  String get enter_Nearest_place {
    return Intl.message(
      'Enter the nearest point of reference to you',
      name: 'enter_Nearest_place',
      desc: '',
      args: [],
    );
  }

  /// `You can adjust the location of the buttons by pressing and holding and dragging them wherever you want`
  String get location_buttons {
    return Intl.message(
      'You can adjust the location of the buttons by pressing and holding and dragging them wherever you want',
      name: 'location_buttons',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Phone Numbet!`
  String get Invalid_login {
    return Intl.message(
      'Invalid Phone Numbet!',
      name: 'Invalid_login',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get enter_valid_number {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'enter_valid_number',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get confirm_password_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'confirm_password_not_match',
      desc: '',
      args: [],
    );
  }

  /// `old password not match`
  String get old_password_not_match {
    return Intl.message(
      'old password not match',
      name: 'old_password_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to`
  String get welcome_to {
    return Intl.message('Welcome to', name: 'welcome_to', desc: '', args: []);
  }

  /// `Residents' application`
  String get residents_application {
    return Intl.message(
      'Residents\' application',
      name: 'residents_application',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the phone number associated with your residential unit to log in to the application.`
  String get enter_phone_residential {
    return Intl.message(
      'Please enter the phone number associated with your residential unit to log in to the application.',
      name: 'enter_phone_residential',
      desc: '',
      args: [],
    );
  }

  /// `Send verification code`
  String get send_verification_code {
    return Intl.message(
      'Send verification code',
      name: 'send_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Enter verification code`
  String get enter_verification_code {
    return Intl.message(
      'Enter verification code',
      name: 'enter_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code sent to the number`
  String get enter_verification_code_sent_number {
    return Intl.message(
      'Enter the verification code sent to the number',
      name: 'enter_verification_code_sent_number',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive a message?`
  String get didnt_receive_message {
    return Intl.message(
      'Didn\'t receive a message?',
      name: 'didnt_receive_message',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message('Services', name: 'services', desc: '', args: []);
  }

  /// `My dues`
  String get my_dues {
    return Intl.message('My dues', name: 'my_dues', desc: '', args: []);
  }

  /// `Owner`
  String get owner {
    return Intl.message('Owner', name: 'owner', desc: '', args: []);
  }

  /// `Total dues`
  String get total_dues {
    return Intl.message('Total dues', name: 'total_dues', desc: '', args: []);
  }

  /// `Payment deadline`
  String get payment_deadline {
    return Intl.message(
      'Payment deadline',
      name: 'payment_deadline',
      desc: '',
      args: [],
    );
  }

  /// `agriculture`
  String get agriculture {
    return Intl.message('agriculture', name: 'agriculture', desc: '', args: []);
  }

  /// `maintenance`
  String get maintenance {
    return Intl.message('maintenance', name: 'maintenance', desc: '', args: []);
  }

  /// `paint`
  String get paint {
    return Intl.message('paint', name: 'paint', desc: '', args: []);
  }

  /// `electrical`
  String get electrical {
    return Intl.message('electrical', name: 'electrical', desc: '', args: []);
  }

  /// `Cleaning`
  String get cleaning {
    return Intl.message('Cleaning', name: 'cleaning', desc: '', args: []);
  }

  /// `See everything`
  String get See_more {
    return Intl.message('See everything', name: 'See_more', desc: '', args: []);
  }

  /// `IQD`
  String get IQD {
    return Intl.message('IQD', name: 'IQD', desc: '', args: []);
  }

  /// `welcome`
  String get welcome {
    return Intl.message('welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Change Language`
  String get Change_Language {
    return Intl.message(
      'Change Language',
      name: 'Change_Language',
      desc: '',
      args: [],
    );
  }

  /// `My previous requests`
  String get my_previous_requests {
    return Intl.message(
      'My previous requests',
      name: 'my_previous_requests',
      desc: '',
      args: [],
    );
  }

  /// `Track all your previous orders`
  String get track_your_previous_orders {
    return Intl.message(
      'Track all your previous orders',
      name: 'track_your_previous_orders',
      desc: '',
      args: [],
    );
  }

  /// `Unit details`
  String get unit_details {
    return Intl.message(
      'Unit details',
      name: 'unit_details',
      desc: '',
      args: [],
    );
  }

  /// `Area, building, and floor information`
  String get area_building_floor_information {
    return Intl.message(
      'Area, building, and floor information',
      name: 'area_building_floor_information',
      desc: '',
      args: [],
    );
  }

  /// `Edit information`
  String get edit_information {
    return Intl.message(
      'Edit information',
      name: 'edit_information',
      desc: '',
      args: [],
    );
  }

  /// `Update your personal data`
  String get update_your_personal_data {
    return Intl.message(
      'Update your personal data',
      name: 'update_your_personal_data',
      desc: '',
      args: [],
    );
  }

  /// `My financial dues`
  String get financial_dues {
    return Intl.message(
      'My financial dues',
      name: 'financial_dues',
      desc: '',
      args: [],
    );
  }

  /// `View invoices and amounts due`
  String get view_invoices_and_amounts_due {
    return Intl.message(
      'View invoices and amounts due',
      name: 'view_invoices_and_amounts_due',
      desc: '',
      args: [],
    );
  }

  /// `Renter`
  String get renter {
    return Intl.message('Renter', name: 'renter', desc: '', args: []);
  }

  /// `Unity`
  String get unity {
    return Intl.message('Unity', name: 'unity', desc: '', args: []);
  }

  /// `Building`
  String get building {
    return Intl.message('Building', name: 'building', desc: '', args: []);
  }

  /// `Floor`
  String get floor {
    return Intl.message('Floor', name: 'floor', desc: '', args: []);
  }

  /// `Choosing an apartment`
  String get choosing_apartment {
    return Intl.message(
      'Choosing an apartment',
      name: 'choosing_apartment',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get document_notifications {
    return Intl.message(
      'Notifications',
      name: 'document_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get Appearance {
    return Intl.message('Appearance', name: 'Appearance', desc: '', args: []);
  }

  /// `Light mode`
  String get Light_mode {
    return Intl.message('Light mode', name: 'Light_mode', desc: '', args: []);
  }

  /// `Change appearance`
  String get Change_appearance {
    return Intl.message(
      'Change appearance',
      name: 'Change_appearance',
      desc: '',
      args: [],
    );
  }

  /// `Default mode`
  String get default_mode {
    return Intl.message(
      'Default mode',
      name: 'default_mode',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get Dark_Mode {
    return Intl.message('Dark mode', name: 'Dark_Mode', desc: '', args: []);
  }

  /// `Invoices`
  String get invoices {
    return Intl.message('Invoices', name: 'invoices', desc: '', args: []);
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Paid`
  String get Paid {
    return Intl.message('Paid', name: 'Paid', desc: '', args: []);
  }

  /// `unpaid`
  String get unpaid {
    return Intl.message('unpaid', name: 'unpaid', desc: '', args: []);
  }

  /// `Pending`
  String get Pending {
    return Intl.message('Pending', name: 'Pending', desc: '', args: []);
  }

  /// `Support`
  String get Support {
    return Intl.message('Support', name: 'Support', desc: '', args: []);
  }

  /// `Complaints`
  String get Complaints {
    return Intl.message('Complaints', name: 'Complaints', desc: '', args: []);
  }

  /// `Submit Complaint`
  String get Submit_complaint {
    return Intl.message(
      'Submit Complaint',
      name: 'Submit_complaint',
      desc: '',
      args: [],
    );
  }

  /// `Complaint Description`
  String get Complaint_description {
    return Intl.message(
      'Complaint Description',
      name: 'Complaint_description',
      desc: '',
      args: [],
    );
  }

  /// `Priority`
  String get Priority {
    return Intl.message('Priority', name: 'Priority', desc: '', args: []);
  }

  /// `High`
  String get High {
    return Intl.message('High', name: 'High', desc: '', args: []);
  }

  /// `Medium`
  String get Medium {
    return Intl.message('Medium', name: 'Medium', desc: '', args: []);
  }

  /// `Low`
  String get Low {
    return Intl.message('Low', name: 'Low', desc: '', args: []);
  }

  /// `Status`
  String get Status {
    return Intl.message('Status', name: 'Status', desc: '', args: []);
  }

  /// `In Progress`
  String get In_Progress {
    return Intl.message('In Progress', name: 'In_Progress', desc: '', args: []);
  }

  /// `Resolved`
  String get Resolved {
    return Intl.message('Resolved', name: 'Resolved', desc: '', args: []);
  }

  /// `Submit`
  String get Submit {
    return Intl.message('Submit', name: 'Submit', desc: '', args: []);
  }

  /// `My Complaints`
  String get My_complaints {
    return Intl.message(
      'My Complaints',
      name: 'My_complaints',
      desc: '',
      args: [],
    );
  }

  /// `View Complaints`
  String get View_complaints {
    return Intl.message(
      'View Complaints',
      name: 'View_complaints',
      desc: '',
      args: [],
    );
  }

  /// `Track your submitted complaints`
  String get track_your_submitted_complaints {
    return Intl.message(
      'Track your submitted complaints',
      name: 'track_your_submitted_complaints',
      desc: '',
      args: [],
    );
  }

  /// `Complaint submitted successfully`
  String get Complaint_submitted_successfully {
    return Intl.message(
      'Complaint submitted successfully',
      name: 'Complaint_submitted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Enter complaint description`
  String get Enter_complaint_description {
    return Intl.message(
      'Enter complaint description',
      name: 'Enter_complaint_description',
      desc: '',
      args: [],
    );
  }

  /// `Select priority`
  String get Select_priority {
    return Intl.message(
      'Select priority',
      name: 'Select_priority',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get Reply {
    return Intl.message('Reply', name: 'Reply', desc: '', args: []);
  }

  /// `Admin Reply`
  String get Admin_reply {
    return Intl.message('Admin Reply', name: 'Admin_reply', desc: '', args: []);
  }

  /// `No reply yet`
  String get No_reply_yet {
    return Intl.message(
      'No reply yet',
      name: 'No_reply_yet',
      desc: '',
      args: [],
    );
  }

  /// `My Vehicle`
  String get My_Vehicle {
    return Intl.message('My Vehicle', name: 'My_Vehicle', desc: '', args: []);
  }

  /// `My documents`
  String get My_documents {
    return Intl.message(
      'My documents',
      name: 'My_documents',
      desc: '',
      args: [],
    );
  }

  /// `My weapons`
  String get Possession_weapons {
    return Intl.message(
      'My weapons',
      name: 'Possession_weapons',
      desc: '',
      args: [],
    );
  }

  /// `residential units`
  String get residential_units {
    return Intl.message(
      'residential units',
      name: 'residential_units',
      desc: '',
      args: [],
    );
  }

  /// `Personal information`
  String get Personal_information {
    return Intl.message(
      'Personal information',
      name: 'Personal_information',
      desc: '',
      args: [],
    );
  }

  /// `family members`
  String get family_members {
    return Intl.message(
      'family members',
      name: 'family_members',
      desc: '',
      args: [],
    );
  }

  /// `What service are you looking for?`
  String get What_service_looking {
    return Intl.message(
      'What service are you looking for?',
      name: 'What_service_looking',
      desc: '',
      args: [],
    );
  }

  /// `You can choose the look that suits you for a comfortable user experience. Select your preferred style from the options below.`
  String get choose_look {
    return Intl.message(
      'You can choose the look that suits you for a comfortable user experience. Select your preferred style from the options below.',
      name: 'choose_look',
      desc: '',
      args: [],
    );
  }

  /// `You can choose the language that suits you for a better experience within the app. Select your preferred language from the options below.`
  String get choose_language {
    return Intl.message(
      'You can choose the language that suits you for a better experience within the app. Select your preferred language from the options below.',
      name: 'choose_language',
      desc: '',
      args: [],
    );
  }

  /// `Invoice number`
  String get Invoice_number {
    return Intl.message(
      'Invoice number',
      name: 'Invoice_number',
      desc: '',
      args: [],
    );
  }

  /// `Payment status:`
  String get Payment_status {
    return Intl.message(
      'Payment status:',
      name: 'Payment_status',
      desc: '',
      args: [],
    );
  }

  /// `Release date`
  String get Release_date {
    return Intl.message(
      'Release date',
      name: 'Release_date',
      desc: '',
      args: [],
    );
  }

  /// `due date`
  String get due_date {
    return Intl.message('due date', name: 'due_date', desc: '', args: []);
  }

  /// `Invoice details`
  String get Invoice_details {
    return Intl.message(
      'Invoice details',
      name: 'Invoice_details',
      desc: '',
      args: [],
    );
  }

  /// `Payment history`
  String get Payment_history {
    return Intl.message(
      'Payment history',
      name: 'Payment_history',
      desc: '',
      args: [],
    );
  }

  /// `Service:`
  String get Service {
    return Intl.message('Service:', name: 'Service', desc: '', args: []);
  }

  /// `Cleaning the residential unit`
  String get Cleaning_residential_unit {
    return Intl.message(
      'Cleaning the residential unit',
      name: 'Cleaning_residential_unit',
      desc: '',
      args: [],
    );
  }

  /// `Service history:`
  String get Service_history {
    return Intl.message(
      'Service history:',
      name: 'Service_history',
      desc: '',
      args: [],
    );
  }

  /// `Number of working hours:`
  String get Number_working_hours {
    return Intl.message(
      'Number of working hours:',
      name: 'Number_working_hours',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get hours {
    return Intl.message('hours', name: 'hours', desc: '', args: []);
  }

  /// `Quantity rate:`
  String get Quantity_rate {
    return Intl.message(
      'Quantity rate:',
      name: 'Quantity_rate',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal:`
  String get Subtotal {
    return Intl.message('Subtotal:', name: 'Subtotal', desc: '', args: []);
  }

  /// `Additional fees:`
  String get Additional_fees {
    return Intl.message(
      'Additional fees:',
      name: 'Additional_fees',
      desc: '',
      args: [],
    );
  }

  /// `Paid:`
  String get the_Paid {
    return Intl.message('Paid:', name: 'the_Paid', desc: '', args: []);
  }

  /// `residual:`
  String get residual {
    return Intl.message('residual:', name: 'residual', desc: '', args: []);
  }

  /// `Notes:`
  String get Notes {
    return Intl.message('Notes:', name: 'Notes', desc: '', args: []);
  }

  /// `Track Booking`
  String get Track_Booking {
    return Intl.message(
      'Track Booking',
      name: 'Track_Booking',
      desc: '',
      args: [],
    );
  }

  /// `Back to Homepage`
  String get Back_Homepage {
    return Intl.message(
      'Back to Homepage',
      name: 'Back_Homepage',
      desc: '',
      args: [],
    );
  }

  /// `The request has been sent successfully.`
  String get request_sent_successfully {
    return Intl.message(
      'The request has been sent successfully.',
      name: 'request_sent_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Cleaning includes floors and bathrooms using the user's cleaning tools, the appointment is set by the user at 10:00 PM.`
  String get Cleaning_includes_floors {
    return Intl.message(
      'Cleaning includes floors and bathrooms using the user\'s cleaning tools, the appointment is set by the user at 10:00 PM.',
      name: 'Cleaning_includes_floors',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to log out of your account? You can log back in at any time without losing your data.`
  String get logout_note {
    return Intl.message(
      'Do you want to log out of your account? You can log back in at any time without losing your data.',
      name: 'logout_note',
      desc: '',
      args: [],
    );
  }

  /// `Service reservation`
  String get Service_reservation {
    return Intl.message(
      'Service reservation',
      name: 'Service_reservation',
      desc: '',
      args: [],
    );
  }

  /// `About the service`
  String get About_service {
    return Intl.message(
      'About the service',
      name: 'About_service',
      desc: '',
      args: [],
    );
  }

  /// `Add another person`
  String get Add_another_person {
    return Intl.message(
      'Add another person',
      name: 'Add_another_person',
      desc: '',
      args: [],
    );
  }

  /// `details`
  String get details {
    return Intl.message('details', name: 'details', desc: '', args: []);
  }

  /// `Year of manufacture`
  String get Year_manufacture {
    return Intl.message(
      'Year of manufacture',
      name: 'Year_manufacture',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get Full_name {
    return Intl.message('Full name', name: 'Full_name', desc: '', args: []);
  }

  /// `family name`
  String get family_name {
    return Intl.message('family name', name: 'family_name', desc: '', args: []);
  }

  /// `birth date`
  String get birth_date {
    return Intl.message('birth date', name: 'birth_date', desc: '', args: []);
  }

  /// `Relationship with the unit owner`
  String get Relationship_with_owner {
    return Intl.message(
      'Relationship with the unit owner',
      name: 'Relationship_with_owner',
      desc: '',
      args: [],
    );
  }

  /// `Profession`
  String get Profession {
    return Intl.message('Profession', name: 'Profession', desc: '', args: []);
  }

  /// `workplace`
  String get workplace {
    return Intl.message('workplace', name: 'workplace', desc: '', args: []);
  }

  /// `Mother's name`
  String get Mother_name {
    return Intl.message(
      'Mother\'s name',
      name: 'Mother_name',
      desc: '',
      args: [],
    );
  }

  /// `Mother's title`
  String get Mother_title {
    return Intl.message(
      'Mother\'s title',
      name: 'Mother_title',
      desc: '',
      args: [],
    );
  }

  /// `Individual details`
  String get Individual_details {
    return Intl.message(
      'Individual details',
      name: 'Individual_details',
      desc: '',
      args: [],
    );
  }

  /// `Number of family members`
  String get Number_family_members {
    return Intl.message(
      'Number of family members',
      name: 'Number_family_members',
      desc: '',
      args: [],
    );
  }

  /// `Phone number - 1`
  String get Phone_number_1 {
    return Intl.message(
      'Phone number - 1',
      name: 'Phone_number_1',
      desc: '',
      args: [],
    );
  }

  /// `Phone number - 2`
  String get Phone_number_2 {
    return Intl.message(
      'Phone number - 2',
      name: 'Phone_number_2',
      desc: '',
      args: [],
    );
  }

  /// `Current profession`
  String get Current_profession {
    return Intl.message(
      'Current profession',
      name: 'Current_profession',
      desc: '',
      args: [],
    );
  }

  /// `Current workplace`
  String get Current_workplace {
    return Intl.message(
      'Current workplace',
      name: 'Current_workplace',
      desc: '',
      args: [],
    );
  }

  /// `Work before 2003`
  String get Work_before {
    return Intl.message(
      'Work before 2003',
      name: 'Work_before',
      desc: '',
      args: [],
    );
  }

  /// `Work after 2003`
  String get Work_after {
    return Intl.message(
      'Work after 2003',
      name: 'Work_after',
      desc: '',
      args: [],
    );
  }

  /// `Civil Events`
  String get Civil_Events {
    return Intl.message(
      'Civil Events',
      name: 'Civil_Events',
      desc: '',
      args: [],
    );
  }

  /// `Military Events`
  String get Military_Events {
    return Intl.message(
      'Military Events',
      name: 'Military_Events',
      desc: '',
      args: [],
    );
  }

  /// `Residence card number`
  String get Residence_card_number {
    return Intl.message(
      'Residence card number',
      name: 'Residence_card_number',
      desc: '',
      args: [],
    );
  }

  /// `Ration card number`
  String get Ration_card_number {
    return Intl.message(
      'Ration card number',
      name: 'Ration_card_number',
      desc: '',
      args: [],
    );
  }

  /// `National number`
  String get National_number {
    return Intl.message(
      'National number',
      name: 'National_number',
      desc: '',
      args: [],
    );
  }

  /// `Front side of the national card`
  String get Front_side_national_card {
    return Intl.message(
      'Front side of the national card',
      name: 'Front_side_national_card',
      desc: '',
      args: [],
    );
  }

  /// `Back side of the national card`
  String get Back_side_national_card {
    return Intl.message(
      'Back side of the national card',
      name: 'Back_side_national_card',
      desc: '',
      args: [],
    );
  }

  /// `Residence card`
  String get Residence_card {
    return Intl.message(
      'Residence card',
      name: 'Residence_card',
      desc: '',
      args: [],
    );
  }

  /// `Weapon type`
  String get Weapon_type {
    return Intl.message('Weapon type', name: 'Weapon_type', desc: '', args: []);
  }

  /// `ID number`
  String get ID_number {
    return Intl.message('ID number', name: 'ID_number', desc: '', args: []);
  }

  /// `Effective Date`
  String get Effective_Date {
    return Intl.message(
      'Effective Date',
      name: 'Effective_Date',
      desc: '',
      args: [],
    );
  }

  /// `Add a new car`
  String get Add_new_car {
    return Intl.message(
      'Add a new car',
      name: 'Add_new_car',
      desc: '',
      args: [],
    );
  }

  /// `Add a new weapon`
  String get Add_new_weapon {
    return Intl.message(
      'Add a new weapon',
      name: 'Add_new_weapon',
      desc: '',
      args: [],
    );
  }

  /// `Weapon name`
  String get Weapon_name {
    return Intl.message('Weapon name', name: 'Weapon_name', desc: '', args: []);
  }

  /// `Owner's name`
  String get Owner_name {
    return Intl.message(
      'Owner\'s name',
      name: 'Owner_name',
      desc: '',
      args: [],
    );
  }

  /// `Owner's date of birth`
  String get Owner_date_birth {
    return Intl.message(
      'Owner\'s date of birth',
      name: 'Owner_date_birth',
      desc: '',
      args: [],
    );
  }

  /// `Type of leave`
  String get Type_of_leave {
    return Intl.message(
      'Type of leave',
      name: 'Type_of_leave',
      desc: '',
      args: [],
    );
  }

  /// `Weapon number`
  String get Weapon_number {
    return Intl.message(
      'Weapon number',
      name: 'Weapon_number',
      desc: '',
      args: [],
    );
  }

  /// `Edit information`
  String get Edit_information {
    return Intl.message(
      'Edit information',
      name: 'Edit_information',
      desc: '',
      args: [],
    );
  }

  /// `Car details`
  String get Car_details {
    return Intl.message('Car details', name: 'Car_details', desc: '', args: []);
  }

  /// `model`
  String get model {
    return Intl.message('model', name: 'model', desc: '', args: []);
  }

  /// `Brand`
  String get Brand {
    return Intl.message('Brand', name: 'Brand', desc: '', args: []);
  }

  /// `Plate number`
  String get Plate_number {
    return Intl.message(
      'Plate number',
      name: 'Plate_number',
      desc: '',
      args: [],
    );
  }

  /// `Choose the method to upload the image`
  String get Choose_method_upload_image {
    return Intl.message(
      'Choose the method to upload the image',
      name: 'Choose_method_upload_image',
      desc: '',
      args: [],
    );
  }

  /// `Select a photo from the gallery`
  String get Select_photo_gallery {
    return Intl.message(
      'Select a photo from the gallery',
      name: 'Select_photo_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Take a live photo`
  String get Take_live_photo {
    return Intl.message(
      'Take a live photo',
      name: 'Take_live_photo',
      desc: '',
      args: [],
    );
  }

  /// `Unified Card`
  String get Unified_Card {
    return Intl.message(
      'Unified Card',
      name: 'Unified_Card',
      desc: '',
      args: [],
    );
  }

  /// `Upload file`
  String get Upload_file {
    return Intl.message('Upload file', name: 'Upload_file', desc: '', args: []);
  }

  /// `Choose the type of support you need and we will help you as quickly as possible.`
  String get Choose_type_support {
    return Intl.message(
      'Choose the type of support you need and we will help you as quickly as possible.',
      name: 'Choose_type_support',
      desc: '',
      args: [],
    );
  }

  /// `Contact support`
  String get Contact_support {
    return Intl.message(
      'Contact support',
      name: 'Contact_support',
      desc: '',
      args: [],
    );
  }

  /// `We are here to serve you 24 hours a day, 7 days a week.`
  String get We_here_serve_you {
    return Intl.message(
      'We are here to serve you 24 hours a day, 7 days a week.',
      name: 'We_here_serve_you',
      desc: '',
      args: [],
    );
  }

  /// `We are here to answer your questions and assist you directly at any time.`
  String get We_here_answer {
    return Intl.message(
      'We are here to answer your questions and assist you directly at any time.',
      name: 'We_here_answer',
      desc: '',
      args: [],
    );
  }

  /// `Frequently Asked Questions`
  String get Frequently_Asked_Questions {
    return Intl.message(
      'Frequently Asked Questions',
      name: 'Frequently_Asked_Questions',
      desc: '',
      args: [],
    );
  }

  /// `Find answers to the most frequently asked questions about using the app and the services available.`
  String get Find_answers_asked {
    return Intl.message(
      'Find answers to the most frequently asked questions about using the app and the services available.',
      name: 'Find_answers_asked',
      desc: '',
      args: [],
    );
  }

  /// `Place of birth`
  String get Place_birth {
    return Intl.message(
      'Place of birth',
      name: 'Place_birth',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Upload documents`
  String get Upload_documents {
    return Intl.message(
      'Upload documents',
      name: 'Upload_documents',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get Back {
    return Intl.message('Back', name: 'Back', desc: '', args: []);
  }

  /// `Car`
  String get car {
    return Intl.message('Car', name: 'car', desc: '', args: []);
  }

  /// `Add another car +`
  String get Add_another_car {
    return Intl.message(
      'Add another car +',
      name: 'Add_another_car',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle type`
  String get Vehicle_type {
    return Intl.message(
      'Vehicle type',
      name: 'Vehicle_type',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle model`
  String get Vehicle_model {
    return Intl.message(
      'Vehicle model',
      name: 'Vehicle_model',
      desc: '',
      args: [],
    );
  }

  /// `Residents' form`
  String get Residents_form {
    return Intl.message(
      'Residents\' form',
      name: 'Residents_form',
      desc: '',
      args: [],
    );
  }

  /// `Other information`
  String get Other_information {
    return Intl.message(
      'Other information',
      name: 'Other_information',
      desc: '',
      args: [],
    );
  }

  /// `Previous residence information`
  String get Previous_residence_information {
    return Intl.message(
      'Previous residence information',
      name: 'Previous_residence_information',
      desc: '',
      args: [],
    );
  }

  /// `judiciary`
  String get judiciary {
    return Intl.message('judiciary', name: 'judiciary', desc: '', args: []);
  }

  /// `side`
  String get side {
    return Intl.message('side', name: 'side', desc: '', args: []);
  }

  /// `neighborhood`
  String get neighborhood {
    return Intl.message(
      'neighborhood',
      name: 'neighborhood',
      desc: '',
      args: [],
    );
  }

  /// `alley`
  String get alley {
    return Intl.message('alley', name: 'alley', desc: '', args: []);
  }

  /// `House number`
  String get House_number {
    return Intl.message(
      'House number',
      name: 'House_number',
      desc: '',
      args: [],
    );
  }

  /// `Edit Information`
  String get edit_car_information {
    return Intl.message(
      'Edit Information',
      name: 'edit_car_information',
      desc: '',
      args: [],
    );
  }

  /// `Weapon Details`
  String get weapon_details {
    return Intl.message(
      'Weapon Details',
      name: 'weapon_details',
      desc: '',
      args: [],
    );
  }

  /// `Add a New Weapon`
  String get add_weapon {
    return Intl.message(
      'Add a New Weapon',
      name: 'add_weapon',
      desc: '',
      args: [],
    );
  }

  /// `Add Family Member`
  String get add_family_member {
    return Intl.message(
      'Add Family Member',
      name: 'add_family_member',
      desc: '',
      args: [],
    );
  }

  /// `Son`
  String get son {
    return Intl.message('Son', name: 'son', desc: '', args: []);
  }

  /// `Daughter`
  String get daughter {
    return Intl.message('Daughter', name: 'daughter', desc: '', args: []);
  }

  /// `Spouse`
  String get spouse {
    return Intl.message('Spouse', name: 'spouse', desc: '', args: []);
  }

  /// `Father`
  String get father {
    return Intl.message('Father', name: 'father', desc: '', args: []);
  }

  /// `Mother`
  String get mother {
    return Intl.message('Mother', name: 'mother', desc: '', args: []);
  }

  /// `Brother`
  String get brother {
    return Intl.message('Brother', name: 'brother', desc: '', args: []);
  }

  /// `Current Governorate`
  String get current_governorate {
    return Intl.message(
      'Current Governorate',
      name: 'current_governorate',
      desc: '',
      args: [],
    );
  }

  /// `Displacement or Forced Eviction`
  String get Displacement_status {
    return Intl.message(
      'Displacement or Forced Eviction',
      name: 'Displacement_status',
      desc: '',
      args: [],
    );
  }

  /// `Arrested or Imprisoned`
  String get Prison_status {
    return Intl.message(
      'Arrested or Imprisoned',
      name: 'Prison_status',
      desc: '',
      args: [],
    );
  }

  /// `Approved by National Security`
  String get Security_approval {
    return Intl.message(
      'Approved by National Security',
      name: 'Security_approval',
      desc: '',
      args: [],
    );
  }

  /// `Owns a Weapon`
  String get Own_weapon {
    return Intl.message(
      'Owns a Weapon',
      name: 'Own_weapon',
      desc: '',
      args: [],
    );
  }

  /// `Form Completed`
  String get Form_filled {
    return Intl.message(
      'Form Completed',
      name: 'Form_filled',
      desc: '',
      args: [],
    );
  }

  /// `Download the file`
  String get Download_file {
    return Intl.message(
      'Download the file',
      name: 'Download_file',
      desc: '',
      args: [],
    );
  }

  /// `Permission Denied`
  String get permission_denied {
    return Intl.message(
      'Permission Denied',
      name: 'permission_denied',
      desc: '',
      args: [],
    );
  }

  /// `file downloaded successfully`
  String get file_downloaded_successfully {
    return Intl.message(
      'file downloaded successfully',
      name: 'file_downloaded_successfully',
      desc: '',
      args: [],
    );
  }

  /// `download failed`
  String get download_failed {
    return Intl.message(
      'download failed',
      name: 'download_failed',
      desc: '',
      args: [],
    );
  }

  /// `Date of receipt`
  String get Date_receipt {
    return Intl.message(
      'Date of receipt',
      name: 'Date_receipt',
      desc: '',
      args: [],
    );
  }

  /// `Duration of residence`
  String get Duration_residence {
    return Intl.message(
      'Duration of residence',
      name: 'Duration_residence',
      desc: '',
      args: [],
    );
  }

  /// `status`
  String get status {
    return Intl.message('status', name: 'status', desc: '', args: []);
  }

  /// `approved`
  String get approved {
    return Intl.message('approved', name: 'approved', desc: '', args: []);
  }

  /// `rejected`
  String get rejected {
    return Intl.message('rejected', name: 'rejected', desc: '', args: []);
  }

  /// `Quantity`
  String get Quantity {
    return Intl.message('Quantity', name: 'Quantity', desc: '', args: []);
  }

  /// `alert !`
  String get alert {
    return Intl.message('alert !', name: 'alert', desc: '', args: []);
  }

  /// `Please fill out the residents' form.`
  String get Please_fill_residents_form {
    return Intl.message(
      'Please fill out the residents\' form.',
      name: 'Please_fill_residents_form',
      desc: '',
      args: [],
    );
  }

  /// `Fill out the form`
  String get Fill_out_form {
    return Intl.message(
      'Fill out the form',
      name: 'Fill_out_form',
      desc: '',
      args: [],
    );
  }

  /// `landlord`
  String get landlord {
    return Intl.message('landlord', name: 'landlord', desc: '', args: []);
  }

  /// `Plate Type`
  String get plate_Type {
    return Intl.message('Plate Type', name: 'plate_Type', desc: '', args: []);
  }

  /// `residential block`
  String get residential_block {
    return Intl.message(
      'residential block',
      name: 'residential_block',
      desc: '',
      args: [],
    );
  }

  /// `Partially paid`
  String get Partially_paid {
    return Intl.message(
      'Partially paid',
      name: 'Partially_paid',
      desc: '',
      args: [],
    );
  }

  /// `fron side`
  String get fornt_side {
    return Intl.message('fron side', name: 'fornt_side', desc: '', args: []);
  }

  /// `back side`
  String get back_side {
    return Intl.message('back side', name: 'back_side', desc: '', args: []);
  }

  /// `Unified Card or passport`
  String get National_ID_passport {
    return Intl.message(
      'Unified Card or passport',
      name: 'National_ID_passport',
      desc: '',
      args: [],
    );
  }

  /// `Residential card`
  String get Residential_card {
    return Intl.message(
      'Residential card',
      name: 'Residential_card',
      desc: '',
      args: [],
    );
  }

  /// `Select the residential complex`
  String get Select_residential_complex {
    return Intl.message(
      'Select the residential complex',
      name: 'Select_residential_complex',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR Code:`
  String get Scan_qr_code {
    return Intl.message(
      'Scan QR Code:',
      name: 'Scan_qr_code',
      desc: '',
      args: [],
    );
  }

  /// `Open QR Scanner:`
  String get Open_qr_scanner {
    return Intl.message(
      'Open QR Scanner:',
      name: 'Open_qr_scanner',
      desc: '',
      args: [],
    );
  }

  /// `Failed to verify the code:`
  String get Failed_to_verify_code {
    return Intl.message(
      'Failed to verify the code:',
      name: 'Failed_to_verify_code',
      desc: '',
      args: [],
    );
  }

  /// `Visitor:`
  String get Visitor {
    return Intl.message('Visitor:', name: 'Visitor', desc: '', args: []);
  }

  /// `Customer Details:`
  String get Customer_details {
    return Intl.message(
      'Customer Details:',
      name: 'Customer_details',
      desc: '',
      args: [],
    );
  }

  /// `Compound Name:`
  String get Compound_name {
    return Intl.message(
      'Compound Name:',
      name: 'Compound_name',
      desc: '',
      args: [],
    );
  }

  /// `Visitor Details:`
  String get Visitor_details {
    return Intl.message(
      'Visitor Details:',
      name: 'Visitor_details',
      desc: '',
      args: [],
    );
  }

  /// `Type:`
  String get Type {
    return Intl.message('Type:', name: 'Type', desc: '', args: []);
  }

  /// `Appartment:`
  String get Appartment {
    return Intl.message('Appartment:', name: 'Appartment', desc: '', args: []);
  }

  /// `Visitors`
  String get Visitors {
    return Intl.message('Visitors', name: 'Visitors', desc: '', args: []);
  }

  /// `Visit Date From:`
  String get Visit_date_from {
    return Intl.message(
      'Visit Date From:',
      name: 'Visit_date_from',
      desc: '',
      args: [],
    );
  }

  /// `Visit Date To:`
  String get Visit_date_to {
    return Intl.message(
      'Visit Date To:',
      name: 'Visit_date_to',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get Active {
    return Intl.message('Active', name: 'Active', desc: '', args: []);
  }

  /// `Inactive`
  String get Inactive {
    return Intl.message('Inactive', name: 'Inactive', desc: '', args: []);
  }

  /// `Share QR Code:`
  String get Share_qr_code {
    return Intl.message(
      'Share QR Code:',
      name: 'Share_qr_code',
      desc: '',
      args: [],
    );
  }

  /// `Add Visitor`
  String get Add_visitor {
    return Intl.message('Add Visitor', name: 'Add_visitor', desc: '', args: []);
  }

  /// `Visitor Name:`
  String get Visitor_name {
    return Intl.message(
      'Visitor Name:',
      name: 'Visitor_name',
      desc: '',
      args: [],
    );
  }

  /// `Share this QR code with the visitor`
  String get Share_qr_with_visitor {
    return Intl.message(
      'Share this QR code with the visitor',
      name: 'Share_qr_with_visitor',
      desc: '',
      args: [],
    );
  }

  /// `guest`
  String get guest {
    return Intl.message('guest', name: 'guest', desc: '', args: []);
  }

  /// `technician`
  String get technician {
    return Intl.message('technician', name: 'technician', desc: '', args: []);
  }

  /// `expired`
  String get expired {
    return Intl.message('expired', name: 'expired', desc: '', args: []);
  }

  /// `deactivated`
  String get deactivated {
    return Intl.message('deactivated', name: 'deactivated', desc: '', args: []);
  }

  /// `qr code scan time`
  String get qr_code_scan_time {
    return Intl.message(
      'qr code scan time',
      name: 'qr_code_scan_time',
      desc: '',
      args: [],
    );
  }

  /// `scanned By`
  String get scanned_By {
    return Intl.message('scanned By', name: 'scanned_By', desc: '', args: []);
  }

  /// `Vehicle information`
  String get Vehicle_information {
    return Intl.message(
      'Vehicle information',
      name: 'Vehicle_information',
      desc: '',
      args: [],
    );
  }

  /// `Gate`
  String get Gate {
    return Intl.message('Gate', name: 'Gate', desc: '', args: []);
  }

  /// `Visit details`
  String get Visit_details {
    return Intl.message(
      'Visit details',
      name: 'Visit_details',
      desc: '',
      args: [],
    );
  }

  /// `Visitor type`
  String get Visitor_type {
    return Intl.message(
      'Visitor type',
      name: 'Visitor_type',
      desc: '',
      args: [],
    );
  }

  /// `Rejection Reason`
  String get rejection_Reason {
    return Intl.message(
      'Rejection Reason',
      name: 'rejection_Reason',
      desc: '',
      args: [],
    );
  }

  /// `closed`
  String get closed {
    return Intl.message('closed', name: 'closed', desc: '', args: []);
  }

  /// `Customer Information`
  String get Customer_Information {
    return Intl.message(
      'Customer Information',
      name: 'Customer_Information',
      desc: '',
      args: [],
    );
  }

  /// `Complaint Image`
  String get Complaint_Image {
    return Intl.message(
      'Complaint Image',
      name: 'Complaint_Image',
      desc: '',
      args: [],
    );
  }

  /// `Timeline`
  String get Timeline {
    return Intl.message('Timeline', name: 'Timeline', desc: '', args: []);
  }

  /// `Created`
  String get Created {
    return Intl.message('Created', name: 'Created', desc: '', args: []);
  }

  /// `Complaint submitted by customer`
  String get Complaint_submitted_by_customer {
    return Intl.message(
      'Complaint submitted by customer',
      name: 'Complaint_submitted_by_customer',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get Updated {
    return Intl.message('Updated', name: 'Updated', desc: '', args: []);
  }

  /// `Complaint status updated`
  String get Complaint_status_updated {
    return Intl.message(
      'Complaint status updated',
      name: 'Complaint_status_updated',
      desc: '',
      args: [],
    );
  }

  /// `Admin provided response`
  String get Admin_provided_response {
    return Intl.message(
      'Admin provided response',
      name: 'Admin_provided_response',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
