import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/api_service/edit_details.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/api_service/get_user_details.dart';
import 'package:krishco/dashboard_type/channel_partner_ui/models/login_details_data.dart';
import 'package:krishco/models/transportation_related/transportation_list_data.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/cust_dialog_box/cust_dialog_box.dart';
import 'package:krishco/widgets/choose_file.dart';

class ConsumerEditDetailsScreen extends StatefulWidget {
  final VoidCallback? onUpdated;
  const ConsumerEditDetailsScreen({super.key, required this.onUpdated});

  @override
  State<ConsumerEditDetailsScreen> createState() =>
      _ConsumerEditDetailsScreenState();
}

class _ConsumerEditDetailsScreenState
    extends State<ConsumerEditDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<_EmergencyContactFormState> _contactFormKey =
  GlobalKey<_EmergencyContactFormState>();
  final GlobalKey<_TransportationDetailsState> _otherDetailsKey = GlobalKey<_TransportationDetailsState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _altContactNoController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _anniDataController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(
    text: 'India',
  );
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  bool _isLoading = false;
  File? _selectedProfile;
  String gender = 'male';
  String maritalStatus = 'unmarried';
  String memberId = 'N/A';
  String gstNo = 'N/A';
  List<EmergencyContact> _emergencyDetails = [];
  late Future<UserDetailsData?> userData;
  bool _isInitialized = false;

  final blue600 = Colors.blue.shade600;
  final red600 = Colors.red.shade600;
  final borderGray = Colors.grey.shade300;

  @override
  void initState() {
    super.initState();
    userData = GetUserDetails.getUserLoginDataInModel(context);
  }

  init(UserDetailsData data) async {
    memberId = data.tId.toString().replaceAll('[', '').replaceAll(']', '');
    gstNo = data.gstNo.toString();
    _firstNameController.text = data.fname ?? '';
    _lastNameController.text = data.lname ?? '';
    _contactNoController.text = data.contNo ?? '';
    _altContactNoController.text = data.altContNo ?? '';
    _emailTextController.text = data.email ?? '';
    _dobController.text = data.dob ?? '';
    gender = data.gender ?? '';
    maritalStatus = data.marStatus ?? '';
    _countryController.text = data.country ?? '';
    _stateController.text = data.state ?? '';
    _districtController.text = data.dist ?? '';
    _cityController.text = data.city ?? '';
    _pincodeController.text = data.pin ?? '';
    _addressController.text = data.address ?? '';
    _anniDataController.text = data.annDate ?? '';
    _emergencyDetails.addAll(
      data.emergencyContactDetails.map((t) {
        return EmergencyContact(
          name: t.emerName ?? '',
          contactNumber: t.emerContact ?? '',
          relationship: t.emerRelationship ?? '',
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Details')),
      body: SafeArea(
        child: FutureBuilder(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox.square(
                  dimension: 25,
                  child: CircularProgressIndicator(color: CustColors.nile_blue),
                ),
              );
            }

            if (snapshot.hasData) {
              final data = snapshot.data!;
              if (!_isInitialized) {
                init(data);
                _isInitialized = true;
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // _buildGroupSection(
                      //   title: 'Credentials Details',
                      //   subTitle: 'Not Editable',
                      //   child: _buildCredentialsDetails(
                      //     memberId: memberId,
                      //     gstNo: gstNo,
                      //   ),
                      // ),
                      _buildGroupSection(
                        title: 'Basic Details *',
                        subTitle: 'Note: Fill all mandatory(*) fields!!',
                        child: _buildBasicDetails(data),
                      ),
                      _buildGroupSection(
                        title: 'Address Information *',
                        child: _buildAddressDetails(),
                      ),
                      _buildGroupSection(
                        title: 'Emergency Contacts Details *',
                        child: EmergencyContactForm(
                          key: _contactFormKey,
                          initialContacts: _emergencyDetails,
                        ),
                      ),

                      _buildGroupSection(
                        title: 'Other Details (Optional)',
                        child: TransportationDetails(
                          key:_otherDetailsKey,
                          transporationIDs: data.tId ?? [],
                          gstNo: data.gstNo,
                          gstCopy: data.gstCopy,
                        ),
                      ),

                      _isLoading
                          ? Center(
                        child: SizedBox.square(
                          dimension: 25,
                          child: CircularProgressIndicator(
                            color: CustColors.nile_blue,
                          ),
                        ),
                      )
                          : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: _onUpdate,
                          child: Text('Update'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('Something went Wrong !!'));
            }
          },
        ),
      ),
    );
  }

  void _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedProfile = File(picked.path);
      });
    }
  }

  Widget _buildCredentialsDetails({
    required String memberId,
    required String gstNo,
  }) {
    return GridView.count(
      crossAxisSpacing: 16,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2,
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        _buildReadOnlyField(
          label: 'Member Id',
          icon: Icons.badge,
          value: memberId,
        ),
        _buildReadOnlyField(label: 'GST No', icon: Icons.badge, value: gstNo),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration.collapsed(
                    hintText: value,
                    border: InputBorder.none,
                    enabled: false,
                    hintStyle: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicDetails(UserDetailsData value) {
    return Column(
      children: [
        // Row(
        //   children: [
        //     Expanded(
        //       flex: 2,
        //       child: _profilePic != null ? CachedNetworkImage(
        //         fit: BoxFit.contain,
        //         imageUrl:'',
        //         // width: 40,
        //         // height: 40,
        //         placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        //         errorWidget: (context, url, error) => Image.asset('assets/logo/dummy_profile.webp'),
        //       ):CircleAvatar(
        //         radius: 60.0,
        //         backgroundImage: AssetImage('assets/logo/dummy_profile.webp'),
        //       ),
        //     ),
        //
        //     const SizedBox(width: 12.0,),
        //     Expanded(
        //       flex: 3,
        //       child: Column(
        //         children: [
        //           _buildTextFormField(controller: _customerFirstNameController, label: 'First name *', iconData: Icons.contact_page),
        //           const SizedBox(height: 12.0,),
        //           _buildTextFormField(controller: _customerLastNameController, label: 'Last name (Optional)', iconData: Icons.contact_page),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
        ProfileUpdateSection(
          imageUrl: value.photo,
          onEditImage: _pickProfileImage,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          selectedImageFile: _selectedProfile,
        ),
        const SizedBox(height: 24.0),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 8,
          childAspectRatio: 2.6,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            // DropdownButtonFormField<String>(
            //   decoration: InputDecoration(
            //     labelText: 'Group Category *',
            //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderGray)),
            //     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: blue600, width: 2)),
            //     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            //   ),
            //   value: 'Channel Partner',
            //   items: const [
            //     DropdownMenuItem(value: 'Channel Partner', child: Text('Channel Partner')),
            //   ],
            //   onChanged: (_) {},
            // ),
            _buildTextFormField(
              controller: _contactNoController,
              label: 'Contact No. (not editable)',
              iconData: Icons.phone,
              maxLength: 10,
              readOnly: true,
              textInputType: TextInputType.phone,
            ),
            _buildTextFormField(
              controller: _altContactNoController,
              label: 'Alt. Contact No. (Optional)',
              iconData: Icons.phone,
              maxLength: 10,
              textInputType: TextInputType.phone,
            ),
            _buildTextFormField(
              controller: _emailTextController,
              label: 'Email-Id (Optional)',
              iconData: Icons.email,
              textInputType: TextInputType.emailAddress,
            ),
            _buildTextFormField(
              controller: _dobController,
              isRequired: true,
              label: 'DOB (YYYY-MM-DD)*',
              iconData: Icons.calendar_month,
              textInputType: TextInputType.datetime,
              isDateField: true,
            ),
          ],
        ),
        // const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gender *',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            StatefulBuilder(
              builder: (context, refresh) {
                return Row(
                  children: [
                    Radio<String>(
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (val) => refresh(() => gender = val!),
                    ),
                    const Text('Male'),
                    Radio<String>(
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (val) => refresh(() => gender = val!),
                    ),
                    const Text('Female'),
                  ],
                );
              },
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Marital Status *',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            StatefulBuilder(
              builder: (context, refresh) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Unmarried',
                          groupValue: maritalStatus,
                          onChanged:
                              (val) => refresh(() => maritalStatus = val!),
                        ),
                        const Text('Unmarried'),
                        Radio<String>(
                          value: 'Married',
                          groupValue: maritalStatus,
                          onChanged:
                              (val) => refresh(() => maritalStatus = val!),
                        ),
                        const Text('Married'),
                      ],
                    ),
                    if (maritalStatus.toLowerCase() == 'married') ...[
                      const SizedBox(height: 8),
                      _buildTextFormField(
                        controller: _anniDataController,
                        label: 'Anniversary Date (YYYY-MM-DD)',
                        iconData: Icons.calendar_month,
                        textInputType: TextInputType.datetime,
                        isDateField: true,
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),

        // GridView.count(
        //   crossAxisCount: 2,
        //   mainAxisSpacing: 16.0,
        //   crossAxisSpacing: 8,
        //   childAspectRatio: 3,
        //   physics: NeverScrollableScrollPhysics(),
        //   shrinkWrap: true,
        //   children: [
        //
        //   ],
        // ),
      ],
    );
  }

  Widget _buildAddressDetails() {
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 8,
          childAspectRatio: 2.6,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            _buildTextFormField(
              controller: _countryController,
              label: 'Country *',
              iconData: Icons.public,
              readOnly: true,
            ),
            _buildTextFormField(
              controller: _stateController,
              isRequired: true,
              label: 'State *',
              iconData: Icons.map,
            ),
            _buildTextFormField(
              controller: _districtController,
              isRequired: true,
              label: 'District *',
              iconData: Icons.location_city,
            ),
            _buildTextFormField(
              controller: _cityController,
              isRequired: true,
              label: 'City *',
              iconData: Icons.location_city,
            ),
            _buildTextFormField(
              controller: _pincodeController,
              isRequired: true,
              label: 'Pincode *',
              iconData: Icons.pin_drop,
              textInputType: TextInputType.number,
              maxLength: 8,
              validator: (t) {
                if (t != null && t.isNotEmpty) {
                  int count = t.length;
                  if (count < 6) {
                    return 'Enter correct pin code';
                  }
                }
                return null;
              },
            ),
          ],
        ),
        // _buildTextFormField(controller: _addressController, label: 'Address *', iconData: Icons.home,maxLength: 100,maxLines: 3,),
        TextFormField(
          controller: _addressController,
          maxLines: 3,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: blue600, width: 2),
            ),
            labelText: 'Address (Optional)',
            border: const OutlineInputBorder(),
          ),
          // validator: (value) {
          // if (value == null || value.trim().isEmpty) {
          // return 'Enter Address';
          // }
          // return null;
          // },
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData iconData,
    bool isRequired = false,
    String? Function(String?)? validator,
    int? maxLength,
    bool readOnly = false,
    int? maxLines,
    TextInputType? textInputType,
    bool isDateField = false, // NEW
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      textAlignVertical: TextAlignVertical.center,
      maxLength: isDateField ? 10 : maxLength,
      keyboardType: isDateField ? TextInputType.number : textInputType,
      inputFormatters: isDateField ? [_DateFormatter()] : null,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData),
        contentPadding: EdgeInsets.zero,
        counterText: '',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: blue600, width: 2),
        ),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator:
      validator ??
              (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return 'Enter $label';
            }
            return null;
          },
    );
  }

  Widget _buildGroupSection({
    required String title,
    String? subTitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: [TextSpan(text: title)],
            ),
          ),
          if (subTitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.red.shade600,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  void _onUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final isValid = _contactFormKey.currentState?.validateAndSave() ?? false;
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final emergencyDetails = _contactFormKey.currentState?.getContacts();
    final otherDetails = _otherDetailsKey.currentState?.getValidatedData();
    final response = await EditDetails.updateDetails(
      context,
      first_name: _firstNameController.text,
      t_id: otherDetails?['t_id']??[],
      gst_no: otherDetails?['gst_no']??null,
      gst_copy: otherDetails?['gst_copy']??null,
      contact_no: _contactNoController.text,
      dob: _dobController.text,
      gender: gender,
      marital_status: maritalStatus,
      country: _countryController.text,
      state: _stateController.text,
      district: _districtController.text,
      city: _cityController.text,
      pincode: _pincodeController.text,
      address: _addressController.text,
      anni_date: _anniDataController.text,
      alt_contact_no: _altContactNoController.text,
      email: _emailTextController.text,
      last_name: _lastNameController.text,
      profile: _selectedProfile,
      emergency_details: emergencyDetails!,
    );
    if (response != null) {
      CustDialog.show(context: context, message: response['messages']);
      final data = await GetUserDetails.getUserLoginData(context);
      if (data != null) {
        final value = LoginDetailsData.fromJson(data);
        UserState.update(value.data);
      }
    } else {
      CustDialog.show(context: context, message: 'Failed to update');
    }
    setState(() {
      _isLoading = false;
    });
  }
}

class TransportationDetails extends StatefulWidget {
  final List<String?> transporationIDs;
  final String? gstNo;
  final String? gstCopy;

  TransportationDetails({
    super.key,
    required this.transporationIDs,
    this.gstNo,
    this.gstCopy,
  });
  @override
  State<TransportationDetails> createState() => _TransportationDetailsState();
}

class _TransportationDetailsState extends State<TransportationDetails> {
  final ValueNotifier<Map<String, String>?> transportationList =
  ValueNotifier<Map<String, String>?>(null);
  String? _selectedTransporter;
  Map<String, String> savedTransporter = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _gstCopyController = TextEditingController();
  File? _selecteGSTCopy;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<TransportationData> transporterList;
      final response =
      await APIService(
        context: context,
      ).transportationDetails.getTransportationList();
      if (response != null) {
        transporterList = TransportationDataList.fromJson(response).data;
        transportationList.value = Map<String, String>.fromEntries(
          transporterList.map(
                (x) => MapEntry(x.tId.toString(), '${x.tName} - ${x.contNo}'),
          ),
        );
        if (widget.transporationIDs.isNotEmpty)
          savedTransporter = Map<String, String>.fromEntries(
            widget.transporationIDs.whereType<String>().map((id) {
              final match = transporterList.firstWhere(
                    (x) => id.contains(x.tId.toString()),
              );
              return MapEntry(match.tId.toString(), '${match.tName} - ${match.contNo}');
            }),
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: transportationList,
      builder: (context, value, child) {
        if (value == null) {
          return SizedBox();
        }
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Note: ',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.red,
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Select transporter according to your preferences',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.black,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              Column(
                children:
                savedTransporter.entries
                    .toList()
                    .asMap()
                    .entries
                    .map<Widget>((entry) {
                  int index = entry.key;
                  MapEntry<dynamic, String?> item = entry.value;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          // offset: Offset(4, 4),
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 6.0,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(item.value ?? 'No name'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            savedTransporter.remove(item.key);
                          });
                        },
                      ),
                    ),
                  );
                })
                    .toList(),
              ),

              const SizedBox(height: 12.0),
              if (savedTransporter.length < 3)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Select Transporter (Optional)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        value: _selectedTransporter,
                        items:
                        value.entries
                            .where(
                              (entry) =>
                          !savedTransporter.containsKey(entry.key),
                        )
                            .map<DropdownMenuItem<String>>(
                              (item) => DropdownMenuItem(
                            value: item.key,
                            child: Text(item.value),
                          ),
                        )
                            .toList(),
                        onChanged:
                            (value) => setState(() {
                          _selectedTransporter = value;
                        }),
                        validator:
                            (value) =>
                        value == null ? 'Select a Transporter' : null,
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          _onAddTransporter(
                            _selectedTransporter!,
                            value[_selectedTransporter] ?? '',
                          );
                          setState(() {
                            _selectedTransporter =
                            null; // 🔄 Reset dropdown after add
                          });
                        },

                        child: Text('Add'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 18.0),
              _buildTextFormField(controller: _gstNumberController, label: 'GST Number', iconData: Icons.description),
              const SizedBox(height: 12.0),
              Text(' Upload GST Copy',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black,fontSize: 14.0),),
              const SizedBox(height: 4.0,),
              _buildImageSelector(selectedFile:_selecteGSTCopy,label: 'Choose file', controller: _gstCopyController, onFileSelected: (file){
                setState(() {
                  _selecteGSTCopy = file;
                });
              },onDelete: (){
                setState(() {
                  _selecteGSTCopy = null;
                });
              })
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSelector(
      {
        required String label,
        File? selectedFile,
        String? selectedImageUrl,
        required TextEditingController controller,
        required Function(File) onFileSelected,
        VoidCallback? onDelete,
      }
      ) {
    return GestureDetector(
      onTap: () {
        ChooseFile.showImagePickerBottomSheet(context, (file) {
          onFileSelected(file);
        });
      },
      child: Container(
        padding: EdgeInsets.all(2),
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(12),
        ),
        child:
        selectedFile == null && selectedImageUrl == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.photo_camera, color: Colors.grey),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: selectedFile != null ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      selectedFile,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        onDelete?.call();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ):
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(imageUrl: selectedImageUrl!,fit: BoxFit.contain,)),
            ),
            // SizedBox(height: 4),
            // Text(
            //   controller.text,
            //   style: TextStyle(fontSize: 12),
            //   overflow: TextOverflow.ellipsis,
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData iconData,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData),
        contentPadding: EdgeInsets.zero,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator:
      validator ??
              (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return 'Enter $label';
            }
            return null;
          },
    );
  }

  void _onAddTransporter(String id, String value) {
    setState(() {
      savedTransporter[id] = value;
    });
  }

  Map<String,dynamic> getValidatedData(){
    final Map<String,dynamic>data = {};
    data['t_id'] = List<String>.from(savedTransporter.entries.map((x)=>x.key));
    data['gst_no'] = _gstNumberController.text.trim();
    data['gst_copy'] = _selecteGSTCopy;
    return data;
  }

}

class ProfileUpdateSection extends StatefulWidget {
  final String? imageUrl; // Network URL
  final File? selectedImageFile; // New selected image
  final VoidCallback onEditImage;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  // final Key? key;

  const ProfileUpdateSection({
    // this.key,
    required this.imageUrl,
    required this.selectedImageFile,
    required this.onEditImage,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  State<ProfileUpdateSection> createState() => _ProfileUpdateSectionState();
}

class _ProfileUpdateSectionState extends State<ProfileUpdateSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Picture
        Expanded(
          flex: 2,
          child: Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                  widget.selectedImageFile != null
                      ? FileImage(widget.selectedImageFile!)
                      : widget.imageUrl != null &&
                      widget.imageUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(widget.imageUrl!)
                      : const AssetImage('assets/logo/dummy_profile.webp')
                  as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: widget.onEditImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // First & Last Name Fields
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildTextFormField(
                controller: widget.firstNameController,
                label: 'First name *',
                isRequired: true,
                iconData: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: widget.lastNameController,
                label: 'Last name (Optional)',
                iconData: Icons.person,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData iconData,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData),
        contentPadding: EdgeInsets.zero,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator:
      validator ??
              (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return 'Enter $label';
            }
            return null;
          },
    );
  }
}

class EmergencyContactForm extends StatefulWidget {
  final List<EmergencyContact> initialContacts;

  const EmergencyContactForm({super.key, this.initialContacts = const []});

  @override
  State<EmergencyContactForm> createState() => _EmergencyContactFormState();
}

class _EmergencyContactFormState extends State<EmergencyContactForm> {
  List<EmergencyContact> contacts = [];
  int? editingIndex;
  bool isAdding = false;
  String? selectedRelationship;
  final List<String> relativesName = [
    'Father',
    'Mother',
    'Brother',
    'Child',
    'Sister',
    'Friend',
    'Spouse',
    'Other',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contacts = List.from(widget.initialContacts);
    // if (contacts.isEmpty) contacts.add(EmergencyContact());
  }

  void _startEdit(int index) {
    setState(() {
      editingIndex = index;
      isAdding = false;
      _nameController.text = contacts[index].name;
      selectedRelationship = contacts[index].relationship;
      _phoneController.text = contacts[index].contactNumber;
    });
  }

  bool validateAndSave() {
    final isValid = contacts.every(
          (contact) =>
      contact.name.trim().isNotEmpty &&
          contact.relationship.trim().isNotEmpty &&
          contact.contactNumber.trim().isNotEmpty,
    );

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all emergency contact fields'),
        ),
      );
    }

    return isValid;
  }

  List<Map<String, String>> getContacts() {
    return contacts.map((e) => e.toMap()).toList();
  }

  void _saveEdit() {
    if (_validateInputs()) {
      setState(() {
        contacts[editingIndex!] = EmergencyContact(
          name: _nameController.text.trim(),
          relationship: selectedRelationship ?? '',
          contactNumber: _phoneController.text.trim(),
        );
        editingIndex = null;
        _clearInputs();
      });
    }
  }

  void _addNew() {
    if (_validateInputs()) {
      setState(() {
        contacts.add(
          EmergencyContact(
            name: _nameController.text.trim(),
            relationship: selectedRelationship!,
            contactNumber: _phoneController.text.trim(),
          ),
        );
        isAdding = false;
        _clearInputs();
      });
    }
  }

  void _deleteContact(int index) {
    if (contacts.length > 1) {
      setState(() {
        contacts.removeAt(index);
        if (editingIndex == index) editingIndex = null;
      });
    }
  }

  bool _validateInputs() {
    if (_nameController.text.trim().isEmpty ||
        selectedRelationship == null ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(18.0),
          backgroundColor: Colors.red,
          content: Text('Please fill all fields'),
        ),
      );
      return false;
    }
    return true;
  }

  void _clearInputs() {
    _nameController.clear();
    _relationshipController.clear();
    _phoneController.clear();
  }

  List<Map<String, String>> getContactData() {
    return contacts.map((e) => e.toMap()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            if (editingIndex == index) {
              return _buildInputCard(
                onSave: _saveEdit,
                onCancel: () => setState(() => editingIndex = null),
              );
            }

            final contact = contacts[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(contact.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Relationship: ${contact.relationship}'),
                  Text('Contact: ${contact.contactNumber}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _startEdit(index),
                  ),
                  if (contacts.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteContact(index),
                    ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 12.0),
        // Add new contact form
        if (isAdding)
          _buildInputCard(
            onSave: _addNew,
            onCancel: () => setState(() => isAdding = false),
          ),

        // Add new button
        if (!isAdding && editingIndex == null && contacts.length < 2)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                _clearInputs();
                setState(() {
                  isAdding = true;
                  editingIndex = null;
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Emergency Contact'),
            ),
          ),
      ],
    );
  }

  Widget _buildInputCard({
    required VoidCallback onSave,
    required VoidCallback onCancel,
  }) {
    final availableTypes =
    relativesName.where((r) {
      return contacts.every(
            (emergency) =>
        emergency.relationship != r ||
            (editingIndex != null &&
                contacts[editingIndex!].relationship == r),
      );
    }).toList();

    if (selectedRelationship != null &&
        !availableTypes.contains(selectedRelationship)) {
      availableTypes.add(selectedRelationship!);
    }

    return Column(
      children: [
        // _buildTextField(_relationshipController, 'Relationship *', Icons.group),
        DropdownButtonFormField<String>(
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            labelText: 'Select relationship *',
            border: OutlineInputBorder(),
          ),
          items:
          availableTypes
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          value: selectedRelationship,
          onChanged: (val) => setState(() => selectedRelationship = val),
          validator: (t) {
            if ((t == null || t.trim().isEmpty) && contacts.isEmpty) {
              return 'Select relationship';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        _buildTextField(_nameController, 'Name *', Icons.person),
        const SizedBox(height: 8),
        _buildTextField(
          _phoneController,
          'Contact Number *',
          Icons.phone,
          TextInputType.phone,
          10,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: onCancel, child: const Text('Cancel')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: onSave, child: const Text('Save')),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, [
        TextInputType inputType = TextInputType.text,
        int? maxLength,
      ]) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLength: maxLength,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        counterText: '',
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class EmergencyContact {
  final String name;
  final String relationship;
  final String contactNumber;

  EmergencyContact({
    this.name = '',
    this.relationship = '',
    this.contactNumber = '',
  });

  Map<String, String> toMap() => {
    'emer_name': name,
    'emer_relationship': relationship,
    'emer_contact': contactNumber,
  };
}

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    String formatted = '';
    for (int i = 0; i < digitsOnly.length && i < 8; i++) {
      formatted += digitsOnly[i];
      if (i == 3 || i == 5) formatted += '-';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}