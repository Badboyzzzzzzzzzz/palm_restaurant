import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(String)? onSortSelected;
  final Function(double, double)? onPriceRangeSelected;

  const FilterBottomSheet({
    Key? key,
    this.onSortSelected,
    this.onPriceRangeSelected,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedSortOption;
  RangeValues _currentRangeValues = const RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Sort By',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              _filterChip('Price: Low to High'),
              _filterChip('Price: High to Low'),
              _filterChip('Popularity'),
              _filterChip('Newest First'),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Price Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          _buildPriceRangeSlider(),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              if (_selectedSortOption != null &&
                  widget.onSortSelected != null) {
                widget.onSortSelected!(_selectedSortOption!);
              }

              if (widget.onPriceRangeSelected != null) {
                widget.onPriceRangeSelected!(
                    _currentRangeValues.start, _currentRangeValues.end);
              }

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF5D248),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Apply Filters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        RangeSlider(
          values: _currentRangeValues,
          max: 100,
          divisions: 10,
          activeColor: Color(0xFFF5D248),
          inactiveColor: Colors.grey[300],
          labels: RangeLabels(
            '\$${_currentRangeValues.start.round()}',
            '\$${_currentRangeValues.end.round()}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${_currentRangeValues.start.round()}'),
              Text('\$${_currentRangeValues.end.round()}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _selectedSortOption == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSortOption = label;
        });
      },
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Color(0xFFF5D248) : Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: TextStyle(
          fontSize: 14,
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
