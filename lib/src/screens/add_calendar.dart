// ignore_for_file: unnecessary_null_comparison

import 'package:edt/src/models/calendar.dart';
import 'package:edt/src/screens/qr_scanner.dart';
import 'package:edt/src/services/notifier.dart';
import 'package:edt/src/widgets/field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';

class AddCalendar extends StatefulWidget {
  const AddCalendar({super.key});

  @override
  State<AddCalendar> createState() => _AddCalendarState();
}

class _AddCalendarState extends State<AddCalendar> {
  int stepIndex = 0;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _controllerUrl = TextEditingController();
  late String _url;
  late String _name;
  Color color = Colors.blue;
  @override
  Widget build(BuildContext context) {
    EdtNotifier edtNotifier = Provider.of<EdtNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajout d'un EDT"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NumberStepper(
              numbers: [1, 2],
              numberStyle: TextStyle(color: Colors.white),
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              activeStepColor: Colors.blueAccent,
              activeStepBorderColor: Colors.blueAccent,
              lineColor: Colors.grey,
              activeStepBorderWidth: 1,
              activeStep: stepIndex,
              onStepReached: ((index) => setState(() {
                    stepIndex = index;
                  })),
            ),
          ),
          Offstage(
            offstage: stepIndex != 0,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Form(
                        key: _formKey1,
                        child: Column(children: [
                          fieldContainer("L'url de l'EDT", Icons.link_rounded,
                              false, TextInputType.url, onSaved: (text) {
                            _url = text ?? "";
                          }, onChanged: (text) {
                            _url = text ?? "";
                          }, controller: _controllerUrl),
                        ]))),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        "Ou bien",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 45),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () async {
                              final url = await Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QrScanner()));
                              print("================$url");
                              if (url != null) {
                                _url = url;
                                _controllerUrl.text = url;
                              }
                            },
                            child: Text("Scanner")),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      _formKey1.currentState!.save();
                      if (_url != null && _url != "") {
                        setState(() {
                          stepIndex++;
                        });
                      } else {
                        HapticFeedback.lightImpact();
                        Fluttertoast.showToast(msg: "L'url est obligatoire");
                      }
                    },
                    child: Text('Suivant'),
                  ),
                )
              ],
            ),
          ),
          Offstage(
            offstage: stepIndex != 1,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Form(
                        key: _formKey2,
                        child: Column(children: [
                          fieldContainer("Le nom de l'EDT", Icons.link_rounded,
                              false, TextInputType.text, onSaved: (text) {
                            _name = text ?? "";
                          }, onChanged: (text) {
                            _name = text ?? "";
                          }),
                        ]))),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: GestureDetector(
                    child: Container(
                      child: Center(child: Text("Coleur")),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(color: color),
                    ),
                    onTap: (() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Coleurs'),
                              content: BlockPicker(
                                pickerColor: color,
                                onColorChanged: ((value) {
                                  setState(() {
                                    color = value;
                                  });
                                  Navigator.pop(context);
                                }),
                              ),
                            );
                          });
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      _formKey2.currentState!.save();
                      if (_name != null && _name != "") {
                        final cal = Calendar(
                            id: 0,
                            name: _name,
                            uri: Uri.parse(_url),
                            color: color,
                            checked: true,
                            addedAt: DateTime.now());
                        int id =
                            await edtNotifier.localBdManager.insertCalenda(cal);
                        cal.id = id;
                        edtNotifier.addCalendar(cal);
                        Navigator.pop(context);
                      } else {
                        HapticFeedback.lightImpact();
                        Fluttertoast.showToast(msg: "Le nom est obligatoire");
                      }
                    },
                    child: Text('Ajouter'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
