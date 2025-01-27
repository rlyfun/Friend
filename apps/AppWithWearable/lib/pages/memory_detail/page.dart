import 'dart:async';

import 'package:flutter/material.dart';
import 'package:friend_private/backend/storage/memories.dart';
import 'package:friend_private/flutter_flow/flutter_flow_theme.dart';
import 'package:friend_private/flutter_flow/flutter_flow_util.dart';
import 'package:friend_private/flutter_flow/flutter_flow_widgets.dart';
import 'package:friend_private/pages/memories/widgets/memory_operations.dart';
import 'package:friend_private/widgets/blur_bot_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryDetailPage extends StatefulWidget {
  final dynamic memory;

  const MemoryDetailPage({super.key, this.memory});

  @override
  State<MemoryDetailPage> createState() => _MemoryDetailPageState();
}

class _MemoryDetailPageState extends State<MemoryDetailPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unFocusNode = FocusNode();
  final focusTitleField = FocusNode();
  final focusOverviewField = FocusNode();

  late MemoryRecord memory;

  TextEditingController titleController = TextEditingController();
  TextEditingController overviewController = TextEditingController();
  bool editingTitle = false;
  bool editingOverview = false;

  @override
  void initState() {
    memory = MemoryRecord.fromJson(widget.memory);
    debugPrint(memory.toString());
    titleController.text = memory.structured.title;
    overviewController.text = memory.structured.overview;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    overviewController.dispose();
    focusTitleField.dispose();
    focusOverviewField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => unFocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(unFocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    context.safePop();
                  },
                  text: '',
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 24.0,
                  ),
                  options: FFButtonOptions(
                    width: 44.0,
                    height: 44.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: const Color(0x1AF7F4F4),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts:
                              GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).titleSmallFamily),
                        ),
                    elevation: 3.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                const Text('Memory Detail'),
                Row(
                  children: [
                    geyShareMemoryOperationWidget(memory),
                    const SizedBox(width: 16),
                    getDeleteMemoryOperationWidget(memory, unFocusNode, setState,
                        iconSize: 24, onDelete: () => Navigator.pop(context, true)),
                    const SizedBox(width: 8),
                  ],
                )
              ],
            ),
          ),
          body: Stack(
            children: [
              const BlurBotWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      '~ ${dateTimeFormat('MMM d, h:mm a', memory.createdAt)}',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    _getFieldHeader('title', focusTitleField),
                    _getEditTextField(titleController, editingTitle, focusTitleField),
                    _getEditTextFieldButtons(editingTitle, () {
                      setState(() {
                        editingTitle = false;
                        titleController.text = memory.structured.title;
                      });
                    }, () async {
                      await MemoryStorage.updateMemory(memory.id, titleController.text, memory.structured.title);
                      memory.structured.title = titleController.text;
                      setState(() {
                        editingTitle = false;
                      });
                    }),
                    const SizedBox(height: 32),
                    _getFieldHeader('overview', focusOverviewField),
                    _getEditTextField(overviewController, editingOverview, focusOverviewField),
                    _getEditTextFieldButtons(editingOverview, () {
                      setState(() {
                        editingOverview = false;
                        overviewController.text = memory.structured.overview;
                      });
                    }, () async {
                      await MemoryStorage.updateMemory(memory.id, memory.structured.title, overviewController.text);
                      memory.structured.overview = overviewController.text;
                      setState(() {
                        editingOverview = false;
                      });
                    }),
                    const SizedBox(height: 32),
                    memory.structured.actionItems.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // _getFieldHeader('Action Items'),
                              const Text('Action Items',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: memory.structured.actionItems
                                    .map((actionItem) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            '- $actionItem',
                                            style: TextStyle(color: Colors.grey.shade300, fontSize: 15, height: 1.3),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 32),
                            ],
                          )
                        : const SizedBox(),

                    const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Text('Raw Transcript:',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),
                    // Text(memory.transcript,
                    //     style: TextStyle(color: Colors.grey.shade300, fontSize: 15, height: 1.3)),
                    Container(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0x1AF7F4F4),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          memory.transcript,
                          style: TextStyle(color: Colors.grey.shade300, fontSize: 15, height: 1.3),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getFieldHeader(String field, FocusNode focusNode) {
    String name = '';
    if (field == 'title') {
      name = 'Title';
    } else if (field == 'overview') {
      name = 'Overview';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (field == 'title') {
                        editingTitle = true;
                      } else if (field == 'overview') {
                        editingOverview = true;
                      }
                    });
                    Timer(const Duration(milliseconds: 100), () => focusNode.requestFocus());
                  },
                  icon: Icon(
                    Icons.edit,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 22,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  _getEditTextField(TextEditingController controller, bool enabled, FocusNode focusNode) {
    // TODO: improve title field margin
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      focusNode: focusNode,
      maxLines: null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        contentPadding: EdgeInsets.all(0),
      ),
      enabled: enabled,
      style: TextStyle(color: Colors.grey.shade300, fontSize: 15, height: 1.3),
    );
  }

  _getEditTextFieldButtons(bool display, VoidCallback onCanceled, VoidCallback onSaved) {
    return display
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  onCanceled();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                  onPressed: () {
                    onSaved();
                  },
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(color: Colors.white),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white))),
            ],
          )
        : const SizedBox.shrink();
  }
}
