import 'package:flutter/material.dart';

import '../enums/image_saturation.dart';
import '../enums/image_style.dart';
import '../enums/image_value.dart';

final Map<Color, String> colorMap = {
  Colors.black: "Preto",
  Colors.white: "Branco",
  Colors.red: "Vermelho",
  Colors.amber: "Âmbar",
  Colors.green: "Verde",
  Colors.blueAccent: "Azul",
  Colors.purple: "Roxo",
  Colors.indigo: "Indigo",
  Colors.teal: "Cerceta",
  Colors.orange: "Laranja",
  Colors.pink: "Rosa",
  Colors.cyan: "Ciano",
};

// https://i.pinimg.com/originals/61/c3/b1/61c3b11e7770bd68ac268d95dc6ee790.jpg
// https://animemotivation.com/wp-content/uploads/2022/05/klee-genshin-impact-anime-fanart.png
// https://img.freepik.com/vetores-premium/design-de-ilustracao-vetorial-de-personagem-de-estilo-anime-jovem-garota-de-anime-de-manga_147933-92.jpg?w=360
// https://img.freepik.com/vector-premium/diseno-ilustracion-vector-personaje-estilo-anime-chica-joven-chica-anime-manga_147933-100.jpg?w=2000
// https://wallpaperaccess.com/full/2741468.jpg
// https://img.artpal.com/23433/1-15-3-28-5-14-35m.jpg
// https://drawpaintacademy.com/wp-content/uploads/2018/06/Dan-Scott-Secrets-on-the-Lake-Overcast-Day-2016-1200W-Web.jpg
// https://www.thephotoargus.com/wp-content/uploads/2014/03/11-low-saturation-photography.jpg
// 7: "https://i.pinimg.com/originals/56/bd/57/56bd571a608112ff49aa105235ccd076.jpg",
// 8: "https://i.pinimg.com/736x/44/7e/dc/447edc28ad81369dc75a754fa82e54ae.jpg",
// 10: "https://w0.peakpx.com/wallpaper/556/856/HD-wallpaper-metamorphosis-fantasy-girl-orange-luminos-face-ross-tran-rossdraws.jpg",
// 8: "https://static.zerochan.net/Azula.full.2227329.jpg",
// 10: "https://static.zerochan.net/rossdraws.full.2236652.jpg",
// 0: "https://cdna.artstation.com/p/assets/images/images/055/955/238/20221110132828/smaller_square/rossdraws-makima-web-final.jpg?1668108508",
// 1: "https://imagecache.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/5db7bc40-3147-42ca-797c-a8fe1100ac00/width=450/376255.jpeg",
// 2: "https://64.media.tumblr.com/3098f52d522c10d35e50db9a29793585/c73f7e638a9a5a32-69/s1280x1920/7ab6808c581019fb81ec657d4c654791881a3c73.jpg",
// 3: "https://pbs.twimg.com/media/EnSgAbxUYAARbee.jpg",
// 4: "https://imagecache.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/0615e367-6e5f-4db9-78da-bb9bd68a0700/width=450/376252.jpeg",
// 5: "https://cdna.artstation.com/p/assets/covers/images/044/328/314/smaller_square/rossdraws-rossdraws-tombra3.jpg?1639680124",
// 6: "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/b013e38f-b1f0-4193-8d90-acfeae93d61a/detwz8i-5550bdcd-94be-46b6-bc8e-2d0ee6345847.jpg/v1/fill/w_700,h_1000,q_75,strp/kida_by_rossdraws_detwz8i-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTAwMCIsInBhdGgiOiJcL2ZcL2IwMTNlMzhmLWIxZjAtNDE5My04ZDkwLWFjZmVhZTkzZDYxYVwvZGV0d3o4aS01NTUwYmRjZC05NGJlLTQ2YjYtYmM4ZS0yZDBlZTYzNDU4NDcuanBnIiwid2lkdGgiOiI8PTcwMCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.Ovt2zDJW0jBLrzN3XkgN5VleLea-Px86bE4MoT8yoPs",
// 7: "https://pbs.twimg.com/media/FjzPgxlUcAA3387?format=jpg&name=large",
// 8: "https://pbs.twimg.com/media/FiWD7Z4UUAAbfxf?format=jpg&name=medium",
// 9: "https://cdna.artstation.com/p/assets/images/images/024/786/356/20200306124447/smaller_square/rossdraws-lyris-girl.jpg?1583520287",
// 10: "https://i0.wp.com/drawyourweapon.com/wp-content/uploads/2021/01/ross-tran-dreamcatcher-ewb.jpg?resize=680%2C935&ssl=1",
// 11: "https://64.media.tumblr.com/ddde0eeebebd6bb95601ea9390c63a67/tumblr_p1pcmmEGJh1r5uvbeo1_1280.jpg",

const String optionsDir = "assets/images/options";
const String placeholdersDir = "assets/images/placeholders";

final Map<Object, String> imageMapping = {
  0: "$placeholdersDir/placeholder_0.jpg",
  1: "$placeholdersDir/placeholder_1.jpeg",
  2: "$placeholdersDir/placeholder_2.jpg",
  3: "$placeholdersDir/placeholder_3.jpg",
  4: "$placeholdersDir/placeholder_4.jpeg",
  5: "$placeholdersDir/placeholder_5.jpg",
  6: "$placeholdersDir/placeholder_6.jpg",
  7: "$placeholdersDir/placeholder_7.jpg",
  8: "$placeholdersDir/placeholder_8.jpg",
  9: "$placeholdersDir/placeholder_9.jpg",
  10: "$placeholdersDir/placeholder_10.jpg",
  11: "$placeholdersDir/placeholder_11.jpg",
  ImageStyle.anime: "$optionsDir/styles/anime.jpg",
  ImageStyle.oilPainting: "$optionsDir/styles/oil_painting.jpg",
  ImageStyle.digitalArt: "$optionsDir/styles/digital_art.jpg",
  ImageStyle.model3d: "$optionsDir/styles/3d_model.webp",
  ImageStyle.photography: "$optionsDir/styles/photography.webp",
  ImageSaturation.high: "$optionsDir/saturations/high.jpg",
  ImageSaturation.low: "$optionsDir/saturations/low.jpg",
  ImageValue.high: "$optionsDir/values/high.webp",
  ImageValue.low: "$optionsDir/values/low.jpg",
};
