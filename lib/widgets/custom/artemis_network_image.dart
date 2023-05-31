import 'package:artemis/enums/artemis_placeholder.dart';
import 'package:artemis/utils/maps.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArtemisNetworkImage extends StatefulWidget {
  final String imageUrl;
  final Color? progressColor;

  const ArtemisNetworkImage(this.imageUrl, {super.key, this.progressColor});

  @override
  State<ArtemisNetworkImage> createState() => _ArtemisNetworkImageState();
}

class _ArtemisNetworkImageState extends State<ArtemisNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      placeholder: (BuildContext context, String string) {
        return Center(
          child: CircularProgressIndicator(
            color: widget.progressColor,
          ),
        );
      },
      errorWidget: (BuildContext context, String string, dynamic d) {
        return Image.asset(
          imageMapping[ArtemisPlaceholder.imageError]!,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
