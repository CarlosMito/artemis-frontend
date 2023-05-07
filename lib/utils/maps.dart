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

final Map<Object, String> imagePlaceholders = {
  0: "https://cdna.artstation.com/p/assets/images/images/055/955/238/20221110132828/smaller_square/rossdraws-makima-web-final.jpg?1668108508",
  1: "https://imagecache.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/5db7bc40-3147-42ca-797c-a8fe1100ac00/width=450/376255.jpeg",
  2: "https://64.media.tumblr.com/3098f52d522c10d35e50db9a29793585/c73f7e638a9a5a32-69/s1280x1920/7ab6808c581019fb81ec657d4c654791881a3c73.jpg",
  3: "https://pbs.twimg.com/media/EnSgAbxUYAARbee.jpg",
  4: "https://imagecache.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/0615e367-6e5f-4db9-78da-bb9bd68a0700/width=450/376252.jpeg",
  5: "https://cdna.artstation.com/p/assets/covers/images/044/328/314/smaller_square/rossdraws-rossdraws-tombra3.jpg?1639680124",
  6: "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/b013e38f-b1f0-4193-8d90-acfeae93d61a/detwz8i-5550bdcd-94be-46b6-bc8e-2d0ee6345847.jpg/v1/fill/w_700,h_1000,q_75,strp/kida_by_rossdraws_detwz8i-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTAwMCIsInBhdGgiOiJcL2ZcL2IwMTNlMzhmLWIxZjAtNDE5My04ZDkwLWFjZmVhZTkzZDYxYVwvZGV0d3o4aS01NTUwYmRjZC05NGJlLTQ2YjYtYmM4ZS0yZDBlZTYzNDU4NDcuanBnIiwid2lkdGgiOiI8PTcwMCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.Ovt2zDJW0jBLrzN3XkgN5VleLea-Px86bE4MoT8yoPs",
  7: "https://i.pinimg.com/originals/56/bd/57/56bd571a608112ff49aa105235ccd076.jpg",
  8: "https://i.pinimg.com/736x/44/7e/dc/447edc28ad81369dc75a754fa82e54ae.jpg",
  9: "https://cdna.artstation.com/p/assets/images/images/024/786/356/20200306124447/smaller_square/rossdraws-lyris-girl.jpg?1583520287",
  10: "https://w0.peakpx.com/wallpaper/556/856/HD-wallpaper-metamorphosis-fantasy-girl-orange-luminos-face-ross-tran-rossdraws.jpg",
  ImageStyle.anime: "https://animemotivation.com/wp-content/uploads/2022/05/klee-genshin-impact-anime-fanart.png",
  ImageStyle.oilPainting: "https://as1.ftcdn.net/v2/jpg/03/28/53/82/1000_F_328538275_TWuK5PAmHktvg0P0MBdS5tpzQ4EScX9w.jpg",
  ImageStyle.digitalArt: "https://i.pinimg.com/originals/61/c3/b1/61c3b11e7770bd68ac268d95dc6ee790.jpg",
  ImageStyle.model3d: "https://cdn.daz3d.com/file/dazcdn/media/home_page/new/process/skin.jpg",
  ImageStyle.photography: "https://i1.adis.ws/i/canon/pro-fine-art-photography-tips-1_a956e5554f9143789db8e529c097e410",
  ImageSaturation.high: "https://image.lexica.art/md2/163ed32a-18fa-475d-a46d-2920da6d11ef",
  ImageSaturation.low: "https://drawpaintacademy.com/wp-content/uploads/2018/06/Dan-Scott-Secrets-on-the-Lake-Overcast-Day-2016-1200W-Web.jpg",
  ImageValue.high: "https://wallpaperaccess.com/full/2741468.jpg",
  ImageValue.low: "https://img.artpal.com/23433/1-15-3-28-5-14-35m.jpg",
};
