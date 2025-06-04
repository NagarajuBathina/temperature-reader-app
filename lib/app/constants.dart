import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String fahrenheitToCelsius(double fahrenheit) {
  return ((fahrenheit - 32) * 5 / 9).toString();
}

class GDPData {
  GDPData(this.temp);

  final int temp;
}

const mBackgroundColor = Color(0xFF121212);
const mBlueColor = Color(0xFF006df0);
const mGreyColor = Color(0xFFB4B0B0);
const mGreyColor2 = Color(0xFFD9D9D9);
const mTitleColor = Color(0xFF23374D);
const mSubtitleColor = Color(0xFF8E8E8E);
const mBorderColor = Color(0xFFE8E8F3);
const mFillColor = Color(0xFF1E1E1E);
const mFillColor2 = Color(0xfff2f2f2);
const mCardTitleColor = Color(0xFF2E4ECF);
const mCardSubtitleColor = mTitleColor;

const mTextColor = Color(0xFFE0E0E0);
const mHintTextColor = Color(0xFF5F5F5F);

const Color mBlackColor = Colors.black;
const Color mWhiteColor = Colors.white;

const Color mTransparent = Colors.transparent;
const mOrangeColor = Colors.orange;
const mLightPrimaryColor = Color(0xFFb3dfe1);
const mPrimaryColor = Color(0xFF03DAC6);
const mSecondaryColor = Color(0xffaf0003);
const mSuccessColor = Color(0xff20923D);
const mErrorColor = Color(0xffE50001);

const mBoxShadow = [
  BoxShadow(
    color: Color(0XFFE0E0E0),
    blurRadius: 2,
    spreadRadius: 0.1,
    offset: Offset(0.0, 2.0),
  ),
];

const double defaultPadding = 16;
const double defaultSpacing = 16;

const bgColor1 = Color(0xFFf5e6fd);
const bgColor2 = Color(0xFFe3f8fb);
const bgColor3 = Color(0xFFfee5e1);
const bgColor4 = Color(0xFFe2e8ff);
const bgColor5 = Color(0xFFE7E8ED);

const fgColor1 = Color(0xFFbd63fc);
const fgColor2 = Color(0xFF23c6d4);
const fgColor3 = Color(0xFFfe573c);
const fgColor4 = Color(0xFF6c76c4);

const darkColor1 = Color(0xFF03399c);
const darkColor2 = Color(0xFF201d47);
const darkColor3 = Color(0xFF06617d);
const darkColor4 = Color(0xFF102230);

final RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp pswdValidatorRegExp =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
final RegExp phoneValidatorRegExp = RegExp(r'^\d{10}$');
final RegExp otpValidatorRegExp = RegExp(r'^\d{6}$');
final RegExp panValidatorRegExp = RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]{1}$");
final RegExp gstValidatorRegExp =
    RegExp(r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$");

const String rupeeSymbol = "\u{20B9}";
NumberFormat numberFormat = NumberFormat('(\$###,###.##)');
String dollarSymbol = numberFormat.format(0);

String appVersion = '1.0.10+10';
String selectedEmail = '';

const List<String> countries = [
  "Afghanistan 🇦🇫",
  "Albania 🇦🇱",
  "Algeria 🇩🇿",
  "Andorra 🇦🇩",
  "Angola 🇦🇴",
  "Argentina 🇦🇷",
  "Armenia 🇦🇲",
  "Australia 🇦🇺",
  "Austria 🇦🇹",
  "Azerbaijan 🇦🇿",
  "Bahamas 🇧🇸",
  "Bahrain 🇧🇭",
  "Bangladesh 🇧🇩",
  "Barbados 🇧🇧",
  "Belarus 🇧🇾",
  "Belgium 🇧🇪",
  "Belize 🇧🇿",
  "Benin 🇧🇯",
  "Bhutan 🇧🇹",
  "Bolivia 🇧🇴",
  "Bosnia and Herzegovina 🇧🇦",
  "Botswana 🇧🇼",
  "Brazil 🇧🇷",
  "Brunei 🇧🇳",
  "Bulgaria 🇧🇬",
  "Burkina Faso 🇧🇫",
  "Burundi 🇧🇮",
  "Cabo Verde 🇨🇻",
  "Cambodia 🇰🇭",
  "Cameroon 🇨🇲",
  "Canada 🇨🇦",
  "Central African Republic 🇨🇫",
  "Chad 🇹🇩",
  "Chile 🇨🇱",
  "China 🇨🇳",
  "Colombia 🇨🇴",
  "Comoros 🇰🇲",
  "Congo (Congo-Brazzaville) 🇨🇬",
  "Costa Rica 🇨🇷",
  "Croatia 🇭🇷",
  "Cuba 🇨🇺",
  "Cyprus 🇨🇾",
  "Czechia 🇨🇿",
  "Democratic Republic of the Congo 🇨🇩",
  "Denmark 🇩🇰",
  "Djibouti 🇩🇯",
  "Dominica 🇩🇲",
  "Dominican Republic 🇩🇴",
  "Ecuador 🇪🇨",
  "Egypt 🇪🇬",
  "El Salvador 🇸🇻",
  "Equatorial Guinea 🇬🇶",
  "Eritrea 🇪🇷",
  "Estonia 🇪🇪",
  "Eswatini 🇸🇿",
  "Ethiopia 🇪🇹",
  "Fiji 🇫🇯",
  "Finland 🇫🇮",
  "France 🇫🇷",
  "Gabon 🇬🇦",
  "Gambia 🇬🇲",
  "Georgia 🇬🇪",
  "Germany 🇩🇪",
  "Ghana 🇬🇭",
  "Greece 🇬🇷",
  "Grenada 🇬🇩",
  "Guatemala 🇬🇹",
  "Guinea 🇬🇳",
  "Guinea-Bissau 🇬🇼",
  "Guyana 🇬🇾",
  "Haiti 🇭🇹",
  "Honduras 🇭🇳",
  "Hungary 🇭🇺",
  "Iceland 🇮🇸",
  "India 🇮🇳",
  "Indonesia 🇮🇩",
  "Iran 🇮🇷",
  "Iraq 🇮🇶",
  "Ireland 🇮🇪",
  "Israel 🇮🇱",
  "Italy 🇮🇹",
  "Jamaica 🇯🇲",
  "Japan 🇯🇵",
  "Jordan 🇯🇴",
  "Kazakhstan 🇰🇿",
  "Kenya 🇰🇪",
  "Kiribati 🇰🇷",
  "Kuwait 🇰🇼",
  "Kyrgyzstan 🇰🇬",
  "Laos 🇱🇦",
  "Latvia 🇱🇻",
  "Lebanon 🇱🇧",
  "Lesotho 🇱🇸",
  "Liberia 🇱🇷",
  "Libya 🇱🇾",
  "Liechtenstein 🇱🇮",
  "Lithuania 🇱🇹",
  "Luxembourg 🇱🇺",
  "Madagascar 🇲🇬",
  "Malawi 🇲🇼",
  "Malaysia 🇲🇾",
  "Maldives 🇲🇻",
  "Mali 🇲🇱",
  "Malta 🇲🇹",
  "Marshall Islands 🇲🇭",
  "Mauritania 🇲🇦",
  "Mauritius 🇲🇺",
  "Mexico 🇲🇽",
  "Micronesia 🇫🇲",
  "Moldova 🇲🇩",
  "Monaco 🇲🇨",
  "Mongolia 🇲🇳",
  "Montenegro 🇲🇪",
  "Morocco 🇲🇦",
  "Mozambique 🇲🇿",
  "Myanmar 🇲🇲",
  "Namibia 🇳🇦",
  "Nauru 🇳🇷",
  "Nepal 🇳🇵",
  "Netherlands 🇳🇱",
  "New Zealand 🇳🇿",
  "Nicaragua 🇳🇮",
  "Niger 🇳🇪",
  "Nigeria 🇳🇬",
  "North Korea 🇰🇵",
  "North Macedonia 🇲🇰",
  "Norway 🇳🇴",
  "Oman 🇴🇲",
  "Pakistan 🇵🇰",
  "Palau 🇵🇼",
  "Palestine 🇵🇸",
  "Panama 🇵🇦",
  "Papua New Guinea 🇵🇬",
  "Paraguay 🇵🇾",
  "Peru 🇵🇪",
  "Philippines 🇵🇭",
  "Poland 🇵🇱",
  "Portugal 🇵🇹",
  "Qatar 🇶🇦",
  "Romania 🇷🇴",
  "Russia 🇷🇺",
  "Rwanda 🇷🇼",
  "Saint Kitts and Nevis 🇰🇳",
  "Saint Lucia 🇱🇨",
  "Saint Vincent and the Grenadines 🇻🇨",
  "Samoa 🇼🇸",
  "San Marino 🇸🇲",
  "Sao Tome and Principe 🇸🇹",
  "Saudi Arabia 🇸🇦",
  "Senegal 🇸🇳",
  "Serbia 🇷🇸",
  "Seychelles 🇸🇨",
  "Sierra Leone 🇸🇱",
  "Singapore 🇸🇬",
  "Slovakia 🇸🇰",
  "Slovenia 🇸🇸",
  "Solomon Islands 🇸🇧",
  "Somalia 🇸🇴",
  "South Africa 🇿🇦",
  "South Korea 🇰🇷",
  "South Sudan 🇸🇸",
  "Spain 🇪🇸",
  "Sri Lanka 🇱🇰",
  "Sudan 🇸🇩",
  "Suriname 🇸🇷",
  "Sweden 🇸🇪",
  "Switzerland 🇨🇭",
  "Syria 🇸🇾",
  "Taiwan 🇹🇼",
  "Tajikistan 🇹🇯",
  "Tanzania 🇹🇿",
  "Thailand 🇹🇭",
  "Timor-Leste 🇹🇱",
  "Togo 🇹🇬",
  "Tonga 🇹🇴",
  "Trinidad and Tobago 🇹🇹",
  "Tunisia 🇹🇳",
  "Turkey 🇹🇷",
  "Turkmenistan 🇹🇲",
  "Tuvalu 🇹🇻",
  "Uganda 🇺🇬",
  "Ukraine 🇺🇦",
  "United Arab Emirates 🇦🇪",
  "United Kingdom 🇬🇧",
  "United States 🇺🇸",
  "Uruguay 🇺🇾",
  "Uzbekistan 🇺🇿",
  "Vanuatu 🇻🇺",
  "Vatican City 🇻🇦",
  "Venezuela 🇻🇪",
  "Vietnam 🇻🇳",
  "Yemen 🇾🇪",
  "Zambia 🇿🇲",
  "Zimbabwe 🇿🇼"
];
