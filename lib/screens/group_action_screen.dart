import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/repositories/group_repository.dart';
import 'package:split_trip/screens/group_list_screen.dart';
import 'package:split_trip/services/request_service.dart';
import 'package:split_trip/widgets/forms/create_group_form.dart';
import 'package:split_trip/widgets/theme_components/loader.dart';

import '../constants/theme_constants.dart';
import '../providers/loader_provider.dart';
import '../repositories/currency_repository.dart';
import '../services/auth_service.dart';

class GroupActionScreen extends StatefulWidget {
  static const String routeName = 'createGroupScreen';

  final Map? arguments;

  const GroupActionScreen({super.key, this.arguments});

  @override
  State<GroupActionScreen> createState() => GroupActionScreenState();
}

class GroupActionScreenState extends State<GroupActionScreen> {
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  Map errors = {};
  bool isLoading = false;
  List<dynamic> currencies = [];
  final ValueNotifier<Map<String, dynamic>> errorsNotifier = ValueNotifier({});

  @override
  void initState() {
    super.initState();

    formData['category'] = 'Other';
    isLoading = true;

    getCurrencies();

    errorsNotifier.addListener(() => setState(() {
      errors = errorsNotifier.value;
    }));
  }

  Future<void> getCurrencies() async {
    if (!mounted) return;

    final currencyRepository = context.read<CurrencyRepository>();

    final List? data = await RequestService.send<List>(context, currencyRepository.codes());

    setState(() {
      isLoading = false;
    });

    if (data == null) return;

    setState(() {
      currencies = data;
      isLoading = false;
    });

  }

  Future<void> save() async {
    if (!mounted) return;

    formKey.currentState?.save();

    final groupRepository = context.read<GroupRepository>();
    final loader = context.read<LoaderProvider>();

    loader.toggle();

    late Map<String, dynamic>? data;

    if (widget.arguments?['editMode'] ?? false) {
      data = await RequestService.send(context, groupRepository.update(widget.arguments!['group'].id, formData), errorsNotifier: errorsNotifier);
    } else {
      data = await RequestService.send(context, groupRepository.create(formData), errorsNotifier: errorsNotifier);
    }

    if (data == null) return;

    final AuthService authService = context.read<AuthService>();

    await authService.refreshUser();

    Navigator.pushNamedAndRemoveUntil(context, GroupListScreen.routeName, (r) => false);

    loader.toggle();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: screenLoader(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.arguments?['editMode'] ?? false ? 'Edit' : 'Add'} group"),
        actions: <Widget>[
          TextButton(
            onPressed: save,
            child: const Text('Save'),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: cAuthScreenBackgroundColor,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CreateGroupForm(
                    currencies: currencies,
                    formKey: formKey,
                    group: widget.arguments?['group'],
                    formData: formData,
                    categoryErrorText: errors['category'],
                    mainErrorText: errors['name'],
                  ),
                ),
              ),
            ),
            Consumer<LoaderProvider>(
              builder: (context, loader, child) => Visibility(
                visible: loader.show,
                child: Center(
                  child: screenLoader(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
