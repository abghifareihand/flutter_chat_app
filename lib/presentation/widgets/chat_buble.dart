import 'package:flutter/material.dart';

enum BubbleType {
  top,
  middle,
  bottom,
  alone,
}

enum Direction {
  left,
  right,
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.direction,
    required this.message,
    required this.type,
    required this.photoUrl,
    required this.messageTime,
  });
  final Direction direction;
  final String message;
  final String photoUrl;
  final BubbleType type;
  final String messageTime;

  @override
  Widget build(BuildContext context) {
    final isOnLeft = direction == Direction.left;
    return Column(
      crossAxisAlignment:
          isOnLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment:
              isOnLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // if (isOnLeft) _buildLeading(type),
            // SizedBox(width: isOnLeft ? 4 : 0),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: _borderRadius(direction, type),
                color: isOnLeft
                    ? const Color(0XFFEDFCFD)
                    : const Color(0XFF0BCAD4),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: isOnLeft ? const Color(0xff112340) : Colors.white,
                ),
              ),
            ),
          ],
        ),
        Text(
          messageTime,
          style: TextStyle(
            fontSize: 10,
            color: isOnLeft ? const Color(0XFF7D8797) : const Color(0XFF7D8797),
          ),
        ),
      ],
    );
  }

  // Widget _buildLeading(BubbleType type) {
  //   if (type == BubbleType.alone || type == BubbleType.bottom) {
  //     // return const Avatar(
  //     //   radius: 12,
  //     // );
  //     return CircleAvatar(
  //       backgroundColor: Colors.grey[200],
  //       radius: 12,
  //       child: Text(
  //         photoUrl,
  //         style: const TextStyle(
  //           fontSize: 12,
  //         ),
  //       ),
  //     );
  //   }
  //   return const SizedBox(width: 24);
  // }

  BorderRadius _borderRadius(Direction dir, BubbleType type) {
    const radius1 = Radius.circular(15);
    const radius2 = Radius.circular(5);
    switch (type) {
      case BubbleType.top:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius1,
                topRight: radius1,
                bottomLeft: radius2,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius1,
                bottomLeft: radius1,
                bottomRight: radius2,
              );

      case BubbleType.middle:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius2,
                topRight: radius1,
                bottomLeft: radius2,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius2,
                bottomLeft: radius1,
                bottomRight: radius2,
              );
      case BubbleType.bottom:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius2,
                topRight: radius1,
                bottomLeft: radius1,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius2,
                bottomLeft: radius1,
                bottomRight: radius1,
              );
      case BubbleType.alone:
        return BorderRadius.circular(15);
    }
  }
}
