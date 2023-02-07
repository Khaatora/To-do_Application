import 'package:flutter/material.dart';

showLoading(BuildContext context, String message, bool isBarrierDissmisible) {
  showDialog(
    context: context,
    barrierDismissible: isBarrierDissmisible,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              width: 5,
            ),
            Flexible(
                child: Text(
              message,
              textAlign: TextAlign.center,
            ))
          ],
        ),
      ),
    ),
  );
}

hideLoading(BuildContext context) {
  popNavigator(context);
}

void showMessage(BuildContext context, String message, String posBtnText,
    VoidCallback posAction,
    {String? negBtn, VoidCallback? negAction}) {
  showDialog(
    context: context,
    builder: (context) {
      List<Widget> Actions = [
        TextButton(onPressed: posAction, child: Text(posBtnText))
      ];
      if (negBtn != null) {
        Actions.add(TextButton(onPressed: negAction, child: Text(negBtn)));
      }
      return AlertDialog(
        title: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              message,
              style: ThemeData().textTheme.subtitle1,
            )),
        actions: Actions,
      );
    },
  );
}

void popNavigator(context) {
  Navigator.pop(context);
}
