import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/utils/download.dart';

class DownloadScheduleDialog extends StatefulWidget {
  const DownloadScheduleDialog({
    super.key,
    required this.schedules,
    required this.academicYearID
  });

  final List<Schedule> schedules;
  final String academicYearID;

  @override
  State<DownloadScheduleDialog> createState() => _DownloadScheduleDialogState();
}

class _DownloadScheduleDialogState extends State<DownloadScheduleDialog> {
  bool isLoading = false;

  savePdfFile() async {
    setState(() {
      isLoading = true;
    });
    await savePDF(widget.schedules, widget.academicYearID);
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("PDF Saved in Downloads!"),
        )
    );
  }

  saveExcelFile() async {
    setState(() {
      isLoading = true;
    });
    await saveExcel(widget.schedules, widget.academicYearID);
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Excel Saved in Downloads!"),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 150,
          width: 150,
          child: isLoading ? const Center(child: CircularProgressIndicator()) : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text(
                    'Download As',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded))
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: ElevatedButton (
                    onPressed: savePdfFile,
                    child: const Text('PDF'),
                  )
              ),
              const SizedBox(height: 15),
              Expanded(
                  child: ElevatedButton (
                    onPressed: saveExcelFile,
                    child: const Text('Excel'),
                  )
              )
            ],
          ),
      )
    );
  }
}
