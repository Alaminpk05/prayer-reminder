import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String icon;
  const DetailsPage({super.key, required this.title, required this.icon});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool? _isEnabled; // Nullable to represent loading state
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  Future<void> _loadSwitchState() async {
    _prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isEnabled = _prefs.getBool('${widget.title}_notification') ?? true;
        
      });
    }
  }

  Future<void> _toggleSwitch(bool value) async {
    await _prefs.setBool('${widget.title}_notification', value);
    if (mounted) {
      setState(() {
        _isEnabled = value;
      });
    }
    
    if (value) {
      debugPrint('Enable ${widget.title} notifications');
    } else {
      debugPrint('Disable ${widget.title} notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  child: Row(
                    children: [
                      SvgPicture.asset(widget.icon, width: 30, height: 30),
                      SizedBox(width: 3.w),
                      Text("${widget.title} Alarm"),
                    ],
                  ),
                ),
                trailing: _isEnabled == null
                    ? const CircularProgressIndicator() // Show loader while loading
                    : Switch.adaptive(
                        value: _isEnabled!,
                        onChanged: _toggleSwitch,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}