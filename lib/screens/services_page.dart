import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/service_model.dart';
import '../provider/api_service_provider.dart';
import '../services/firestore_service.dart';

class ServicesPage extends ConsumerStatefulWidget {
  const ServicesPage({super.key});

  @override
  ConsumerState<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends ConsumerState<ServicesPage> {
  // State variables
  List<Service> _services = [];
  Map<String, Map<String, List<Service>>> _servicesByParentAndSubcategory = {};
  List<String> _parentCategories = [];
  String? _selectedParentCategory;
  String? _selectedSubcategory;
  Service? _selectedService;
  List<String> _subcategories = [];
  List<Service> _availableServices = [];
  bool _isDripFeed = false;
  double _totalCharge = 0.0;

  // Controllers and Keys
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Theme Colors from images
  final Color _backgroundColor = const Color(0xFF1E2434);
  final Color _containerColor = const Color(0xFF2B3246);
  final Color _inputColor = const Color(0xFF3A425A);
  final Color _orangeAccent = Colors.orange;
  final Color _textColor = Colors.white;
  final Color _subTextColor = Colors.white70;

  @override
  void initState() {
    super.initState();
    _loadServices();
    _quantityController.addListener(_updateCharge);
  }

  @override
  void dispose() {
    _linkController.dispose();
    _quantityController.removeListener(_updateCharge);
    _quantityController.dispose();
    super.dispose();
  }

  void _updateCharge() {
    if (_selectedService != null) {
      final quantity = int.tryParse(_quantityController.text);
      if (quantity != null) {
        setState(() {
          _totalCharge = (quantity / 1000) * _selectedService!.rate;
        });
      } else {
        setState(() {
          _totalCharge = 0.0;
        });
      }
    }
  }

  Future<void> _loadServices() async {
    final apiService = ref.read(apiServiceProvider);
    try {
      final servicesData = await apiService.fetchServices();
      final services = servicesData
          .map((data) => Service.fromJson(data))
          .toList();
      Map<String, Map<String, List<Service>>> categorizedServices = {};
      for (var service in services) {
        String parentCategory = _determineParentCategory(service);
        String subcategory = service.category;
        categorizedServices
            .putIfAbsent(parentCategory, () => {})
            .putIfAbsent(subcategory, () => [])
            .add(service);
      }
      final parentCategories = categorizedServices.keys.toList()..sort();
      parentCategories.add('Everything');
      if (mounted) {
        setState(() {
          _services = services;
          _servicesByParentAndSubcategory = categorizedServices;
          _parentCategories = parentCategories;
          _selectedParentCategory = 'Instagram';
          if (!_parentCategories.contains('Instagram') &&
              _parentCategories.isNotEmpty) {
            _selectedParentCategory = _parentCategories.first;
          }
          _updateSubcategories();
        });
      }
    } catch (e) {
      print('Error loading services: $e');
    }
  }

  void _updateSubcategories() {
    if (_selectedParentCategory != null &&
        _servicesByParentAndSubcategory.containsKey(_selectedParentCategory)) {
      final subcategoryList =
          _servicesByParentAndSubcategory[_selectedParentCategory]!.keys
              .toList()
            ..sort();
      setState(() {
        _subcategories = subcategoryList;
        _selectedSubcategory = _subcategories.isNotEmpty
            ? _subcategories.first
            : null;
        _updateServices();
      });
    } else {
      setState(() {
        _subcategories = [];
        _selectedSubcategory = null;
        _availableServices = [];
        _selectedService = null;
      });
    }
  }

  void _updateServices() {
    if (_selectedParentCategory != null && _selectedSubcategory != null) {
      setState(() {
        _availableServices =
            _servicesByParentAndSubcategory[_selectedParentCategory]![_selectedSubcategory] ??
            [];
        _availableServices.sort((a, b) => a.name.compareTo(b.name));
        _selectedService = _availableServices.isNotEmpty
            ? _availableServices.first
            : null;
        _linkController.clear();
        _quantityController.clear();
      });
    }
  }

  // Logic and Helper methods (determineParentCategory, getIconForCategory) remain the same as the previous step.
  String _determineParentCategory(Service service) {
    String category = service.category.toLowerCase();
    String name = service.name.toLowerCase();

    if (category.contains('instagram') ||
        name.contains('instagram') ||
        category.contains('threads')) {
      return 'Instagram';
    } else if (category.contains('facebook') || name.contains('facebook')) {
      return 'Facebook';
    } else if (category.contains('youtube') || name.contains('youtube')) {
      return 'Youtube';
    } else if (category.contains('twitter') ||
        name.contains('twitter') ||
        category.contains('x')) {
      return 'X (Twitter)';
    } else if (category.contains('spotify') || name.contains('spotify')) {
      return 'Spotify';
    } else if (category.contains('tiktok') || name.contains('tiktok')) {
      return 'TikTok';
    } else if (category.contains('linkedin') || name.contains('linkedin')) {
      return 'LinkedIn';
    } else if (category.contains('google') || name.contains('google')) {
      return 'Google';
    } else if (category.contains('telegram') || name.contains('telegram')) {
      return 'Telegram';
    } else if (category.contains('discord') || name.contains('discord')) {
      return 'Discord';
    } else if (category.contains('snapchat') || name.contains('snapchat')) {
      return 'Snapchat';
    } else if (category.contains('twitch') || name.contains('twitch')) {
      return 'Twitch';
    } else if (category.contains('traffic') ||
        category.contains('website') ||
        name.contains('traffic')) {
      return 'Website Traffic';
    } else if (category.contains('review') || name.contains('review')) {
      return 'Reviews';
    } else {
      return 'Others';
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Instagram':
        return Icons.camera_alt_outlined;
      case 'Facebook':
        return Icons.facebook;
      case 'Youtube':
        return Icons.play_circle_outline;
      case 'X (Twitter)':
        return Icons.chat_bubble_outline;
      case 'Spotify':
        return Icons.music_note_outlined;
      case 'TikTok':
        return Icons.video_library_outlined;
      case 'LinkedIn':
        return Icons.business_center_outlined;
      case 'Google':
        return Icons.search;
      case 'Telegram':
        return Icons.send_outlined;
      case 'Discord':
        return Icons.chat_outlined;
      case 'Snapchat':
        return Icons.photo_camera_outlined;
      case 'Twitch':
        return Icons.live_tv_outlined;
      case 'Website Traffic':
        return Icons.language_outlined;
      case 'Reviews':
        return Icons.star_rate_outlined;
      case 'Others':
        return Icons.add_circle_outline;
      case 'Everything':
        return Icons.segment;
      default:
        return Icons.public;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _backgroundColor,
      child: _services.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_orangeAccent),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySelector(),
                  const SizedBox(height: 24),
                  _buildOrderTypeTabs(),
                  const SizedBox(height: 16),
                  _buildResponsiveOrderLayout(),
                ],
              ),
            ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _containerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CHOOSE A SOCIAL NETWORK',
                style: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'Hide the filter',
                      style: TextStyle(color: _subTextColor),
                    ),
                    Icon(Icons.arrow_drop_down, color: _subTextColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: _parentCategories.length,
            itemBuilder: (context, index) {
              final category = _parentCategories[index];
              final isSelected = _selectedParentCategory == category;
              return Material(
                color: isSelected ? _orangeAccent : _inputColor,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => setState(() {
                    _selectedParentCategory = category;
                    _updateSubcategories();
                  }),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          _getIconForCategory(category),
                          size: 18,
                          color: _textColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            category,
                            style: TextStyle(fontSize: 11, color: _textColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypeTabs() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _orangeAccent,
              foregroundColor: _textColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('NEW ORDER'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _inputColor,
              foregroundColor: _subTextColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('MY FAVORITE'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _inputColor,
              foregroundColor: _subTextColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('AUTO SUBSCRIPTION'),
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveOrderLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 850) {
          // Two-column layout for wider screens
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildOrderFormContainer()),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _buildServiceDetailsContainer()),
            ],
          );
        } else {
          // Single-column layout for narrower screens
          return Column(
            children: [
              _buildOrderFormContainer(),
              const SizedBox(height: 16),
              _buildServiceDetailsContainer(),
            ],
          );
        }
      },
    );
  }

  Widget _buildOrderFormContainer() {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: _inputColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: _subTextColor),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _containerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextFormField(
              decoration: inputDecoration.copyWith(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: _subTextColor),
              ),
            ),
            const SizedBox(height: 12),
            // Subcategory Dropdown
            _buildDarkDropdown(
              hint: 'Favorite services',
              value: _selectedSubcategory,
              items: _subcategories,
              onChanged: (value) => setState(() {
                _selectedSubcategory = value;
                _updateServices();
              }),
            ),
            const SizedBox(height: 12),
            // Service Dropdown
            _buildDarkDropdown(
              hint: 'Select a service',
              value: _selectedService,
              items: _availableServices,
              onChanged: (value) => setState(() {
                _selectedService = value as Service?;
                _linkController.clear();
                _quantityController.clear();
              }),
              isService: true,
            ),
            if (_selectedService != null) ...[
              const SizedBox(height: 16),
              Text('Link', style: TextStyle(color: _textColor)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _linkController,
                style: TextStyle(color: _textColor),
                decoration: inputDecoration.copyWith(hintText: 'Enter link'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter a link' : null,
              ),
              const SizedBox(height: 16),
              Text('Quantity', style: TextStyle(color: _textColor)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: _textColor),
                decoration: inputDecoration.copyWith(
                  hintText: 'Enter quantity',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter a quantity';
                  final q = int.tryParse(v);
                  if (q == null) return 'Invalid number';
                  if (q < _selectedService!.min)
                    return 'Minimum is ${_selectedService!.min}';
                  if (q > _selectedService!.max)
                    return 'Maximum is ${_selectedService!.max}';
                  return null;
                },
              ),
              const SizedBox(height: 4),
              Text(
                'Min: ${_selectedService!.min} - Max: ${_selectedService!.max}',
                style: TextStyle(color: _subTextColor, fontSize: 12),
              ),
              CheckboxListTile(
                value: _isDripFeed,
                onChanged: (val) => setState(() => _isDripFeed = val!),
                title: Text('Drip-feed', style: TextStyle(color: _textColor)),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: _orangeAccent,
              ),
              const SizedBox(height: 16),
              Text('Charge', style: TextStyle(color: _textColor)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _inputColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _totalCharge.toStringAsFixed(4),
                  style: TextStyle(
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    /* Place order logic */
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orangeAccent,
                    foregroundColor: _textColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('SUBMIT'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDarkDropdown({
    String? hint,
    dynamic value,
    required List items,
    Function(dynamic)? onChanged,
    bool isService = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: _inputColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: value,
          isExpanded: true,
          hint: Text(hint ?? '', style: TextStyle(color: _subTextColor)),
          icon: Icon(Icons.arrow_drop_down, color: _subTextColor),
          dropdownColor: _inputColor,
          style: TextStyle(color: _textColor),
          items: items.map((item) {
            return DropdownMenuItem<dynamic>(
              value: item,
              child: Text(
                isService ? (item as Service).name : item.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildServiceDetailsContainer() {
    if (_selectedService == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _containerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NEW ORDER',
                style: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    style: TextStyle(color: _textColor),
                    decoration: InputDecoration(
                      hintText: 'Search for your orders',
                      hintStyle: TextStyle(color: _subTextColor, fontSize: 12),
                      filled: true,
                      fillColor: _inputColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            '${_selectedService!.serviceId} - ${_selectedService!.name}',
            style: TextStyle(color: _textColor, fontSize: 13),
          ),
          const SizedBox(height: 8),
          _buildServiceDetailRow('START TIME', '0 - 1 Hr'), // Placeholder data
          _buildServiceDetailRow('SPEED', 'Up to 1M/D'), // Placeholder data
          _buildServiceDetailRow('GUARANTEED', 'Nop'), // Placeholder data
          _buildServiceDetailRow(
            'AVERAGE TIME',
            '24 Hours',
          ), // Placeholder data
          const SizedBox(height: 16),
          Text(
            'DESCRIPTION',
            style: TextStyle(color: _subTextColor, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            'Sample link format:\nhttps://coinmarketcap.com/community/post/342320697', // Placeholder
            style: TextStyle(color: _orangeAccent, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: _subTextColor, fontSize: 12)),
          Text(
            value,
            style: TextStyle(
              color: _textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
