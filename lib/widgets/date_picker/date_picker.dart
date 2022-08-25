//  Gaze Widgets Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../button/button.dart';
import '../list/list_view.dart';
import 'extensions.dart';

class GazeDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime, BuildContext)? selected;
  final void Function(BuildContext)? cancelled;

  final String cancelLabel;
  final String selectLabel;

  final String route;
  GazeDatePicker({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.route,
    this.selected,
    this.cancelled,
    this.cancelLabel = 'Cancel',
    this.selectLabel = 'Select',
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GazeDatePickerState();
}

class _GazeDatePickerState extends State<GazeDatePicker> with TickerProviderStateMixin {
  List<int> _list = [-2, -1, 0, 1, 2];
  late final int _initialIndex = (_list.length / 2).floor();
  late DateTime _current = widget.initialDate;
  late final PageController _pageController = PageController(initialPage: _initialIndex, viewportFraction: 1);

  late final AnimationController _animationControllerYear = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  late final Animation<Offset> _animationYear = Tween<Offset>(
    begin: const Offset(0, -1),
    end: const Offset(0, 0),
  ).animate(CurvedAnimation(
    parent: _animationControllerYear,
    curve: Curves.easeOut,
  ));

  late final AnimationController _animationControllerMonth = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  late final Animation<Offset> _animationMonth = Tween<Offset>(
    begin: const Offset(0, 0),
    end: const Offset(0, 1),
  ).animate(CurvedAnimation(
    parent: _animationControllerMonth,
    curve: Curves.easeOut,
  ));

  final ScrollController _scrollController = ScrollController();
  final yearsPerRow = 7;

  _GazeDatePickerState();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_listener);
  }

  @override
  void dispose() {
    _animationControllerYear.dispose();
    _animationControllerMonth.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _listener() {
    // Round the index according to direction
    final index = _pageController.page! > _initialIndex ? _pageController.page!.floor() : _pageController.page!.ceil();

    final blockNext = widget.lastDate.isSameMonth(_current);
    final blockPrevious = widget.firstDate.isSameMonth(_current);
    if (blockNext && _pageController.page! > _initialIndex || blockPrevious && _pageController.page! < _initialIndex) {
      _pageController.jumpToPage(_initialIndex);
    }
    if (index == _initialIndex) return;

    if (index == _initialIndex - 1) {
      _prevMonth();
    } else if (index == _initialIndex + 1) {
      _nextMonth();
    }
  }

  void _prevMonth() {
    setState(() {
      _list
        ..insert(0, _list.first - 1)
        ..removeLast();
      _current = DateTime(_current.year, _current.month - 1, _current.day);
    });
    _pageController.jumpToPage(_initialIndex);
  }

  void _nextMonth() {
    setState(() {
      _list
        ..removeAt(0)
        ..insert(_list.length, _list.last + 1);
      _current = DateTime(_current.year, _current.month + 1, _current.day);
    });
    _pageController.jumpToPage(_initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade900,
      ),
      child: Stack(
        children: [
          SlideTransition(
            position: _animationYear,
            child: GazeListView(
              route: widget.route,
              controller: _scrollController,
              wrappedWidget: Padding(
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: widget.lastDate.year - widget.firstDate.year + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: yearsPerRow,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    final thisYear = widget.firstDate.year + index;
                    return GazeButton(
                      properties: GazeButtonProperties(
                        key: GlobalKey(),
                        route: widget.route,
                        backgroundColor: _current.year == thisYear ? Theme.of(context).primaryColor : Colors.transparent,
                        text: '$thisYear',
                      ),
                      onTap: () {
                        setState(() {
                          _list = _list.map((e) {
                            return e + 12 * (thisYear - _current.year);
                          }).toList();
                          _current = DateTime(thisYear, _current.month, _current.day);
                        });
                        _goToMonth();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          SlideTransition(
            position: _animationMonth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                control(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      final years = (_list[index] / 12).floor();
                      final months = _list[index] % 12;
                      return month(DateTime(widget.initialDate.year + years, widget.initialDate.month + months, widget.initialDate.day));
                    },
                  ),
                ),
                submit(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToMonth() {
    _animationControllerMonth.reverse();
    _animationControllerYear.reverse();
  }

  void _goToYears() {
    final years = (widget.lastDate.year - widget.firstDate.year + 1);
    final rows = (years / yearsPerRow);
    final rowHeight = _scrollController.position.maxScrollExtent / rows;

    final currentIndex = _current.year - widget.firstDate.year;
    final currentRow = currentIndex / yearsPerRow;

    _scrollController.jumpTo(rowHeight * currentRow);
    _animationControllerMonth.forward();
    _animationControllerYear.forward();
  }

  Widget control() {
    final blockNext = widget.lastDate.isSameMonth(_current);
    final blockPrevious = widget.firstDate.isSameMonth(_current);

    return Padding(
      padding: const EdgeInsets.fromLTRB(80, 40, 80, 20),
      child: Row(
        children: [
          Text(
            DateFormat('EEE, MMM d').format(_current),
            style: Theme.of(context).primaryTextTheme.headline1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: GazeButton(
              properties: GazeButtonProperties(
                key: GlobalKey(),
                route: widget.route,
                innerPadding: const EdgeInsets.all(0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).primaryColor, width: 3),
                  ),
                  child: Text(
                    '${_current.year}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.headline1,
                  ),
                ),
              ),
              onTap: _goToYears,
            ),
          ),
          const Spacer(),
          Expanded(
            child: GazeButton(
              properties: GazeButtonProperties(
                key: GlobalKey(),
                route: widget.route,
                icon: Icon(
                  Icons.arrow_back,
                  color: blockPrevious ? Colors.white54 : Colors.white,
                ),
                horizontal: true,
                gazeInteractive: !blockPrevious,
              ),
              onTap: blockPrevious ? null : _prevMonth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Text(
              DateFormat('MMMM').format(_current),
              style: Theme.of(context).primaryTextTheme.headline1,
            ),
          ),
          Expanded(
            child: GazeButton(
              properties: GazeButtonProperties(
                key: GlobalKey(),
                route: widget.route,
                icon: Icon(
                  Icons.arrow_forward,
                  color: blockNext ? Colors.white54 : Colors.white,
                ),
                horizontal: true,
                gazeInteractive: !blockNext,
              ),
              onTap: blockNext ? null : _nextMonth,
            ),
          ),
        ],
      ),
    );
  }

  Widget submit() {
    return Row(
      children: [
        const Spacer(flex: 3),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 40),
            child: GazeButton(
              properties: GazeButtonProperties(
                key: GlobalKey(),
                route: widget.route,
                text: widget.cancelLabel,
              ),
              onTap: () {
                if (widget.cancelled != null) widget.cancelled!(context);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 40),
            child: GazeButton(
              properties: GazeButtonProperties(
                key: GlobalKey(),
                route: widget.route,
                text: widget.selectLabel,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onTap: () {
                if (widget.selected != null) widget.selected!(_current, context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget month(DateTime month) {
    final firstWeekday = DateTime(month.year, month.month).weekday;
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    final weeks = ((lastDay + firstWeekday) / 7).ceil();
    final style = Theme.of(context).primaryTextTheme.headline2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('MON', style: style),
                Text('TUE', style: style),
                Text('WEN', style: style),
                Text('THU', style: style),
                Text('FRI', style: style),
                Text('SAT', style: style),
                Text('SUN', style: style),
              ],
            ),
          ),
          const Divider(),
          for (var w = 0; w < weeks; w++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var d = 1; d <= 7; d++) dateButton(month, w, d, firstWeekday, lastDay),
              ],
            )
        ],
      ),
    );
  }

  Widget dateButton(DateTime month, int w, int d, int firstWeekday, int lastDay) {
    // Everything is counting with a starting 0 so add 1 in the end.
    // Calculate the actual day
    final day = (d + (w * 7)) - firstWeekday + 1;

    final thisDay = DateTime(month.year, month.month, day);
    final isToday = DateTime.now().isSameDay(thisDay);

    final tooLate = thisDay.isAfter(widget.lastDate);
    final tooEarly = thisDay.isBefore(widget.firstDate);

    final tooEaryOrTooLate = tooEarly || tooLate;
    final actionable = _current.day != day && !tooLate && !tooEarly;

    if ((w == 0 && d < firstWeekday) || day > lastDay) {
      return Spacer();
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: GazeButton(
            properties: GazeButtonProperties(
              key: GlobalKey(),
              route: widget.route,
              text: '$day',
              textColor: tooEaryOrTooLate ? Colors.white54 : Colors.white,
              borderColor: isToday ? Theme.of(context).primaryColor : Colors.transparent,
              backgroundColor: _current.day == day ? Theme.of(context).primaryColor : Colors.transparent,
              gazeInteractive: actionable,
            ),
            onTap: actionable
                ? () {
                    setState(
                      () {
                        _current = DateTime(_current.year, _current.month, day);
                      },
                    );
                  }
                : null,
          ),
        ),
      );
    }
  }
}
