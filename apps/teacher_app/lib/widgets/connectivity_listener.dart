import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/sensitive_connectivity/connectivity_bloc.dart';

class ConnectivityListener extends StatelessWidget {
  final Widget child;

  const ConnectivityListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityOffline) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('connectivity.offline'.tr()),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is ConnectivityOnline) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('connectivity.online'.tr()),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is ConnectivityRetrying) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('connectivity.retrying'.tr()),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is ConnectivityMaxRetriesExceeded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('connectivity.max_retries_exceeded'.tr()),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'connectivity.retry'.tr(),
                textColor: Colors.white,
                onPressed: () {
                  context.read<ConnectivityBloc>().add(const CheckConnectivity());
                },
              ),
            ),
          );
        }
      },
      child: child,
    );
  }
} 